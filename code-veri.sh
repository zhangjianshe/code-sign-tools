# Check certificate details
openssl x509 -in codesign.crt -text -noout

# Verify key match
openssl x509 -noout -modulus -in codesign.crt | openssl md5
openssl rsa -noout -modulus -in codesign.key | openssl md5
