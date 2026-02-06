# Simple Deployment Example

Basic Kubernetes deployment with nginx.

## Deploy

```bash
kubectl apply -f deployment.yaml
```

## Check Status

```bash
kubectl get pods
kubectl get svc example-app
```

## Access

```bash
kubectl port-forward svc/example-app 8080:80
# Visit http://localhost:8080
```

## Clean Up

```bash
kubectl delete -f deployment.yaml
```
