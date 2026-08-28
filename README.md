# DevOpsRawKubernetesShopware

This project is part of the **DevOps** learning path of the Shopware Academy.

It shows the reference project state after the practical lab **Deploying Shopware With Raw Kubernetes Manifests**.

It demonstrates how to:

- Build a local Shopware application image with a `Dockerfile`.
- Describe a Shopware Kubernetes deployment with raw manifest files.
- Separate configuration, secrets, services, storage, and ingress into dedicated Kubernetes resources.
- Run a local Shopware stack with MySQL and Valkey in Kubernetes.
- Make labels, selectors, service names, and resource responsibilities visible.

Tested for **Shopware 6.7** with the Shopware PHP 8.5 container images and MySQL 8.4.

## Reference Project

This repository is an educational reference state for the Academy practical lab. It is meant for comparing your local result with a known working project state.

You do not need to run this project to use it as a reference. The most important files to compare are:

- `composer.json`
- `composer.lock`
- `symfony.lock`
- `.shopware-project.yml`
- `compose.yaml`
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
docker build -t shopware-devops-lp:local -f Dockerfile .
```

Install the NGINX Ingress controller if it is not already installed:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0/deploy/static/provider/cloud/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

Apply the Kubernetes manifests:

```bash
kubectl apply -f shopware-k8s/namespace.yaml
kubectl apply -f shopware-k8s/configmap.yaml
kubectl apply -f shopware-k8s/secret.yaml
kubectl apply -f shopware-k8s/pvc-mysql.yaml
kubectl apply -f shopware-k8s/mysql-deployment.yaml
kubectl wait --namespace shopware \
  --for=condition=ready pod \
  --selector=app=mysql \
  --timeout=120s
kubectl apply -f shopware-k8s/redis-deployment.yaml
kubectl apply -f shopware-k8s/shopware-deployment.yaml
kubectl apply -f shopware-k8s/ingress.yaml
```

Check the resources:

```bash
kubectl get all -n shopware
kubectl get ingress -n shopware
```

Initialize Shopware from the running Shopware Pod:

```bash
POD_NAME=$(kubectl get pods -n shopware -l app=shopware -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n shopware $POD_NAME -- php bin/console system:install --create-database --basic-setup --no-interaction --skip-first-run-wizard
```

If `shopware.localhost` does not resolve to your machine, add it to your local hosts file:

```bash
echo "127.0.0.1 shopware.localhost" | sudo tee -a /etc/hosts
```

Some local clusters keep the Ingress controller `EXTERNAL-IP` in `<pending>`. In that case, forward a local port to the Ingress controller:

```bash
kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 8080:80
```

If port `8080` is already in use, choose another free local port, for example `8081:80`.

Open the administration through the chosen URL, for example:

```txt
http://shopware.localhost:8080/admin
```

After login, set the Sales Channel domain to the same base URL, for example `http://shopware.localhost:8080`.

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
