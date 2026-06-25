# DevOpsRawKubernetesShopware

This project is part of the **DevOps** learning path of the Shopware Academy.

It shows the reference project state after the practical lab **Deploying Shopware With Raw Kubernetes Manifests**.

It demonstrates how to:

- Build a local Shopware application image with a `Dockerfile`.
- Describe a Shopware Kubernetes deployment with raw manifest files.
- Separate configuration, secrets, services, storage, and ingress into dedicated Kubernetes resources.
- Run a local Shopware stack with MySQL and Valkey in Kubernetes.
- Make labels, selectors, service names, and resource responsibilities visible.

Tested for **Shopware 6.7**.

## Reference Project

This repository is an educational reference state for the Academy practical lab. It is meant for comparing your local result with a known working project state.

You do not need to run this project to use it as a reference. The most important files to compare are:

- `Dockerfile`
- `shopware-k8s/namespace.yaml`
- `shopware-k8s/configmap.yaml`
- `shopware-k8s/secret.yaml`
- `shopware-k8s/pvc-mysql.yaml`
- `shopware-k8s/mysql-deployment.yaml`
- `shopware-k8s/redis-deployment.yaml`
- `shopware-k8s/shopware-deployment.yaml`
- `shopware-k8s/ingress.yaml`

These files show the expected raw Kubernetes resource model at the end of the lab.

It is not a production template. The credentials, service names, storage setup, and runtime settings are intentionally simple for local learning.

## Optional: Run the Project Locally

If you want to run this reference project locally, you still need a local Kubernetes cluster, an NGINX Ingress controller, `kubectl`, and the local image setup from the practical lab.

Build the Shopware image:

```bash
docker build -t shopware-devops-lp:local .
```

Apply the Kubernetes manifests:

```bash
kubectl apply -f shopware-k8s/namespace.yaml
kubectl apply -f shopware-k8s/configmap.yaml
kubectl apply -f shopware-k8s/secret.yaml
kubectl apply -f shopware-k8s/pvc-mysql.yaml
kubectl apply -f shopware-k8s/mysql-deployment.yaml
kubectl apply -f shopware-k8s/redis-deployment.yaml
kubectl apply -f shopware-k8s/shopware-deployment.yaml
kubectl apply -f shopware-k8s/ingress.yaml
```

Check the resources:

```bash
kubectl get all -n shopware
kubectl get ingress -n shopware
```

When MySQL is ready, initialize Shopware from the running Shopware Pod as described in the practical lab.

Stop the setup:

```bash
kubectl delete namespace shopware
```

## License

MIT License.

You may use this project in commercial and professional projects.
It is provided as an educational example and comes without a warranty and without support.

## Contributing

This project is part of the Shopware Academy curriculum.
