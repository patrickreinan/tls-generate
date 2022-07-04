# TLS Generate

## Overview
Bash script used to create a CA and domain certificates 

## How to use
```bash
chmod +x ./tls-generate.sh
DOMAIN="patrickreinan.com" tls-generate.sh
````

## Environment Variables
Name|Description
-|-
DOMAIN|Domain used for create certificate
KEY|Key from certificate
DAYS|Days to expire
STATE|State abbreviation (two characters)
CITY|City
COUNTRY|Country
