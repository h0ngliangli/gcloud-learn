#!/bin/bash 

echo "Looking for text-to-speech API service key file..."
current_path=$(dirname `readlink -f "$0"`)
key_path=`readlink -f $current_path/../../keys/text-to-speech-service-key.json`
echo $key_path
if ! [ -f $key_path ]; then
      read -p "Enter the text-to-speech service key file path:" key_path
fi

echo "Setting GOOGLE_APPLICATION_CREDENTIALS"
export GOOGLE_APPLICATION_CREDENTIALS=$key_path

echo "Installing jq if not"
if ! dpkg -s "jq" > /dev/null 2>&1; then
   echo 'install jq'
   sudo apt update
   sudo apt install jq
fi

mkdir -p out
echo "Calling text-to-speech API"
curl -X POST \
-H "Authorization: Bearer $(gcloud auth application-default \
print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
-d @request.json \
https://texttospeech.googleapis.com/v1/text:synthesize | \
jq '.audioContent' | \
sed 's/"//g' > out/out.base64

echo "Converting result to out.mp3"
base64 -d out/out.base64 -d > out/out.mp3

echo "Playing synthesis voice"
if [ -f "$(which cmd.exe)" ]; then
   cmd.exe /C start out/out.mp3
fi
cd ..