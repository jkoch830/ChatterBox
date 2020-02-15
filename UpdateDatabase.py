from firebase import firebase

DATABASE_URL = "https://chatterbox-83fc3.firebaseio.com/"
ENTRY_URL = "chatterbox-83fc3/Users/"
firebase_database = firebase.FirebaseApplication(DATABASE_URL, None)


def update(user, friend, new_key_words, new_emotion):
    raw_dict = firebase_database.get(ENTRY_URL + user + '/' +
                                     friend + '/', '')
    keys = list(raw_dict.keys())
    key_code = keys[0]
    firebase_database.put(ENTRY_URL + user + '/' + friend + '/' + key_code,
                          'Emotion', new_emotion)
    firebase_database.put(ENTRY_URL + user + '/' + friend + '/' + key_code,
                          'Key Words', new_key_words)
