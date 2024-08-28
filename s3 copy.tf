provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "bad_example_bucket" {
  bucket = "sensitive-data-bucket-test"

  # Disable encryption - Bad practice
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256" # No encryption for the bucket by default
      }
    }
  }

  # Publicly readable bucket - Bad practice
  acl = "public-read"

  # Disable versioning - Bad practice
  versioning {
    enabled = false
  }

  # Disable logging - Bad practice
  logging {
    target_bucket = ""
  }

  # Bucket policy that allows public access to all objects - Bad practice
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::sensitive-data-bucket/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket_object" "sensitive_file" {
  bucket = aws_s3_bucket.bad_example_bucket.bucket
  key    = "sensitive-data.txt"
  source = "sensitive-data.txt" # Path to a sensitive file (e.g., containing passwords)
  acl    = "public-read"        # Publicly readable - Bad practice
}
