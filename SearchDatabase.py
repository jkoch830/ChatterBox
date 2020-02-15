from firebase import firebase

DATABASE_URL = "https://chatterbox-83fc3.firebaseio.com/"
firebase_database = firebase.FirebaseApplication(DATABASE_URL, None)


# returns true if user is in database
def user_in_database(user):
    data = firebase_database.get('chatterbox-83fc3/', '')
    print("CHECKING IF IN DATAL: ", data)
    if data is not None:
        if user in data['Users']:
            return True
    return False


# returns all data of a user
def search_database(user):
    result = firebase_database.get('chatterbox-83fc3/Users/' + user, '')
    return result


# returns true if user already has friend in database
def current_friend_of_user(user, friend):
    user_dict = firebase_database.get('chatterbox-83fc3/Users/' + user, '')
    if user_dict is not None and friend in user_dict:
        return True
    else:
        return False


# returns the list of key words of friend in user's friends
def get_key_words(user, friend):
    raw_dict = firebase_database.get('chatterbox-83fc3/Users/' + user + '/' +
                                 friend, '')
    keys = list(raw_dict.keys())
    key_words = raw_dict[keys[0]]['Key Words']
    return key_words

#print(get_key_words("James", "Carolyn"))

