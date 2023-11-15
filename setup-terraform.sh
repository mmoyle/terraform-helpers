#!/bin/bash 

AWS_REGION=$(aws configure get region)

# Function to get user confirmation
confirm() {
  read -r -p "$1 [y/N]: " response
  case "$response" in
    [yY][eE][sS]|[yY]) 
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Check if the BUCKET_NAME is provided as an argument
if [ $# -ne 2 ]; then
  echo "Usage: $0 <bucketName> <tableName>"
  exit 1
fi

BUCKET_NAME="$1"
TABLE_NAME="$2"

if ! confirm "Create s3 Bucket '$BUCKET_NAME' in region '$AWS_REGION' and dynamodb table '$TABLE_NAME'"?; then
  exit 0
fi

# Check if the bucket already exists
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Bucket '$BUCKET_NAME' already exists in this account."
else
  # Create a versioned S3 bucket
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --create-bucket-configuration LocationConstraint=$AWS_REGION \
    && aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled
  if [ $? -eq 0 ]; then
    echo "Bucket '$BUCKET_NAME' created and versioning enabled."
  else
    echo "Error creating bucket '$BUCKET_NAME'."
    exit 1
  fi
fi


# Check if the table exists
aws dynamodb describe-table --region $AWS_REGION --table-name $TABLE_NAME >/dev/null 2>&1
# Check the exit code to determine if the table exists
if [ $? -eq 0 ]; then
  echo "DynamoDB table '$TABLE_NAME' already exists."
  exit 1
fi

aws dynamodb create-table \
    --table-name $TABLE_NAME \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

# Check if the table creation was successful
if [ $? -eq 0 ]; then
  echo "DynamoDB table '$TABLE_NAME' created successfully."
else
  echo "Error creating DynamoDB table '$TABLE_NAME'."
fi