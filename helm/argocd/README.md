## ArgoCD

### Access ArgoCD:
Access the server UI:

`kubectl port-forward service/argo-cd-argocd-server -n default 8080:443`

Open the browser on http://localhost:8080 

Get default password:

`kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

### Configure new repositories

Settings / Repositories / Connect Repo

Infra repo details:

- Via HTTPS
- Name: `igh-infra-repo`
- Repository URL: `https://github.com/scalzadonna/upc-cloud-arch-tfp-infra.git`
- Projects: * (all)
  
Apps repo details:

- Via SSH
- Name: `igh-apps-repo`
- Repository URL: `https://github.com/scalzadonna/upc-cloud-arch-tfp-apps.git`
- Projects: * (all)


### Configure a new project
- Name: platform-core
- Repositories:
  - https://github.com/scalzadonna/upc-cloud-arch-tfp-infra.git
  - https://github.com/scalzadonna/upc-cloud-arch-tfp-apps.git
- Destinations:
  - Server: https://kubernetes.default.svc
  - Name: in-cluster
  - Namespace: *

# Create Projects/Namespace meta apps

## Argo CD / New app

- Name: platform-core
- Project: platform-core
- Repo URL: git@github.com:scalzadonna/upc-cloud-arch-tfp-infra.git
- Path: helm/argocd/applicationSets/
- Destination Cluster URL: https://kubernetes.default.svc
- Namespace: default

Wait for synchronization and voila!