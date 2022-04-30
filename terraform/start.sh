#!/bin/bash
set -e

# Get First parameter  or a default 
ENV=${1-'test'}

# Build Infra 
 terraform apply -var-file="env/${ENV}.tfvars"

#  Export keys 
 access_key=`terraform output --raw access_key_app_user`
 secret_key=`terraform output --raw secret_key_app_user`


 AWS_CREDENTIALS_FILE=~/.aws/credentials
 echo "Adding profile [${ENV}-app-storage] to file  $AWS_CREDENTIALS_FILE"
 echo "[${ENV}-app-storage]" >> ${AWS_CREDENTIALS_FILE}
 echo "aws_access_key_id=${access_key}"  >> ${AWS_CREDENTIALS_FILE}
 echo "aws_secret_access_key=${secret_key}" >> ${AWS_CREDENTIALS_FILE}


