# Kubernetes provider
# https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster#optional-configure-terraform-kubernetes-provider
# To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes

# The Kubernetes provider is included in this file so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
# You should **not** schedule deployments and services in this workspace. This keeps workspaces modular (one for provision EKS, another for scheduling Kubernetes resources) as per best practices.

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster_1.endpoint
  token                  = data.aws_eks_cluster_auth.cluster_1.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster_1.certificate_authority.0.data)
}

provider "kubernetes" {
  alias                  = "cluster_2"
  host                   = data.aws_eks_cluster.cluster_2.endpoint
  token                  = data.aws_eks_cluster_auth.cluster_2.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster_2.certificate_authority.0.data)
}
