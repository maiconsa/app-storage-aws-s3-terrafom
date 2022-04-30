#!/bin/bash

export AWS_ACCESS_KEY_ID=[YOUR AWS ACCES KEY]
export AWS_SECRET_ACCESS_KEY=[YOUR AWS SECRET KEY]

terraform init

## Build Infra 
terraform apply -var-file='env/test.tfvars'

# # Export keys 
access_key=`terraform output --raw access_key_app_user`
secret_key=`terraform output --raw secret_key_app_user`


AWS_CREDENTIALS_FILE=~/.aws/credentials
echo "Checking $AWS_CREDENTIALS_FILE file exists"
if [ -f "$AWS_CREDENCIALS_FILE"]; then
    echo "Removing file $AWS_CREDENTIALS_FILE "
    rm -f ${AWS_CREDENTIALS_FILE}
fi


echo "Adding profile [app-storage] to file  $AWS_CREDENTIALS_FILE"
echo "[app-storage]" >> ${AWS_CREDENTIALS_FILE}
echo "aws_access_key_id=${access_key}"  >> ${AWS_CREDENTIALS_FILE}
echo "aws_secret_access_key=${secret_key}" >> ${AWS_CREDENTIALS_FILE}


