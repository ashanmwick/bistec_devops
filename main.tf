# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.1.0"
}

# Provider configuration for Azure
provider "azurerm" {
  features {}
}

# Fetch the existing resource group
data "azurerm_resource_group" "aks_rg" {
  name = "Bistec-assignment" # Replace with the name of your existing resource group
}

# Create the AKS cluster in the existing resource group
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "bistec-cluster-ashan"
  location            = data.azurerm_resource_group.aks_rg.location
  resource_group_name = data.azurerm_resource_group.aks_rg.name
  dns_prefix          = "bistec-new"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
  }
}

# Output the kubeconfig (sensitive data)
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}