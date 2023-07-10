# Install ArgoCD

Helm chart: https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd
Helm values: https://github.com/argoproj/argo-cd/blob/master/manifests/install.yaml

`helm repo add argo https://argoproj.github.io/argo-helm`

`helm repo update`

`helm install -f helm/argocd/argo-dev.yaml argo-cd argo/argo-cd`


Access the server UI:

`kubectl port-forward service/argo-cd-argocd-server -n default 8080:443`

Open the browser on http://localhost:8080 

Get default password:

`kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`


Expose using an AWS Load Balancer

```
kubectl patch service argo-cd-argocd-server -p '{"spec":{"type":"LoadBalancer"}}' && \
kubectl get service argo-cd-argocd-server
```

### Configuring Argo CD with Crossplane

https://docs.crossplane.io/knowledge-base/integrations/argo-cd-crossplane/

To configure Argo CD for Annotation resource tracking, edit the argocd-cm ConfigMap in the argocd Namespace. 

Add application.resourceTrackingMethod: annotation

to the data section as below:

```
apiVersion: v1
data:
  application.resourceTrackingMethod: annotation
kind: ConfigMap
```

# Install Crossplane

Full explanation here:
https://docs.crossplane.io/v1.12/getting-started/provider-aws/#install-crossplane


`helm repo add crossplane-stable https://charts.crossplane.io/stable`

`helm repo update`

`helm install crossplane crossplane-stable/crossplane  --namespace crossplane-system --create-namespace`

Verify Crossplane installed with 

`kubectl get pods -n crossplane-system`
`kubectl api-resources  | grep crossplane`


Configure secrets

Create a text file: `aws-credentials.txt` with your AWS account credentials

Create a kubernetes secret from the file

`kubectl create secret generic aws-secret -n crossplane-system --from-file=creds=../aws-credentials.txt`


View the secret

`kubectl describe secret aws-secret -n crossplane-system`

## Deploy Platform Core in ArgoCD

`helm install platform-core helm/argocd/platform-core`

### Test the provider

### Create a managed resource 

`kubectl apply -f aws-bucket-resource.yaml`

### Verify the bucket was created

`kubectl get buckets`

`aws s3 ls`

### Delete the managed resource

`kubectl delete bucket <bucketname>`