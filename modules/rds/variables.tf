variable "db_instance_class" {
  description = "The instance class for the RDS MySQL instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage (in GB) for the RDS MySQL instance"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "The username for the RDS MySQL instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the RDS MySQL instance"
  type        = string
  default     = "MySecurePassword123!"
}

variable "db_backup_retention_period" {
  description = "The backup retention period (in days) for the RDS MySQL instance"
  type        = number
  default     = 7
}
