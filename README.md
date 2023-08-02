# Jenkins Helm Chart

Jenkins is an open source Continuous Integration and Continuous Delivery (CI/CD) server designed to automate the building, testing, and deploying of any software project.

[Overview of Jenkins](http://jenkins-ci.org/)



## Intruduction

This chart was designed to be deployed both on local standalone cluster (e.g. kind /minikube) and EKS environments.

## emptyDir vs Local vs NFS
This chart has the ablility to work with both temporary pod FS or with persistent storage solution -  Local or NFS.

## Runnign in local cluster without persistence

## TL;DR

```console
helm install my-release ./chart/jenkins --set persistence.enabled=false
```

## Runnign in local cluster with persistence

## TL;DR

```console
helm install my-release ./chart/jenkins --set persistence.enabled=true --set persistence.enabled=true --set persistence.type=local
```

## Runnign in EKS cluster with persistence

## Create a EKS cluster

provision your private EKS Cluster [please refere to my Terraform code](subpro/subtext.md)

## Setup our EFS Cloud Storage 

```
#Specify your EKS cluster ID
ClusterName=myCluster

# deploy EFS storage driver
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

# get VPC ID
VPCID=$(aws eks describe-cluster --name $ClusterName --query "cluster.resourcesVpcConfig.vpcId" --output text)

# Get CIDR range
CIDR=$(aws ec2 describe-vpcs --vpc-ids $VPCID --query "Vpcs[].CidrBlock" --output text)

# security for our instances to access file storage
SG=$(aws ec2 create-security-group --description efs-test-sg --group-name efs-sg --vpc-id $VPCID | jq -r .GroupId) 
aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 2049 --cidr $CIDR

# create EFS storage
EFS=$(aws efs create-file-system --creation-token eks-efs | jq -r .FileSystemId)

# create mount point linked for each subnet in cluster node group
NodeGroup=private-nodes
SUBNETS=$(aws eks describe-nodegroup --cluster-name $ClusterName --nodegroup-name $NodeGroup --query 'nodegroup.subnets' | jq -r '.[]')
for subnet_id in $SUBNETS; do aws efs create-mount-target --file-system-id $EFS --subnet-id $subnet_id --security-group $SG; done

```

More details about EKS storage [here](https://aws.amazon.com/premiumsupport/knowledge-center/eks-persistent-storage/)


## TL;DR

```console
helm install my-release ./chart/jenkins --set persistence.enabled=true --set persistence.enabled=true --set persistence.type=nfs --set persistence.nfs.csi.volumeHandle=$EFS
```
