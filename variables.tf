variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

// Marketplace requires this variable name to be declared
variable "goog_cm_deployment_name" {
  description = "The name of the deployment and VM instance."
  type        = string
  default     = "openvpn-as"
}

variable "source_image" {
  description = "The image name for the disk for the VM instance."
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
}

variable "region" {
  description = "The region for the solution to be deployed."
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "The zone for the solution to be deployed."
  type        = string
  default     = "us-west1-c"
}

variable "machine_type" {
  description = "The machine type to create, e.g. e2-small"
  type        = string
  default     = "n2d-standard-2"
}

variable "boot_disk_type" {
  description = "The boot disk type for the VM instance."
  type        = string
  default     = "pd-balanced"
}

variable "boot_disk_size" {
  description = "The boot disk size for the VM instance in GBs"
  type        = number
  default     = 20
}

variable "existing_vpc_name" {
  description = "The name of the existing VPC to use (leave empty to create a new VPC)"
  type        = string
  default     = ""
}

variable "existing_subnet_name" {
  description = "The name of the existing subnet to use (only used when 'existing_vpc_name' is set)"
  type        = string
  default     = ""
}

variable "subnet_ip_cidr_range" {
  description = "The IP CIDR range for new subnet"
  type        = string
  default     = "10.10.0.0/20"
}

variable "inbound_source_ranges" {
  description = "The source IP ranges to allow inbound traffic from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "env_vars" {
  description = "Environment variables to inject into the VM"
  type        = map(string)
  default     = {}
}
