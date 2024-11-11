provider "aws" {
  region = "eu-north-1"
}

# S3 Bucket Configuration
resource "aws_s3_bucket" "data_lake_bucket" {
  bucket = "coderabbit-s3-data-lake-demo"
  
  acl = "public-read"  # Mistake: Overly permissive bucket ACL (should be private)

  versioning {
    enabled = false  # Good practice, but ensure that all important objects are versioned
  }

  encryption {
    sse_algorithm = "AES256"  # Good security practice
  }

  lifecycle {
    prevent_destroy = false  # Mistake: Preventing destroy could be useful, but here it's not enabled.
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT"]  # Mistake: Allows PUT method from all origins (could be restricted)
    allowed_origins = ["*"]  # Mistake: Misconfigured CORS - should restrict origins
    max_age_seconds = 3000
  }

  logging {
    target_bucket = "coderabbit-s3-data-lake-demo-logs"  # Mistake: Logging bucket not configured or not created
    target_prefix = "logs/"
    enabled        = false  # Mistake: Logging is disabled, should be enabled for monitoring
  }

  tags = {
    Environment = "Analytics"
    Purpose     = "Data Lake Storage"
  }
}

# S3 Object - Raw Data
resource "aws_s3_bucket_object" "raw_data_object" {
  bucket = aws_s3_bucket.data_lake_bucket.bucket
  key    = "raw_data/customer_data.csv"
  source = "customer_data.csv"
}

# S3 Object - Processed Data
resource "aws_s3_bucket_object" "processed_data_object" {
  bucket = aws_s3_bucket.data_lake_bucket.bucket
  key    = "processed_data/sales_data.parquet"
  source = "sales_data.parquet"
}

# S3 Lifecycle Policies for Object Transition (cost savings, Glacier)
resource "aws_s3_bucket_lifecycle_configuration" "data_lake_lifecycle" {
  bucket = aws_s3_bucket.data_lake_bucket.bucket

  rule {
    id     = "Move raw data to Glacier"
    enabled = true
    prefix  = "raw_data/"
    transition {
      days          = 30
      storage_class = "GLACIER"  # Mistake: Might be a misconfiguration if data is regularly accessed
    }
    expiration {
      days = 365  # Mistake: Might be overly aggressive expiration, data may be needed beyond 1 year
    }
  }
}

# S3 Public Access Block (missing public access block for tighter security)
resource "aws_s3_bucket_public_access_block" "data_lake_public_access_block" {
  bucket = aws_s3_bucket.data_lake_bucket.bucket

  block_public_acls = true  # Mistake: Public ACLs are not blocked, could leave bucket exposed
  block_public_policy = true  # Mistake: Policy should be stricter for compliance
}

output "bucket_name" {
  value = aws_s3_bucket.data_lake_bucket.bucket
}
