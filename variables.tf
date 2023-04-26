variable "resource_group_name" {
    default = "rg_ade"
}

variable "virtual_network_name" {
    default = "vn_ade"
}

variable "region" {
    default = "eastus"
}

variable "sqldb_service_tier" {
    default = "S0"
}

variable "sqldb_max_size" {
    default = "250"
}