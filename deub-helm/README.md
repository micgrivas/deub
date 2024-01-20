# deub helm 

## Requirements 

Kustomize or Helm manifest files which :

- create a group of containers (choose any, for instance https://github.com/nginxinc/NGINX-Demos/tree/master/nginx-hello) that listens for connections on some port

- create a load balancer with above-mentioned group as backend that load balances incoming HTTP calls to it

- simulate 2 different environments (DEV / PROD) with separate configurations (e.g. size of instance group in DEV = 2, PROD = 3).

- create a Job that will call the load balancer periodically and will print the result on stdout.

## Notes on implementation

- Cloud provider: AWS
- The example for nginx-hello, leads to https://hub.docker.com/r/nginxdemos/hello/, which is used.
- Initial step: `helm create deub-helm` 
- Validity test: `helm lint deub-helm`
- Package creation: `helm package deub-helm`  into  deub-helm-<VERSION>.tgz
- Repository: NOT SET - should be https://github.com/micgrivas/deub/deub-helm-<VERSION>.tgz
- Namespace should be the same like the values file, although that is not a constraint. 
  I.e. `helm ... -n <ENV> -f value.<ENV>.yaml`
- There is no ConfigMap, although it should, because the nginxdemos/hello offers no flexibility, i.e. all parameters are already defined in the image.

## Usage

It would make sense to use NAMESPACE == ENVIRONMENT, in the following commands.
1. Local: `helm install [--create-namespace] -n <NAMESPACE> ./deub-helm -f values.<ENVIRONMENT>.yaml`
2. Remote: `helm install https://github.com/micgrivas/deub/deub-helm-<VERSION>.tgz [--create-namespace] -n <NAMESPACE> -f values.<ENVIRONMENT>.yaml`

#### Note from run: 
```
Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace dev -l "app.kubernetes.io/name=deub,app.kubernetes.io/instance=deub" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace dev $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace dev port-forward $POD_NAME 8080:$CONTAINER_PORT
```

### Outcome
~/local_dev/deub/deub-helm (main) $ helm install --create-namespace -n dev deub . -f values.dev.yaml
NAME: deub
LAST DEPLOYED: Sat Jan 20 20:05:50 2024
NAMESPACE: dev
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace dev -l "app.kubernetes.io/name=deub,app.kubernetes.io/instance=deub" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace dev $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace dev port-forward $POD_NAME 8080:$CONTAINER_PORT

## Caveats

The test environment was `minikube` on Fedora on WSL. It may work somehow differently that a full-blown proper kubernetes.


