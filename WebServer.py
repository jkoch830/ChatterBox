from flask import Flask, request, redirect, url_for, render_template, Response, jsonify

app = Flask(__name__)

# chatterboxweb.heroku.web.com
# https://chatterboxweb.herokuapp.com/


@app.route("/", methods=['POST'])
def hello_world():
    content = request.get_json()
    print(content)
    return "Hello, World"


