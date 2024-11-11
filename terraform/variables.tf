# Define AWS region
variable "aws_region" {
  description = "The AWS region to create the resources in."
  default     = "eu-north-1"
}

# Define S3 Bucket name
variable "bucket_name" {
  description = "The name of the S3 bucket used for data lake storage."
  default     = "coderabbit-s3-data-lake-demo"
}

# Define lifecycle configuration for the S3 bucket
variable "lifecycle_transition_days" {
  description = "Days after which objects in the raw data folder are transitioned to Glacier."
  default     = 30
}

variable "lifecycle_expiration_days" {
  description = "Days after which objects in the raw data folder are deleted."
  default     = 365
}

# Define file paths for raw data and processed data
variable "raw_data_file" {
  description = "Path to the raw data file (CSV format)."
  default     = "customer_data.csv"
}

variable "processed_data_file" {
  description = "Path to the processed data file (Parquet format)."
  default     = "sales_data.parquet"
}
