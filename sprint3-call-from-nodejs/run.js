/*
	This example uses text-to-speech nodejs client API.
	All google cloud apis are under the cap of @google-cloud.
	To install google cloud client by
		npm install --save @google-cloud/text-to-speech
	API ref: https://googleapis.dev/nodejs/text-to-speech/latest/v1.TextToSpeechClient.html 

	Remember in the sprint1 we needed the service key to make HTTP request authenticated.
	When using the client library, you don't need it anymore. The library will
	take care of it.

	This script firstly uses node:readline module to capture user's input as
	text-to-speech text. 
	The await keyword in front of the promise function call ensures the synchronous
	execution of each function.
	For the callback functions, the node:util method provides a wrapper to make
	it look like promise.

	The node:child_process has an easy function (exec) to call a shell command.

	
*/
const textToSpeech = require('@google-cloud/text-to-speech')
const fs = require('node:fs')
const util = require('node:util')
const process = require('node:process')
const childProcess = require('node:child_process')
const client = new textToSpeech.TextToSpeechClient()
const readline = require('node:readline/promises').createInterface(
	{input:process.stdin, 
	 output:process.stdout})

// make 'out' directory. delete it if it already exists.
async function mkdirOut() {
	// promisify fs.rm so that it can be called synchronizedly
	// force: true means no exception if path does not exist
	// recursive: true, otherwise, rm can only delete a file.
	await util.promisify(fs.rm)('out', {force:true, recursive: true})
	await util.promisify(fs.mkdir)('out')
}

async function run() {
	const text = await readline.question("What's in your mind? ")
	console.log("text = %s", text)
	readline.close()
	const request = {
		input: {text: text},
		voice: {languageCode: 'en-US', ssmlGender:'NEUTRAL'},
		audioConfig: {audioEncoding: 'MP3'}
	}

	const [response] = await client.synthesizeSpeech(request)

	await mkdirOut()
	const writeFile = util.promisify(fs.writeFile)
	await writeFile('out/voice.mp3', response.audioContent, 'binary')
	console.log('Audio content saved to out/voice.mp3')

	// open the voice file by default application
	childProcess.exec('cmd.exe /C start out/voice.mp3')
}

run()