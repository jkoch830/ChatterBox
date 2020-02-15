from flask import Flask, request, redirect, url_for, render_template, Response, jsonify
import pyrebase

import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase import firebase
import os, tempfile
import SpeechParse
import EmotionScanner
import SearchDatabase
import UpdateDatabase

config = {
    "apiKey": "4XqGkMlhGvO3sIr3PFliJbblTdfhM8O0NYAVnItsiJM",
    "authDomain": "chatterbox-83fc3.firebaseapp.com",
    "databaseURL": "https://chatterbox-83fc3.firebaseio.com",
    "storageBucket": "chatterbox-83fc3.appspot.com"
}

p_firebase = pyrebase.initialize_app(config)

app = Flask(__name__)

DATABASE_URL = "https://chatterbox-83fc3.firebaseio.com/"
ENTRY_URL = "chatterbox-83fc3/Users/"
STORAGE_URL = "chatterbox-83fc3.appspot.com/"
firebase_database = firebase.FirebaseApplication(DATABASE_URL, None)


def post_data(user, friend, key_words, emotion, photo):
    # always updates friend's photo
    temp = tempfile.NamedTemporaryFile(delete=False)
    photo.save(temp.name)
    storage = p_firebase.storage()
    name = user + "_" + friend
    storage.child(name + ".jpg").put(temp.name)
    os.remove(temp.name)
    data = {'Key Words': key_words, 'Emotion': emotion}

    if not SearchDatabase.user_in_database(user):   # user not in database
        print("BEFORE POST")
        firebase_database.post(ENTRY_URL + user + '/' + friend + '/', data)
        print("AFTER POST")

    elif SearchDatabase.current_friend_of_user(user, friend):
        current_key_words = SearchDatabase.get_key_words(user, friend)
        edited = list(set(current_key_words + key_words))  # removes repeats
        UpdateDatabase.update(user, friend, edited, emotion)

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
        key_words = SpeechParse.get_key_words(conversation)
        emotion = EmotionScanner.get_emotion(conversation)
        post_data(user, friend, key_words, emotion, photo)   # posts data
    data = {"success": True}
    return jsonify(data)


@app.route("/retrieve", methods=['POST'])
def retrieve_data():
    data = {"failed": False}
    print("RETRIEVING...")
    if request.method == 'POST':            # retrieve_data
        info = request.form
        user = info['user']
        if SearchDatabase.user_in_database(user):
            storage = p_firebase.storage()
            data = SearchDatabase.search_database(user)
            print("DATA", data)
            friends = data.keys()
            for friend in friends:
                name = user + "_" + friend + ".jpg"
                url = storage.child(name).get_url("")
                data[friend]['url'] = url
    return jsonify(data)


