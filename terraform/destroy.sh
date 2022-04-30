#!/bin/bash

export AWS_ACCESS_KEY_ID=[YOUR AWS ACCES KEY]
export AWS_SECRET_ACCESS_KEY=[YOUR AWS SECRET KEY]

# destroy Infra 
terraform destroy -var-file='env/test.tfvars'

AWS_CREDENTIALS_FILE=~/.aws/credentials
echo "Checking $AWS_CREDENTIALS_FILE file exists"
if [ -f "$AWS_CREDENCIALS_FILE"]; then
    echo "Removing file $AWS_CREDENTIALS_FILE "
    rm -f ${AWS_CREDENTIALS_FILE}
fi

