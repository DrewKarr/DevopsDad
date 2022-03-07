#!/bin/bash
set -v
export PROJECT_ID=drewlearns-$(date +%Y%m%d%H%M%S)
export TF_VAR_project_id=$PROJECT_ID
export SERVICE_ACCOUNT=drewlearns-$(date +%Y%m%d%H%M%S)
export KUBECONFIG=$PWD/kubeconfig
export K8_VERSION="1.22.6-gke.1000"

# Run everything from the IaC section
# gcloud auth login
terraform init
gcloud projects create $PROJECT_ID
gcloud projects list | grep $PROJECT_ID
gcloud iam service-accounts create $SERVICE_ACCOUNT --project $PROJECT_ID --display-name SERVICE_ACCOUNT
gcloud iam service-accounts list --project $PROJECT_ID
gcloud iam service-accounts keys create account.json --iam-account $SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts keys list --iam-account=$(gcloud iam service-accounts list --project $PROJECT_ID | grep -o "$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com") --project $PROJECT_ID --format=json
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com --role roles/owner
gsutil ls -p $PROJECT_ID 
terraform apply --var k8_version=$K8_VERSION
kubectl get nodes
kubectl version --output yaml
# cat backend.tf k8s-control-plane.tf k8s-worker-nodes.tf provider.tf storage.tf | tee main.tf
# rm -f backend.tf k8s-control-plane.tf k8s-worker-nodes.tf provider.tf storage.tf
terraform refresh --var k8s_version=$K8S_VERSION
gcloud container clusters get-credentials $(terraform output -raw cluster_name) \
	--project $(terraform output -raw project_id)	\
	--region $(terraform output -raw region)
kubectl create clusterrolebinding cluster-admin-binding \
	--clusterrole cluster-admin \
	--user $(gcloud config get-value account)
# Install ingress controller
kubectl apply --filename ingress-nginx.yaml && \
while [ -s $INGRESS_HOST ]; do
    export INGRESS_HOST=$(kubectl \
    --namespace ingress-nginx \
    get svc ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")
done;
echo $INGRESS_HOST


