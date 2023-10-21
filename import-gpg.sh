#!/bin/bash

echo "Interactive GPG Key Import Script"
echo "---------------------------------"

# Prompt user for public key
echo "Paste your public GPG key below and press Enter:"
read -r public_key

# Prompt user for private key
echo "Paste your private GPG key below and press Enter:"
read -r private_key

# Import public key
echo "$public_key" | gpg --import
if [ $? -eq 0 ]; then
    echo "Public GPG key import successful."
else
    echo "Failed to import public GPG key."
fi

# Import private key
echo "$private_key" | gpg --allow-secret-key-import --import
if [ $? -eq 0 ]; then
    echo "Private GPG key import successful."
else
    echo "Failed to import private GPG key."
fi