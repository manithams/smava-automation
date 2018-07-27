#!/bin/bash


aws configure set aws_access_key_id "${accesskey}" --profile "${profilename}"
aws configure set aws_secret_access_key "${secretkey}" --profile "${profilename}"
aws configure set region "${region}" --profile "${profilename}"
