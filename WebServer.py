from flask import Flask, request, redirect, url_for, render_template, Response, jsonify


import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase import firebase


# https://chatterboxweb.herokuapp.com/
app = Flask(__name__)

DATABASE_URL = "https://chatterbox-83fc3.firebaseio.com/"
firebase_database = firebase.FirebaseApplication(DATABASE_URL, None)


def post_data(user, friend, key_words):
    pass


@app.route("/", methods=['POST', 'GET'])
def enter_new_conversation():
    if request.method == 'POST':    # new conversation
        data = request.json
        user = data['user']
        friend = data['friend']
        conversation = data['conversation']
        key_words = SpeechParse.get_key_words(conversation)
        post_data(user, friend, key_words)   # posts data
        return jsonify({'emotion' : '', 'keyWords' : []})
    elif request.method == 'GET':   # retrieving data
        data = request.json

        user = data['user']
        other = data['other']
        mp3 = data['mp3']
        ref = db
    return "Hello, World"


