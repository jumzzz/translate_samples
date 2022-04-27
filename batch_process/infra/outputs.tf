output "aws_kms_key_id" {
    value = "${aws_kms_key.service_key.key_id}"
}

output "bucket_name" {
    value = "${aws_s3_bucket.service_bucket.bucket}"
}

output "aws_role_arn" {
    value = "${aws_iam_role.service_role.arn}"
}