from google.cloud import texttospeech
import shutil
import os

text = input("What's in your mind? ")
client = texttospeech.TextToSpeechClient()
response = client.synthesize_speech(
        input=texttospeech.SynthesisInput(text=text), 
        voice=texttospeech.VoiceSelectionParams(
                language_code='en-US', 
                ssml_gender=texttospeech.SsmlVoiceGender.NEUTRAL),
        audio_config=texttospeech.AudioConfig(
                audio_encoding=texttospeech.AudioEncoding.MP3))

shutil.rmtree('out', ignore_errors=True)
os.mkdir('out')

with open('out/voice.mp3', 'wb') as out:
    out.write(response.audio_content)
    print('Audio content saved to out/voice.mp3')

os.execl("/mnt/c/Windows/system32/cmd.exe", "/C", "start", "out/voice.mp3")