#!/bin/bash

# destroy Infra 
terraform destroy -var-file='env/test.tfvars'

