# faks
Just playing around with AKS and Terraform

## Preparation
Create a service principal to interact with your Azure subscription. You can have instructions [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)

Set the environment variables, in this way terraform will be able to automatically use them when initializing and you don't have to declare them in the provider's configuration.

```
$ export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
$ export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
$ export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
$ export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

_Make sure you also have `az` cli installed on your system. You may also need to perform `az login`._

## Building the infra
Take a look at `variables.tf` file and configure as you wish.

Once ready, apply the usual workflow for terraform:
```
terraform init
terraform plan
terraform apply
```
### Connecting to the created AKS cluster
After the cluster is provisioned, a `kubeconfig` file is created under your `home` directory:

```
resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.faks_k8s_cluster]
  filename     = pathexpand("~/.kube/${azurerm_kubernetes_cluster.faks_k8s_cluster.name}-config.yaml")
  content      = azurerm_kubernetes_cluster.faks_k8s_cluster.kube_config_raw
}
```
You can use it to access the cluster with `kubectl`.