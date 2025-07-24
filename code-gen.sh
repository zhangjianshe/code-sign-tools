#!/bin/bash

# Ensure the script fails on any error
set -e

# Prompt for password securely
read -s -p "Enter password for the certificate: " PASSWD
echo

# Create output directory
OUTPUT_PATH=$(pwd)/cert
mkdir -p "$OUTPUT_PATH"

# Generate private key
openssl genrsa -aes256 -passout pass:"$PASSWD" -out "$OUTPUT_PATH/codesign.key" 4096

# Create self-signed certificate
openssl req -new -x509 -days 3650 \
    -key "$OUTPUT_PATH/codesign.key" \
    -passin pass:"$PASSWD" \
    -out "$OUTPUT_PATH/codesign.crt" \
    -config code-sign.cnf

# Create PFX (PKCS12) file for Windows compatibility
openssl pkcs12 -export \
    -out "$OUTPUT_PATH/codesign.pfx" \
    -inkey "$OUTPUT_PATH/codesign.key" \
    -in "$OUTPUT_PATH/codesign.crt" \
    -passin pass:"$PASSWD" \
    -passout pass:"$PASSWD"

# Print certificate details
echo "Certificates generated in $OUTPUT_PATH:"
ls -l "$OUTPUT_PATH"

# Verify certificate
openssl x509 -in "$OUTPUT_PATH/codesign.crt" -text -noout

base64 -i $OUTPUT_PATH/codesign.pfx | tr -d '\n' > $OUTPUT_PATH/code_sign_base64.txt
# Provide instructions
echo "
Certificate Generation Complete!

Files generated:
- $OUTPUT_PATH/codesign.key  (Private Key)
- $OUTPUT_PATH/codesign.crt  (Certificate)
- $OUTPUT_PATH/codesign.pfx  (PKCS12 Bundle)

IMPORTANT: 
1. Keep the password secure
2. Store these files safely
3. Do NOT commit these to version control
"
