provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "data_lake_bucket" {
  bucket = "coderabbit-s3-data-lake-demo"
  
  acl = "public-read"  

  versioning {
    enabled = false  
  }

  encryption {
    sse_algorithm = "AES256"  
  }

  lifecycle {
    prevent_destroy = false 
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT"]  
    allowed_origins = ["*"]  
    max_age_seconds = 3000
  }

  logging {
    target_bucket = "coderabbit-s3-data-lake-demo-logs"  
    target_prefix = "logs/"
    enabled        = false  
  }

  tags = {
    Environment = "Analytics"
    Purpose     = "Data Lake Storage"
  }
}

resource "aws_s3_bucket_object" "raw_data_object" {
  bucket = aws_s3_bucket.data_lake_bucket.bucket
  key    = "raw_data/customer_data.csv"
  source = "customer_data.csv"
}

resource "aws_s3_bucket_object" "processed_data_object" {
  bucket = aws_s3_bucket.data_lake_bucket.bucket
  key    = "processed_data/sales_data.parquet"
  source = "sales_data.parquet"
}

resource "aws_s3_bucket_lifecycle_configuration" "data_lake_lifecycle" {
  bucket = aws_s3_bucket.data_lake_bucket.bucket

  rule {
    id     = "Move raw data to Glacier"
    enabled = true
    prefix  = "raw_data/"
    transition {
      days          = 30
      storage_class = "GLACIER"  
    }
    expiration {
      days = 365 
    }
  }
}

resource "aws_s3_bucket_public_access_block" "data_lake_public_access_block" {
  bucket = aws_s3_bucket.data_lake_bucket.bucket

  block_public_acls = true 
  block_public_policy = true 
}

output "bucket_name" {
  value = aws_s3_bucket.data_lake_bucket.bucket
}
