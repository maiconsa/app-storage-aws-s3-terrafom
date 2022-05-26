#!/bin/bash
set -e
# Get First parameter  or a default 
ENV=${1-'test'}

# destroy Infra 
terraform destroy -var-file="env/${ENV}.tfvars"

