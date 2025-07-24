# Generate private key
openssl genrsa -out codesign.key 4096

# Create self-signed certificate
openssl req -new -x509 -days 365 \
    -key codesign.key \
    -out codesign.crt \
    -config codesign.cnf

# Create PFX (PKCS12) file for Windows compatibility
openssl pkcs12 -export \
    -out codesign.pfx \
    -inkey codesign.key \
    -in codesign.crt \
    -passout pass:YourStrongPassword
