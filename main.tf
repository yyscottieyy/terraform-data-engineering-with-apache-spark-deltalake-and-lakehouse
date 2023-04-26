# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"

# Commenting out cloub block since VCS-Driven workflow doesn't need this
/*   cloud {
    organization = "Data-Engineering-and-Data-Analytics"
    workspaces {
      name = "terraform-data-engineering-with-apache-spark-deltalake-and-lakehouse"
    }
  } */
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "westus2"

  tags = {
    Environment = "Development"
    Team        = "DevOps"
  }

}

# Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.virtual_network_location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a Azure SQL DB Server
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "salesdb-server-ade"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.virtual_network_location
  version                      = "12.0"
  administrator_login          = "training_admin"
  administrator_login_password = "scotT123$$"
  minimum_tls_version          = "1.2"

  tags = {
    Environment = "Development"
    Team        = "DevOps"
  }
}

# Create a Azure SQL DB database
resource "azurerm_mssql_database" "sqldb" {
  name                         = "salesdb-ade"
  server_id                    = azurerm_mssql_server.sqlserver.id
  collation                    = "SQL_Latin1_General_CP1_CI_AS"
  license_type                 = "LicenseIncluded"
  max_size_gb                  = var.sqldb_max_size
  read_scale                   = true
  sku_name                     = var.sqldb_service_tier
  zone_redundant               = true

  tags = {
    Environment = "Development"
    Team        = "DevOps"
  }
}