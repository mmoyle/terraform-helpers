# terraform-helpers
Helpful scripts and datasources

## setup-terraform.sh

Create an S3 bucket and Dynamo DB table for the Terraform state
## Provision state resources ##
If it is the first time running terraform in this aws account,
run


    ./setup-terraform.sh <bucketName> <tableName>

to provision an s3 bucket and dynamodb lock table for Terraform states.
*'setup-terraform.sh' will use the aws region and credentials set in your local configuation.*

bucketName and tableName should correspond to the values set in the the s3 backend found in provider.tf

Then run,

    terraform init


## Resources

| Name | Type |
|------|------|
| [aws_ami.latest_windows](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_latest_windows_ami_id"></a> [latest\_windows\_ami\_id](#output\_latest\_windows\_ami\_id) | n/a |
