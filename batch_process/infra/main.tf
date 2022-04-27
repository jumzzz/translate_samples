provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_role" "service_role" {
    name = "${var.role_name}"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "translate.amazonaws.com"
                }
            },
        ]
    })

    inline_policy {
        name = "${var.policy_name}"

        policy = jsonencode({
            Version = "2012-10-17",
            Statement = [
                {
                    Action = [
                        "translate:*",
                        "iam:ListRoles",
                        "iam:GetRole",
                        "s3:ListAllMyBuckets",
                        "s3:ListBucket",
                        "s3:GetBucketLocation",
                        "iam:CreateRole",
                        "iam:CreatePolicy",
                        "iam:AttachRolePolicy",
                        "kms:CreateGrant",
                        "kms:Decrypt",
                        "kms:GenerateDatakey",
                        "s3:PutObject",
                        "s3:PutObjectAcl"
                    ]
                    Effect = "Allow"
                    Resource = "*"
                },
            ]
        })
    }
}

data "aws_iam_policy" "managed_policy" {
  name = "AmazonS3FullAccess"
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_managed" {
  role       = aws_iam_role.service_role.name
  policy_arn = data.aws_iam_policy.managed_policy.arn
}

resource "aws_kms_key" "service_key" {
    description = "Will be used to encrypt bucket objects"
    deletion_window_in_days = 10
}

resource "aws_s3_bucket" "service_bucket" {
    bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrypt" {
    bucket = aws_s3_bucket.service_bucket.bucket

    rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = aws_kms_key.service_key.arn
          sse_algorithm = "aws:kms"
        }
    }
}

# resource "aws_s3_object_copy" "service_copy_object" {
#     bucket = "${var.bucket_name}"
#     key = "input_data/"
#     source = "some_input_data/"
    
# }

