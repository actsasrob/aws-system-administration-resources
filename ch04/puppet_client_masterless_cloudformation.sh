#!/bin/bash

aws cloudformation validate-template --template-body file://puppet_client_masterless_cloudformation.json
if [ "$?" -ne 0 ]; then
   echo "error: invalid cloudformation template. exiting..."
   exit 1
fi

# NOTE: el7 puppetlabs repo puppet-agent package requires systemd. Use RHEL7/CentOS7 AMI
# dcos-centos7-201703282212 - ami-0652eb10
aws cloudformation create-stack --stack-name puppet-client-masterless --template-body \
file://puppet_client_masterless_cloudformation.json \
--region us-east-1 --capabilities CAPABILITY_IAM \
--parameters ParameterKey=AMI,ParameterValue=ami-0652eb10 \
ParameterKey=KeyName,ParameterValue=RobertHughes
