################################## integration-test.sh ################################## 
#!/bin/bash

#integration-test.sh

sleep 5s

port=$(kubectl -n default get svc ${serviceName} -o json | jq .spec.ports[].nodePort)

echo "Port is - $port"
echo "App URL is - $applicationURL:$port/$applicationURI"

if [[ ! -z "$port" ]];
then

    response=$(curl -s $applicationURL:$port$applicationURI)
    echo "The increment value is - $response"

    http_code=$(curl -s -o /dev/null -w "%{http_code}" $applicationURL:$port$applicationURI)
    echo "$http_code"

    echo "The return code is - $response"

    if [[ "$response" == 99 ]];
        then
            echo "Increment Test Passed"
        else
            echo "Increment Test Failed"
            exit 1;
    fi;

    if [[ "$http_code" == 200 ]];
        then
            echo "HTTP Status Code Test Passed"
        else
            echo "HTTP Status code is not 200"
            exit 1;
    fi;

else
        echo "The Service does not have a NodePort"
        exit 1;
fi;

################################## integration-test.sh ################################## 