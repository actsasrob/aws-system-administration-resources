#!/bin/bash

aws cloudformation validate-template --template-body file://cloudformation/myblog.json
if [ "$?" -ne 0 ]; then
   echo "error: invalid cloudformation template. exiting..."
   exit 1
fi

# ubuntu/images-testing/hvm-ssd/ubuntu-yakkety-daily-amd64-server-20170303.1 - ami-0f6fb419
output=$(aws cloudformation create-stack --stack-name example-5-9-stack --template-body \
file://cloudformation/myblog.json \
--region us-east-1 --capabilities CAPABILITY_IAM \
--parameters ParameterKey=AMI,ParameterValue=ami-0f6fb419 \
ParameterKey=KeyName,ParameterValue=RobertHughes)

if [ "$?" -eq 0 ]; then
   stackid=$(echo "$output" | grep "StackId" | awk '{ print $2 }')
   echo "info: waiting for stack creation to complete..."
   aws cloudformation wait stack-create-complete --stack-name "$stackid"
else
   echo "error: non-zero result returned from 'aws cloudformation command'"
fi

