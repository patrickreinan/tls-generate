DESTINATION="./tls"

if [ -z $KEY ]
then
    KEY="default-key"
fi

if [ -z $DAYS ]
then
    DAYS=365
fi

echo "KEY=$KEY"
echo "DAYS=$DAYS"



rm -rf $DESTINATION
mkdir $DESTINATION


echo "Generating private key"
openssl genrsa -out $DESTINATION/private.key 2048
echo "Generating public key"
openssl rsa -in $DESTINATION/private.key -pubout -out $DESTINATION/public.key
echo "Generating pem"
openssl req -new -key $DESTINATION/private.key -out $DESTINATION/cert-req.pem -batch ###-config tls-generate.cnf
echo "Generating crt"
openssl x509 -in $DESTINATION/cert-req.pem -out $DESTINATION/cert.crt -req -signkey $DESTINATION/private.key -days $DAYS
echo "Generating pfx"
openssl pkcs12 -export -inkey $DESTINATION/private.key -out $DESTINATION/cert.pfx  -in $DESTINATION/cert.crt -passin pass:$KEY -password pass:$KEY