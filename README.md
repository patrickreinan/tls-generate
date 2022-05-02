# tls-generate
key="my-key"
openssl genrsa -out private.key 2048
openssl rsa -in private.key -pubout -out public.key
openssl req -new -key private.key -out cert-req.csr -batch
openssl x509 -in cert-req.csr -out cert.crt -req -signkey private.key -days 365
openssl pkcs12 -export -inkey private.key -out cert.pfx  -in cert.crt -passin pass:$key -password pass:$key

#How to use
```bash
chmod +x ./tls-generate.sh
tls-generate.sh
````
