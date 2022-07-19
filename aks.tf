# Define AKS cluster.
resource "azurerm_kubernetes_cluster" "faks_k8s_cluster" {
  name                    = "${var.prefix}-k8s"
  location                = azurerm_resource_group.rg_faks.location
  resource_group_name     = azurerm_resource_group.rg_faks.name
  dns_prefix              = "${var.prefix}-k8s"
  private_cluster_enabled = true

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = azurerm_subnet.faks_internal_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Owner = "faks-mgmt"
  }
}

# Create kubeconfig file.
resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.faks_k8s_cluster]
  filename   = pathexpand("~/.kube/${azurerm_kubernetes_cluster.faks_k8s_cluster.name}-config.yaml")
  content    = azurerm_kubernetes_cluster.faks_k8s_cluster.kube_config_raw
}
