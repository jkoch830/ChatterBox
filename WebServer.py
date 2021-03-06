from flask import Flask, request, redirect, url_for, render_template, Response, jsonify


import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase import firebase

import io, os, tempfile


import SpeechParse
import EmotionScanner
import SearchDatabase
import UpdateDatabase

app = Flask(__name__)

DATABASE_URL = "https://chatterbox-83fc3.firebaseio.com/"
ENTRY_URL = "chatterbox-83fc3/Users/"
STORAGE_URL = "chatterbox-83fc3.appspot.com/"
firebase_database = firebase.FirebaseApplication(DATABASE_URL, None)




def post_data(user, friend, key_words, emotion, photo):
    data = {'Key Words': key_words, 'Emotion': emotion, 'Photo': photo}
    if not SearchDatabase.user_in_database(user):   # user not in database
        print("BEFORE POST")
        firebase_database.post(ENTRY_URL + user + '/' + friend + '/', data)
        print("AFTER POST")
    elif SearchDatabase.current_friend_of_user(user, friend):
        current_key_words = SearchDatabase.get_key_words(user, friend)
        edited = list(set(current_key_words + key_words))  # removes
        UpdateDatabase.update(user, friend, edited, emotion, photo)
    else:       # user is in database but friend is not
        firebase_database.post(ENTRY_URL + user + '/' + friend + '/', data)


#post_data("Edward", "Sophia", ['fifth', 'first'], 'awake')
#SearchDatabase.search_database('Edward')
#SearchDatabase.user_in_database("Edward")

@app.route("/enter", methods=['POST'])
def enter_new_conversation():
    if request.method == 'POST':    # new conversation
        data = request.form
        user = data['user']
        friend = data['friend']
        conversation = data['conversation']
        photo = request.files.get("profilePicture")
        print(photo)
        b = io.BytesIO(photo.read())
        key_words = SpeechParse.get_key_words(conversation)
        emotion = EmotionScanner.get_emotion(conversation)
        post_data(user, friend, key_words, emotion, b)   # posts data
    data = {"success": True}
    return jsonify(data)


@app.route("/retrieve", methods=['POST'])
def retrieve_data():
    data = {"failed": False}
    if request.method == 'POST':            # retrieve_data
        info = request.form
        user = info['user']
        friend = info['friend']
        if SearchDatabase.user_in_database(user):
            data = SearchDatabase.search_database(user)

    return jsonify(data)



#res = SearchDatabase.search_database('Edward')
#print(res)
