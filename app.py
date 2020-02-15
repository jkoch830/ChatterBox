from flask import Flask, request, redirect, url_for, render_template, Response, jsonify
from flask_sqlalchemy import SQLAlchemy
import os, io

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = os.environ["DATABASE_URL"]
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SECRET_KEY"] = "8675309"
db = SQLAlchemy(app)

class Friend(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), unique=True)
    emotion = db.Column(db.String(100), unique=True)
    keyword1 = db.Column(db.String(100), unique=True)
    keyword2 = db.Column(db.String(100), unique=True)
    keyword3 = db.Column(db.String(100), unique=True)
    keyword4 = db.Column(db.String(100), unique=True)
    keyword5 = db.Column(db.String(100), unique=True)
    keyword6 = db.Column(db.String(100), unique=True)
    keyword7 = db.Column(db.String(100), unique=True)
    keyword8 = db.Column(db.String(100), unique=True)
    keyword9 = db.Column(db.String(100), unique=True)
    keyword10 = db.Column(db.String(100), unique=True)
    image = db.Column(db.LargeBinary)

    def __init__(name, emotion, keywords, image):
        self.name = name
        self.emotion = emotion
        self.keyword1 = keywords[0]
        self.keyword2 = keywords[1]
        self.keyword3 = keywords[2]
        self.keyword4 = keywords[3]
        self.keyword5 = keywords[4]
        self.keyword6 = keywords[5]
        self.keyword7 = keywords[6]
        self.keyword8 = keywords[7]
        self.keyword9 = keywords[8]
        self.keyword10 = keywords[9]
        self.image = image

    def update(name, emotion, keywords, image):
        self.name = name
        self.emotion = emotion
        self.keyword1 = keywords[0]
        self.keyword2 = keywords[1]
        self.keyword3 = keywords[2]
        self.keyword4 = keywords[3]
        self.keyword5 = keywords[4]
        self.keyword6 = keywords[5]
        self.keyword7 = keywords[6]
        self.keyword8 = keywords[7]
        self.keyword9 = keywords[8]
        self.keyword10 = keywords[9]
        self.image = image

@app.route("/enter", methods=['POST'])
def enter_new_conversation():
    if request.method == 'POST':    # new conversation
        data = request.form

        user = data['user']
        friend = data['friend']
        conversation = data['conversation']
        photo = request.files.get("profilePicture")
        photo_bytes = io.BytesIO(photo.read())
        keywords = SpeechParse.get_key_words(conversation)
        emotion = EmotionScanner.get_emotion(conversation)

        if Friend.query.filter_by(name=user).scalar():
            friend = Friend.query.filter_by(name=user)
            friend.update(name=user, emotion=emotion, keywords=keywords, image=photo.read())
            db.session.add(Friend)
            db.session.commit()
        else:
            newFriend = Friend(name=user, emotion=emotion, keywords=keywords, image=photo.read())
            db.session.add(newFriend)
            db.session.commit()
    data = {"success": True}
    return jsonify(data)
