#! /bin/bash

mkdir -p out
cd out

echo "Setting GOOGLE_APPLICATION_CREDENTIALS"
export GOOGLE_APPLICATION_CREDENTIALS=`readlink \
-f ~/startD/gcloud/woodyli1982/keys/*.json`

echo "Installing jq if not"
if ! dpkg -s "jq" > /dev/null 2>&1; then
   echo 'install jq'
   sudo apt update
   sudo apt install jq
fi

echo "Calling text-to-speech API"
curl -X POST \
-H "Authorization: Bearer $(gcloud auth application-default \
print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
-d @../request.json \
https://texttospeech.googleapis.com/v1/text:synthesize | \
jq '.audioContent' | \
sed 's/"//g' > out.base64

echo "Converting result to out.mp3"
base64 -d out.base64 -d > out.mp3

echo "Playing synthesis voice"
if [ -f "$(which cmd.exe)" ]; then
   cmd.exe /C start out.mp3
fi
cd ..
