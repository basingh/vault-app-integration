#!/bin/bash

## enable terraform cloud secret engine
vault secrets enable terraform

## configure Terraform cloud enginer with api token 
vault write terraform/config token=$TF_TOKEN

## Get user-id for  userid from Terraform Cloud
USER_ID=$(curl -s \
    --header "Authorization: Bearer $TF_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request GET \
    https://app.terraform.io/api/v2/account/details | jq -r ".data.id")

echo "$USER_ID"

## Set user-id to Vault configuration

vault write terraform/role/my-user user_id=$USER_ID ttl=2m

## Request terraform creds 

vault read terraform/creds/my-user

