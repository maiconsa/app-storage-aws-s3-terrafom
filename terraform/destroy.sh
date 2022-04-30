#!/bin/bash

# Get First parameter  or a default 
ENV=${1-'test'}

# destroy Infra 
terraform destroy -var-file='env/test.tfvars'

