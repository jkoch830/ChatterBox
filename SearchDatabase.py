from firebase import firebase

DATABASE_URL = "https://chatterbox-83fc3.firebaseio.com/"
firebase_database = firebase.FirebaseApplication(DATABASE_URL, None)

result = firebase.get('chatterbox-83fc3/Users/James/Friend/')
print(result)

def search_database(user):
    pass