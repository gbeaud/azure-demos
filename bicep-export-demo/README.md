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

### b. Clean, per-resource import with VS Code
Bicep extension > command palette > **Bicep: Insert Resource...** > paste a resource ID. Produces a single clean resource declaration from the live configuration.

### c. Refactor with GitHub Copilot
Ask Copilot to turn the export into a clean `main.bicep`: parameters for names/location/tags, symbolic references instead of hard-coded IDs, remove read-only/default properties, add the missing role assignments and diagnostic settings, optionally split into modules / use Azure Verified Modules.

### d. Prove it matches reality
```powershell
az deployment group what-if -g rg-bicep-export-demo-swec-01 --template-file main.bicep
```
Iterate until what-if shows (almost) no changes - the resources are now described by code. Then deploy it (optionally as a **deployment stack** to enforce management) and change `managedBy` tag to `bicep`.

### e. (Optional) Show drift
Change something in the portal (e.g. add an NSG rule) and re-run what-if to show the drift being detected.

## 3. Clean up
```powershell
az group delete -n rg-bicep-export-demo-swec-01 --yes
az keyvault purge -n <kv-name> -l swedencentral   # Key Vault is soft-deleted for 7 days
```
