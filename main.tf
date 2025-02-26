terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" #Using azure provider
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "aks_rg" {
  name = "Bistec-assignment"
}

# Create cluster in the resource group
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "bistec-cluster-ashan"
  location            = data.azurerm_resource_group.aks_rg.location
  resource_group_name = data.azurerm_resource_group.aks_rg.name
  dns_prefix          = "bistec-new"

  default_node_pool {
    name       = "default"
    node_count = 2 #Set the node count to 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}