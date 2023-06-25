#!/bin/bash

ACCOUNT=$1
REPO=$2
REGION=us-east-1

docker build -t $REPO ./app

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
docker tag $REPO:latest ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:latest

docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:latest
