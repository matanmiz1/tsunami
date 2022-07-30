#!/bin/bash

servers=$(aws s3 cp ${S3_URI} -)
timestamp=$(date +"%d%m%y%H%M%S")

if [ ! -d "/usr/tsunami/logs/${timestamp}" ] ; then
    mkdir -p "/usr/tsunami/logs/${timestamp}"
fi

for server in $servers; do
  java -cp tsunami.jar:plugins/* \
       -Dtsunami-config.location=tsunami.yaml \
       com.google.tsunami.main.cli.TsunamiCli \
       --ip-v4-target=${server} \
       --scan-results-local-output-format=JSON \
       --scan-results-local-output-filename=/usr/tsunami/logs/${timestamp}/${server}-tsunami-output.json
done

echo "Finished scanning all the servers"
