#!/bin/bash

aws cloudformation validate-template --template-body file://cloudformation/myblog.json
if [ "$?" -ne 0 ]; then
   echo "error: invalid cloudformation template. exiting..."
   exit 1
fi

# ubuntu/images-testing/hvm-ssd/ubuntu-yakkety-daily-amd64-server-20170303.1 - ami-0f6fb419
output=$(aws cloudformation create-stack --stack-name example-5-21-stack --template-body \
file://cloudformation/myblog.json \
--region us-east-1  --capabilities CAPABILITY_IAM \
--parameters \
ParameterKey=CeleryAMI,ParameterValue=ami-9eebb088 \
ParameterKey=WebAMI,ParameterValue=ami-9eebb088 \
ParameterKey=CeleryQueueAWSSecretKey,ParameterValue="<change_me>" \
ParameterKey=CeleryQueueAWSSecretAccessKey,ParameterValue="<change_me>" \
ParameterKey=InstanceType,ParameterValue="t2.micro" \
ParameterKey=DBUser,ParameterValue="myblogdbuser" \
ParameterKey=DBPassword,ParameterValue="password\$1234" \
ParameterKey=KeyName,ParameterValue=<change_me>)

if [ "$?" -eq 0 ]; then
   stackid=$(echo "$output" | grep "StackId" | awk '{ print $2 }' | tr -d '"')
   echo "info: waiting for stack creation to complete for stack ID ${stackid}..."
   aws cloudformation wait stack-create-complete --stack-name $stackid
else
   echo "error: non-zero result returned from 'aws cloudformation' command"
fi

