destination="./tls"
privateKeyPath="$destination/private.key"
publicKeyPath="$destination/public.key"
reqcsrPath="$destination/cert-req.csr"
cnfPath="$destination/tls-generate.cnf"
crtPath="$destination/cert.crt"
pfxPath="$destination/cert.pfx"

KEY=
DAYS=
STATE=
CITY=
COUNTRY=
CN=

loadDefaults() {

    if [ -z $KEY ]
    then
        KEY="default-key"
    fi

    if [ -z $DAYS ]
    then
        DAYS=365
    fi

    if [ -z $STATE ]
    then
        STATE=SP
    fi

    if [ -z $CITY ]
    then
        CITY=SaoPaulo
    fi

    if [ -z $COUNTRY ]
    then
        COUNTRY=BR
    fi

    if [ -z $CN ] 
    then
        CN=localhost
    fi

}

prepareDestination() {
    rm -rf $destination
    mkdir $destination
}

generateConfig() {
 
    
   
    cat tls-generate.cnf \
    | sed  "s/%CN/$CN/g" \
    | sed "s/%COUNTRY/$COUNTRY/g" \
    | sed "s/%STATE/$STATE/g" \
    | sed "s/%CITY/$CITY/g" \
    >$cnfPath
    
}

generateCert() {
    

    echo "Generating private key"
    openssl genrsa -out $privateKeyPath 2048
    echo "Generating public key"
    openssl rsa -in $privateKeyPath -pubout -out $publicKeyPath
    echo "Generating csr"
    openssl req -new -key $privateKeyPath -out $reqcsrPath -config $cnfPath -batch
    echo "Generating crt"
    openssl x509 -in $reqcsrPath -out $crtPath -req -signkey $privateKeyPath -days $DAYS
    echo "Generating pfx"
    openssl pkcs12 -export -inkey $privateKeyPath -out $pfxPath  -in $crtPath -passin pass:$KEY -password pass:$KEY

    rm $cnfPath

}



loadDefaults
prepareDestination
generateConfig
generateCert