#!/bin/bash

uuid=$(curl -G https://www.uuidgenerator.net/api/version4)
token=$(curl -d "client_id=INT-13522364" -d "client_secret=G6J4hkxlFQhpNwHqAujfwVhyLeHVUle9" --data-urlencode "username=wildannsyariff@gmail.com" --data-urlencode "password=st0r493_Contabo" -d 'grant_type=password' 'https://auth.contabo.com/auth/realms/contabo/protocol/openid-connect/token' | grep access_token | cut -d '"' -f 4)
curl -X POST -H "Authorization: Bearer $token" -H "x-request-id: $uuid" "https://api.contabo.com/v1/compute/instances/202375291/actions/restart"

exit 0