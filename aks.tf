# Define AKS cluster.
resource "azurerm_kubernetes_cluster" "faks_k8s_cluster" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.rg_faks.location
  resource_group_name = azurerm_resource_group.rg_faks.name
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.faks_internal_subnet.id
  } 

  identity {
    type = "SystemAssigned"
  }
}

# Create kubeconfig file.
resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.faks_k8s_cluster]
  filename     = pathexpand("~/.kube/${azurerm_kubernetes_cluster.faks_k8s_cluster.name}-config.yaml")
  content      = azurerm_kubernetes_cluster.faks_k8s_cluster.kube_config_raw
}