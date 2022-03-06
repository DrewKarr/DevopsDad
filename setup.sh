# !/bin/bash# 

export K8S_VERSION=1.22.6-gke.1000
export PROJECT_ID=doc-drew-202203041740031
export TF_VAR_project_id=$PROJECT_ID
export TF_VAR_state_bucket=$PROJECT_ID

terraform init
terraform apply --var k8s_version=$K8S_VERSION

export KUBECONFIG=$PWD/kubeconfig

gcloud container clusters \
    get-credentials \
    $(terraform output --raw cluster_name) \
    --project $(terraform output --raw project_id) \
    --region $(terraform output --raw region)

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole \
    cluster-admin \
    --user \
    $(gcloud config get-value account)

kubectl get nodes

cd ../..

#############################
# Deploy Ingress Controller #
#############################

kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/cloud/deploy.yaml

export INGRESS_HOST=$(kubectl \
    --namespace ingress-nginx \
    get svc ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")
export INGRESS_HOST=$(kubectl \
    --namespace ingress-nginx \
    get svc ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $INGRESS_HOST
kubectl get ingress {{ template "fullname" . }}
