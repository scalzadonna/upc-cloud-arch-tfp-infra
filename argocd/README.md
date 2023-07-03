# Configure Github in ArgoCD


## Generate ssh keys with `ssh-keygen`

- Filename: `igh-infra`

Another one

- Filename: `igh-apps`


## Github

### Add new deploy key infra repo

Infra Repository

Github repo / Settings / Deploy Keys / Add deploy key
- Title: igh-infra
- Key: (Public key contents created previously for infra: `igh-infra.pub`)


### Add new deploy key apps repo

Another one for Apps Repository

- Title: igh-apps
- Key: (Public key contents created previously for apps: `igh-apps.pub`)


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

- Via SSH
- Name: `igh-infra-repo`
- Repository URL: `git@github.com:scalzadonna/upc-cloud-arch-tfp-infra.git`
- Projects: * (all)
- Key: (Private key contents created previously `igh-infra`)

Apps repo details:

- Via SSH
- Name: `igh-apps-repo`
- Repository URL: `git@github.com:scalzadonna/upc-cloud-arch-tfp-apps.git`
- Projects: * (all)
- Key: (Private key contents created previously `igh-apps`)


### Configure a new project
- Name: platform-core
- Repositories:
  - git@github.com:scalzadonna/upc-cloud-arch-tfp-apps.git
  - git@github.com:scalzadonna/upc-cloud-arch-tfp-infra.git
- Destinations:
  - Server: https://kubernetes.default.svc
  - Name: in-cluster
  - Namespace: *

# Create Projects/Namespace meta apps

## Argo CD / New app

- Name: platform-core
- Project: platform-core
- Repo URL: git@github.com:scalzadonna/upc-cloud-arch-tfp-infra.git
- Path: argocd/applicationSets/
- Destination Cluster URL: https://kubernetes.default.svc
- Namespace: default

Wait for synchronization and voila!