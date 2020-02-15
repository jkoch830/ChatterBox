from flask import Flask, request, redirect, url_for, render_template, Response, jsonify


import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase import firebase
import SpeechParse
import EmotionScanner


# https://chatterboxweb.herokuapp.com/
app = Flask(__name__)
'''
DATABASE_URL = "https://chatterbox-83fc3.firebaseio.com/"
firebase_database = firebase.FirebaseApplication(DATABASE_URL, None)
data = {
                'User' : "James",
                'Friend' : "Koch",
                'Key Words' : ["python", "project"],
                'Emotion' : "tired"
    }
result = firebase_database.post('chatterbox-83fc3/Users/James/Friend2', "Test")
print(result)

'''

def post_data(user, friend, key_words, emotion):
    # if user not in database
    data = {
                'User' : user,
                'Friend' : friend,
                'Key Words' : key_words,
                'Emotion' : emotion
    }
    result = firebase_database.post('chatterbox-83fc3/Users/', data)
    return result


@app.route("/", methods=['POST', 'GET'])
def enter_new_conversation():
    if request.method == 'POST':    # new conversation
        data = request.json
        user = data['user']
        friend = data['friend']
        conversation = data['conversation']
        key_words = SpeechParse.get_key_words(conversation)
        emotion = EmotionScanner.get_emotion(conversation)
        post_data(user, friend, key_words, emotion)   # posts data
        return jsonify({'emotion' : '', 'keyWords' : []})
    elif request.method == 'GET':   # retrieving data
        return jsonify({"Send": "Test"})
        data = request.json

        user = data['user']
        other = data['other']
        mp3 = data['mp3']
        ref = db
    return "Hello, World"


