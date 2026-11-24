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

### a. Raw export (shows why it is only a starting point)
```powershell
az group export -n rg-bicep-export-demo-swec-01 --skip-all-params > main.json
az bicep decompile --file main.json
```
Or in the portal: resource group > **Automation > Export template > Bicep**.

Talking points (observed on this RG):
- ~11,000 lines / ~750 resources, mostly Log Analytics saved searches and tables, read-only properties and hard-coded IDs.
- Export errors for some child types (`workspaces/dataSources`, `sites/extensions`, ...).
- Decompile produces errors (e.g. VNet <-> subnet cycle) that need manual fixing.
- **Role assignments and diagnostic settings are not exported.**

At scale, script this per resource group (loop over `az group list`, export + decompile each into its own folder). See [section 3](#3-recommended-approach-at-scale).

### b. Collect what the export misses
Extension resources must be retrieved separately and added to the Bicep code:
```powershell
$rg = "rg-bicep-export-demo-swec-01"
az role assignment list -g $rg -o json                                     # RBAC
az monitor diagnostic-settings list --resource <resource-id> -o json       # per resource
az lock list -g $rg -o json                                                # resource locks
az policy assignment list -g $rg -o json                                   # policy assignments
```

### c. Clean, per-resource import with VS Code
Bicep extension > command palette > **Bicep: Insert Resource...** > paste a resource ID. Produces a single clean resource declaration from the live configuration.

### d. Refactor with GitHub Copilot
Ask Copilot to turn the export into a clean `main.bicep`: parameters for names/location/tags, symbolic references instead of hard-coded IDs, remove read-only/default properties, add the missing role assignments and diagnostic settings, optionally split into modules / use Azure Verified Modules.

### e. Prove it matches reality
```powershell
az deployment group what-if -g rg-bicep-export-demo-swec-01 --template-file main.bicep
```
Iterate until what-if shows (almost) no changes - the resources are now described by code. Then deploy it (optionally as a **deployment stack** to enforce management) and change `managedBy` tag to `bicep`.

### f. (Optional) Show drift
Change something in the portal (e.g. add an NSG rule) and re-run what-if to show the drift being detected.

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
1. **Scripted export per RG**: `az group export` + `az bicep decompile` into `export/<rg-name>/`. Use VS Code **Insert Resource** for a few resources needing a clean start.
2. **Add the missing pieces**: role assignments, diagnostic settings, locks, policy assignments (see [2b](#b-collect-what-the-export-misses)).
3. **Refactor with Copilot** into the target structure: parameters, symbolic references, no read-only properties, AVM modules.
4. **Validate with `what-if`** until it shows no changes, then deploy, optionally as a **deployment stack** (with deny settings to block out-of-band changes).
5. **Store in Git, not just VS Code**: pull requests for review, CI/CD (GitHub Actions / Azure DevOps) running `what-if` on PRs and deploying on merge, and a scheduled `what-if` to detect drift.

## 4. Clean up
```powershell
az group delete -n rg-bicep-export-demo-swec-01 --yes
az keyvault purge -n <kv-name> -l swedencentral   # Key Vault is soft-deleted for 7 days
```
