provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.myCluster.endpoint 
    cluster_ca_certificate = base64decode(aws_eks_cluster.myCluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.myCluster.name]
      command     = "aws"
    }
  }
}