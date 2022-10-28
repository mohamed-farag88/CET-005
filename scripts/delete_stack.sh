#!/bin/bash

aws cloudformation delete-stack --stack-name $1 --profile default --region=us-east-1