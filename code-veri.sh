# Check certificate details
openssl x509 -in cert/codesign.crt -text -noout

# Verify key match
openssl x509 -noout -modulus -in cert/codesign.crt | openssl md5
openssl rsa -noout -modulus -in cert/codesign.key | openssl md5
