**Devops Task**

This repository demonstrates a complete GitOps-driven deployment workflow using Terraform, Argo CD, and Helm on a local k3d Kubernetes cluster as per the request.
It provisions infrastructure (MySQL + backup automation) and deploys application workloads (Angular frontend + .NET Core backend) managed through Argo CD.

Infrastructure-as-Code (Terraform)

Application packaging (Helm)

GitOps continuous delivery (Argo CD)

Stateful workloads (MySQL)

Automated backups (CronJob + PVC)

End-to-end deployment on a local Kubernetes cluster

**Architecture**
Terraform ──► Argo CD ──► Helm ──► Applications & Infrastructure
     │                         │
     │                         ├─ MySQL + Backup CronJob (infrastructure/)
     │                         └─ Angular + .NET Core Apps (applications/)
     │
       Installs & configures Argo CD via Helm provider

**Total Tech Used with this setup are as follow:** 

 **k3d**       | Lightweight local Kubernetes cluster                     
 **Terraform** | Deploys Argo CD and defines GitOps apps                  
 **Argo CD**   | Syncs Helm charts from the Git repo to the cluster       
 **Helm**      | Packages the backend, frontend, and MySQL infrastructure 
 **MySQL**     | Database for .NET backend                                
 **CronJob**   | Runs periodic database backups                           
 **PVCs**      | Persist MySQL data and backups       

 **1. Setup Local Kubernetes (k3d)**                    
I used Windows so I install docker desktop. Also intsll cholety as package manager. 
Make local setup by 

choco install kubernetes-helm -y
choco install k3d -y
choco install terraform -y
choco install argocd -y

**Create Local K3d Cluster**

k3d cluster create dev-cluster \
  --agents 1 \
  --servers 1 \
  -p "8080:80@loadbalancer" \
  -p "8443:443@loadbalancer" \
  --volume "C:\Projects\DevOps_Task\infrastructure:/backups@all"

==>  This mounts your local directory for MySQL backups (C:\Projects\DevOps_Task\infrastructure).

**Initialize Terraform**
cd terraform
terraform init
terraform apply -auto-approve

All the files are available on github  
https://github.com/TauqeerAhmad104/DevOps_Task/

**NOTE**
I did not set auto create namespace so to run the teraform init we need to create namespace manualy by using kubectl create ns ------

Terraform will:
Install Argo CD via Helm
Create Argo CD Applications:
infrastructure → Deploys MySQL + CronJob
applications → Deploys .NET backend + Angular frontend

**Access Argo CD UI**

kubectl port-forward -n argocd svc/argo-cd-argocd-server 8080:443

To Access the secret for dashboard 

kubectl -n argocd get secret argocd-initial-admin-secret `-o jsonpath="{.data.password}" | base64 --decode

**Argo Login in Terminal**

argocd login localhost:8080 --username admin --password <decoded-password> --insecure

argocd app list            This wil list all

**Verify Deployments**
kubectl get pods -n infrastructure
kubectl get pods -n applications



**Database Backup Automation**

CronJob:
Backs up MySQL every 5 min and stores .sql files in the mounted PVC.

Configured via:
infrastructure/infra-chart/templates/mysql-backup-cronjob.yaml

Retention Policy:

I was planing to Keeps latest 5 backups butI didnt manage to finish this task yet. 



**Validate Backups**

kubectl run backup-access --rm -it -n infrastructure \
  --image=busybox --restart=Never \
  --overrides='{"spec":{"volumes":[{"name":"backup-vol","persistentVolumeClaim":{"claimName":"mysql-backup-pvc"}}],"containers":[{"name":"backup-access","image":"busybox","command":["sh"],"args":["-c","ls -lh /backups"],"volumeMounts":[{"mountPath":"/backups","name":"backup-vol"}]}]}}'



**OR**

Use the deployment file **backup-debug.yaml** from git repo. 


**Rebuild from Scratch**
If cluster is deleted, just run:

k3d cluster create dev-cluster --agents 1 --servers 1 \
  --volume "C:\Projects\DevOps_Task\infrastructure:/backups@all"

cd terraform
terraform init
terraform import helm_release.argo_cd argocd/argo-cd
terraform apply -auto-approve



**Application Database Info**

My frontntend is in Angular and backend is in dotnet core with Entityframwokr. I build images and host on my docke hub. images can be foudn in value.yaml file or from my dockerhub **https://hub.docker.com/repository/docker/tauqeerdocker/webapi/general**   AND 
**https://hub.docker.com/repository/docker/tauqeerdocker/managerapp/general**

Source codes of these apps can be found on my git repo. 

**NOTE**

As my application need migration but instad of running a cronj job for that I manully create database and tables instad eof Mysql dataabse.



