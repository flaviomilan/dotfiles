#!/bin/bash

PROFILE="hml-developers" 

ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile "$PROFILE")
SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile "$PROFILE")
SESSION_TOKEN=$(aws configure get aws_session_token --profile "$PROFILE") # Opcional, usado para roles assumidas com MFA

if [ -z "$ACCESS_KEY_ID" ] || [ -z "$SECRET_ACCESS_KEY" ]; then
  echo "Erro: Credenciais AWS SSO não encontradas para o perfil '$PROFILE'."
  exit 1
fi

echo "AWS_ACCESS_KEY_ID=$ACCESS_KEY_ID"
echo "AWS_SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY"
if [ -n "$SESSION_TOKEN" ]; then
    echo "AWS_SESSION_TOKEN=$SESSION_TOKEN"
fi

export AWS_ACCESS_KEY_ID="$ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$SECRET_ACCESS_KEY"
if [ -n "$SESSION_TOKEN" ]; then
    export AWS_SESSION_TOKEN="$SESSION_TOKEN"
fi