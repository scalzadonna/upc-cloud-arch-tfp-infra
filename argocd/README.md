# Configure Github in ArgoCD


## Generate ssh keys with `ssh-keygen`

## Github

### Add new deploy key 

Github repo / Settings / Deploy Keys / Add deploy key
- Title: igh-infra
- Key: (Public key contents created previously)


## ArgoCD

### Access ArgoCD:
Access the server UI:

`kubectl port-forward service/argo-cd-argocd-server -n default 8080:443`

Open the browser on http://localhost:8080 

Get default password:

`kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

### Configure a new repo

Settings / Repositories / Connect Repo
 
Details:

- Via SSH
- Name: `igh-infra-repo`
- Repository URL: `git@github.com:scalzadonna/upc-cloud-arch-tfp-infra.git`
- Projects: * (all)
- Key: (Private key contents created previously)


# Create Projects/Namespace meta apps

## Argo CD / New app

- Name: platform-core
- Project: default
- Repo URL: git@github.com:scalzadonna/upc-cloud-arch-tfp-infra.git
- Path: argocd/applicationSets/
- Destination Cluster URL: https://kubernetes.default.svc
- Namespace: default
