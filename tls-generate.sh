


destination=
domainPath=
caKeyPath=
caPEMPath=
caSerial=
cnfPath=

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
        CN=$DOMAIN
    fi

    destination="./tls"
    domainRoot="$destination/$DOMAIN"
    domainPath="$domainRoot/$DOMAIN"
    cnfPath="$domainRoot/tls-generate.cnf"
    caKeyPath="$destination/ca.key"
    caPEMPath="$destination/ca.pem"
    caSerial="$destination/ca.srl"

}

checkArgs() {
    if [ -z $DOMAIN ]
    then
        echo "Invalid DOMAIN"
        exit 1
    fi
}

prepareDestination() {
    rm -rf $domainRoot
    mkdir -p $destination
    mkdir -p $domainRoot

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

    if [ ! -f "$caKeyPath" ] || [ ! -f "$caPEMPath" ] 
    then
        openssl genrsa -des3  -passout pass:$KEY -out $caKeyPath 2048
        openssl req -x509 -new -nodes -key $caKeyPath -sha256 -days $DAYS -out $caPEMPath -config $cnfPath -batch -passin pass:$KEY
    fi

    openssl genrsa -out $domainPath.key 2048
    openssl req -new -key $domainPath.key -out $domainPath.csr -config $cnfPath -batch 

    cat > $domainPath.ext \
     << EOF
        authorityKeyIdentifier=keyid,issuer
        basicConstraints=CA:FALSE
        keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
        subjectAltName = @alt_names
        [alt_names]
        DNS.1 = $domainPath
EOF
    
    openssl x509 -req -in $domainPath.csr -CA $caPEMPath -CAkey $caKeyPath \
    -CAcreateserial -CAserial $caSerial -out $domainPath.crt -days $DAYS -sha256 -extfile $domainPath.ext  -passin pass:$KEY 
}

cleanup() {
    rm -rf $cnfPath
}

clear
checkArgs 
loadDefaults
prepareDestination
generateConfig
generateCert 
cleanup