# AWS Translate on Batch Process
- This implements are Batch Process of Input Text Files (UTF-8) using `boto3`

## Building the Resources
Use terraform to build resources 

```
terraform -chdir=infra/ init
terraform -chdir=infra/ plan 
terraform -chdir=infra/ apply
```

## Generate a Configuration File
To generate a configuration, simply run
```
terraform -chdir=infra/ output -json > config.json
```

## Start a Text Translation Job
After building resources and generating a configuration file, you can start a Text Translation Job
```
chmod +x run_translate.sh
./run_translate.sh
```

## Cleaning-up the Resouces
You can clean-up the following resources with the following commands
```
aws s3 rm s3://translate-in-out/ --recursive
terraform -chdir=infra/ destroy
```

## Note:
- You can change the `bucket_name`, `role_name`, and `policy_name` on `infra/vars.tf`