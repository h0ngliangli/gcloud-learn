#!/bin/bash 
# This example demoes how to use curl command to call text-to-speech API.
# Google API authenticate requests by checking one HTTP header:
#     Authentication: Bear <token>
#  * Bear is case sensitive.
#  * <token> is generated via gcloud auth application-default print-access-token
# 
# Text-to-speech API is not supported by the ADC (application default credentials),
# hence you need to specify it's service key via GOOGLE_APPLICATION_CREDENTIALS:
#  export GOOGLE_APPLICATION_CREDENTIALS=<key file>
# Note: You need to specify this before calling gcloud cli to generate acess
# token because the token will include the API key. Otherwise, you will see an
# error like this:
#  error {
#       code: 403
#       status: PERMISSION_DENIED
#       message: Your application has authenticated using end user credentials 
#                from the Google Cloud SDK or Google Cloud Shell which are not 
#                supported by the texttospeech.googleapis.com. 
# }
# 
# The example uses relative path to look for the key file. 
#     dictation
#        sprint1...
#           run.sh  -------
#     keys                |
#        service-key  <----
#
#  Both the request and response data are in JSON format.
#  Hence, in the HTTP header, specify:
#     Content-Type: application/json; charset=utf-8
#     Content-Type: application/json; charset=utf-8
#  
#  A few words about the HTTP headers
#     header names are not case sensitive.
#     other content-type values:
#        text/[html | plain | css]
#        audio/[mpeg | x-wav]
#        image/[gif | jpeg | png]
#        multipart/[form-data]
#        video/[mpeg | mp4 | x-ms-wmv | webm]
#
#  Remember the payload format:
#     input: {text: text},
#		voice: {languageCode: 'en-US', ssmlGender:'NEUTRAL'},
#		audioConfig: {audioEncoding: 'MP3'}
#  Remember the output format
#     audioContent (base64)
#  
#  This code uses jq to parse JSON response.
rm -rf out
mkdir out
unset GOOGLE_APPLICATION_CREDENTIALS

echo "Looking for text-to-speech API service key file..."
keyfile=$(dirname `readlink -f "$0"`)
keyfile=`readlink -f $keyfile/../../keys/text-to-speech-service-key.json`
export GOOGLE_APPLICATION_CREDENTIALS=$keyfile

read -p "What's in your mind? " text
cp request.json out
sed "s/TEXT_PLACEHOLDER/${text}/g" -i out/request.json

echo "Installing jq if not"
if ! dpkg -s "jq" > /dev/null 2>&1
then
   sudo apt update
   sudo apt install jq
fi

echo "Calling text-to-speech API"
curl -X POST \
-H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
-d @out/request.json \
-o out/response.json \
https://texttospeech.googleapis.com/v1/text:synthesize

jq '.audioContent' out/response.json > out/voice.base64
sed -i 's/"//g' out/voice.base64

echo "Converting result to out.mp3"
base64 -d out/voice.base64 > out/voice.mp3

echo "Playing synthesis voice"
if [ -f "$(which cmd.exe)" ]
then
   cmd.exe /C start out/voice.mp3
fi