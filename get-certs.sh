#! /bin/sh
echo | openssl s_client -showcerts -servername $1 -connect $2 2>/dev/null | openssl x509 -inform pem -noout -text