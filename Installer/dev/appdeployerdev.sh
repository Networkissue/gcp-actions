#!/bin/bash
echo "Deployment of Services to Dev cloud is started."
while getopts v:s: flag
do
    case "${flag}" in
        v) bversion=${OPTARG};;
        s) services=${OPTARG};;
    esac
done
if [[ ${bversion} ==  "" ]]
then
    echo "No build version"
else
    echo "Build Version: $bversion"
fi

echo "Services: $services";
if [[ ${services} ==  "" ]] || [[ ${services} ==  "all" ]]; then
     echo "Build all Services"
     ./deploy-dev-portal.sh ${bversion}
     ./deploy-dev-Service.sh ${bversion}
elif [[ ${services} ==  "my-test-portal" ]]; then
    echo "Build App Portal"
    ./deploy-dev-portal.sh ${bversion}
elif [[ ${services} ==  "my-test-service" ]]; then
    echo "Build APP Service"
    ./deploy-dev-service.sh ${bversion}
else
    echo "No Build Service"
fi

echo "Deployment of Services to Dev cloud is done"