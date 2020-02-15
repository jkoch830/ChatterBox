from flask import Flask, request, redirect, url_for, render_template, Response, jsonify


import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase import firebase
import SpeechParse
import EmotionScanner
import SearchDatabase
import UpdateDatabase


# https://chatterboxweb.herokuapp.com/
app = Flask(__name__)

DATABASE_URL = "https://chatterbox-83fc3.firebaseio.com/"
ENTRY_URL = "chatterbox-83fc3/Users/"
firebase_database = firebase.FirebaseApplication(DATABASE_URL, None)



def post_data(user, friend, key_words, emotion):
    # if user not in database
    #data = {'Key Words' : key_words, 'Emotion' : emotion}
    if SearchDatabase.current_friend_of_user(user, friend):
        print("Here")
        current_key_words = SearchDatabase.get_key_words(user, friend)
        edited = list(set(current_key_words + key_words))  # removes
        UpdateDatabase.update(user, friend, edited, emotion)
    else:
        data = {'Key Words' : key_words, 'Emotion' : emotion}
        firebase_database.post(ENTRY_URL + user + '/' + friend + '/', data)


#post_data("Edward", "Carolyn", ['third', 'fourth'], 'awake')
SearchDatabase.search_database('Edward')
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
        print("REQUESTING DATA")
        info = request.json
        user = info['user']
        data = SearchDatabase.search_database(user)
        return jsonify(data)
    return "Hello, World"


