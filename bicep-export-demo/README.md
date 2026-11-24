# Bicep export demo: bring existing Azure resources under Bicep management

Demonstrates how to take resources that were created manually (portal / CLI, "ClickOps") and convert them into Bicep code.

## 1. Deploy the "unmanaged" starting point

`deploy-demo-resources.ps1` creates resources **imperatively with az CLI** (no IaC) in `rg-bicep-export-demo-swec-01` (Sweden Central). The script is idempotent.

```powershell
az login
./deploy-demo-resources.ps1 -SubscriptionName sub-general-demos-swec-01
```

| Resource | SKU / notes | Approx. cost |
|---|---|---|
| Log Analytics workspace | PerGB2018, 30 days retention | ~free (minimal ingestion) |
| Storage account + `data` container | Standard_LRS, TLS1.2, no public blob access | ~free when empty |
| NSG with `Allow-HTTPS-Inbound` rule | | free |
| VNet `10.50.0.0/16`, `snet-app` (NSG), `snet-data` (service endpoint) | | free |
| User-assigned managed identity | | free |
| Key Vault | Standard, RBAC, 7-day soft delete | ~free (no operations) |
| App Service plan + Linux web app | **F1 Free**, Node 24, HTTPS only, UAMI, app settings | free |
| Role assignments (UAMI -> Storage Blob Data Reader, Key Vault Secrets User) | | free |
| Diagnostic settings (Key Vault, blob service -> Log Analytics) | | ~free |

The mix is intentional: parent/child resources (VNet/subnets, storage/container), cross-resource references (subnet -> NSG, web app -> plan/identity), and **extension resources** (role assignments, diagnostic settings) that typical export tools miss.

## 2. Demo flow

| File | Purpose |
|---|---|
| `deploy-demo-resources.ps1` | Creates the "unmanaged" starting point (step 1) |
| `export-to-bicep.ps1` | Exports resource groups to `export/<rg>/` (raw JSON, decompiled Bicep, missing extension resources) |
| `bicep/main.bicep` + `main.bicepparam` | Reference result after refactoring (what you should end up with) |
| `deploy-bicep.ps1` | What-if / deploy / deploy as deployment stack |

### a. Export to Bicep
```powershell
./export-to-bicep.ps1 -ResourceGroupNames rg-bicep-export-demo-swec-01
# or every resource group of the subscription:
./export-to-bicep.ps1 -SubscriptionName sub-general-demos-swec-01
```
Per resource group, `export/<rg>/` contains:

| File | Content |
|---|---|
| `main.json` / `main.bicep` | Raw `az group export` and its `az bicep decompile` |
| `export-errors.txt` / `decompile-errors.txt` | Resource types that could not be exported, Bicep compile errors |
| `role-assignments.json`, `diagnostic-settings.json`, `locks.json`, `policy-assignments.json` | Extension resources **not captured by the export** |

`export/` is git-ignored: it is regenerated on demand and is not the code you maintain. Portal equivalent: resource group > **Automation > Export template > Bicep**.

Talking points (observed on this RG):
- ~11,500 lines / ~760 resources, mostly Log Analytics saved searches and tables, read-only properties and hard-coded IDs.
- Export errors for some child types (`workspaces/dataSources`, `sites/extensions`, ...).
- 8 decompile errors (e.g. VNet <-> subnet and NSG <-> rule cycles) that need manual fixing.
- **Role assignments and diagnostic settings are not in the export** - they come from the separate JSON files.
- `az group export` is limited to 200 resources per resource group.

### b. Clean, per-resource import with VS Code
Bicep extension > command palette > **Bicep: Insert Resource...** > paste a resource ID. Produces a single clean resource declaration from the live configuration.

### c. Refactor with GitHub Copilot
Ask Copilot to turn `export/<rg>/main.bicep` and the JSON files into a clean `main.bicep`: parameters for names/location/tags, symbolic references instead of hard-coded IDs, remove read-only/default properties, add the role assignments and diagnostic settings, optionally split into modules / use Azure Verified Modules.

Compare the result with [bicep/main.bicep](bicep/main.bicep) (~220 lines instead of ~11,500). Note how it **adopts** the existing role assignments by passing their names in `main.bicepparam`: generating new names with `guid()` would fail with `RoleAssignmentExists`.

### d. Prove it matches reality
```powershell
./deploy-bicep.ps1                     # what-if (default)
./deploy-bicep.ps1 -Mode Deploy        # what-if + confirmation, then deploy
./deploy-bicep.ps1 -Mode Stack -DenySettingsMode denyWriteAndDelete   # deployment stack
```
Use `-TemplateFile` / `-ParametersFile` to target your own refactored template.

With the reference template, what-if shows **no create and no delete**: only the `managedBy` tag changing from `manual` to `bicep`, plus known what-if noise (e.g. `principalId` shown as a `reference()`, disabled log categories in diagnostic settings, server-side defaults). Iterate until that is the case, then deploy: the resources are now managed by code. A **deployment stack** additionally tracks the managed resources and can block changes made outside Bicep.

### e. (Optional) Show drift
Change something in the portal (e.g. add an NSG rule) and re-run `./deploy-bicep.ps1` to show the drift being detected.
## 3. Recommended approach at scale

Export + decompile is the right first step, but the output is **raw material, not the final code**.

### Structure
- **One folder per workload / lifecycle, usually = one resource group.** The RG is the natural unit of ownership and deployment pipeline.
- **Not one file per resource.** Each workload has a `main.bicep` plus one `.bicepparam` per environment (dev/test/prod). Reusable pieces become modules, ideally [Azure Verified Modules](https://aka.ms/avm).
- **Shared foundations separate** (hub network, Log Analytics, policies), referenced by workloads rather than duplicated.

```text
infra/
  platform/            # shared foundations
    hub-network/
    monitoring/
  workloads/
    app-a/             # one folder per workload / RG
      main.bicep
      dev.bicepparam
      prod.bicepparam
    app-b/
  modules/             # internal modules (or reference AVM from the registry)
export/                # raw exports, kept for reference only
  <rg-name>/
    main.json
    main.bicep
    role-assignments.json
```

### Process
1. **Scripted export per RG** with `export-to-bicep.ps1`: `az group export` + `az bicep decompile` into `export/<rg-name>/`. Use VS Code **Insert Resource** for a few resources needing a clean start.
2. **Add the missing pieces**: role assignments, diagnostic settings, locks, policy assignments (collected by `export-to-bicep.ps1`).
3. **Refactor with Copilot** into the target structure: parameters, symbolic references, no read-only properties, AVM modules.
4. **Validate with `what-if`** until it shows no changes, then deploy, optionally as a **deployment stack** (with deny settings to block out-of-band changes).
5. **Store in Git, not just VS Code**: pull requests for review, CI/CD (GitHub Actions / Azure DevOps) running `what-if` on PRs and deploying on merge, and a scheduled `what-if` to detect drift.

## 4. Clean up
```powershell
az group delete -n rg-bicep-export-demo-swec-01 --yes
az keyvault purge -n <kv-name> -l swedencentral   # Key Vault is soft-deleted for 7 days
```
