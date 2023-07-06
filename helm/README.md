# Install ArgoCD

Helm chart: https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd
Helm values: https://github.com/argoproj/argo-cd/blob/master/manifests/install.yaml

`helm repo add argo https://argoproj.github.io/argo-helm`

`helm repo update`

`helm install -f argo-dev.yaml argo-cd argo/argo-cd`


Access the server UI:

`kubectl port-forward service/argo-cd-argocd-server -n default 8080:443`

Open the browser on http://localhost:8080 

Get default password:

`kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`


Install sample app:

https://github.com/argoproj/argocd-example-apps.git

##In ArgoCD UI:##
Create app: `guestbook`
Repo: `https://github.com/argoproj/argocd-example-apps.git`
Path: `helm-guestbook`
Server: `https://kubernetes.default.svc` (default)
Namespace: `default`

Once create enable port-forwarding to access from local env:
`kubectl port-forward svc/guestbook-helm-guestbook -n default 8888:80`

Open the browser on http://localhost:8888

Expose using an AWS Load Balancer

```
kubectl patch service argo-cd-argocd-server -p '{"spec":{"type":"LoadBalancer"}}' && \
kubectl get service argo-cd-argocd-server
```
 
# Install Crossplane

Full explanation here:
https://docs.crossplane.io/v1.12/getting-started/provider-aws/#install-crossplane


`helm repo add crossplane-stable https://charts.crossplane.io/stable`

`helm repo update`

`helm install -f crossplane-dev.yaml crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace`

Verify Crossplane installed with 

`kubectl get pods -n crossplane-system`
`kubectl api-resources  | grep crossplane`

Install the Crossplane AWS provider

`kubectl apply -f aws-provider.yaml`

Verify Crossplane AWS provider
`kubectl get providers`

Configure secrets

Update text file: `aws-credentials.txt` with your AWS account credentials

Create a kubernetes secret from the file

`kubectl create secret generic aws-secret -n crossplane-system --from-file=creds=./aws-credentials.txt`


View the secret

`kubectl describe secret aws-secret -n crossplane-system`

Create a ProviderConfig 

`kubectl apply -f aws-provider-config.yaml`

Test the provider

Create a managed resource 

`kubectl apply -f aws-bucket-resource.yaml`

Verify the bucket was created

`kubectl get buckets`

`aws s3 ls`

Delete the managed resource

`kubectl delete bucket <bucketname>`