#!/usr/bin/env python3
# import libraries
import face_recognition
import cv2
import numpy as np

# This is a demo of running face recognition on live video from your webcam. It's a little more complicated than the
# other example, but it includes some basic performance tweaks to make things run a lot faster:
#   1. Process each video frame at 1/4 resolution (though still display it at full resolution)
#   2. Only detect faces in every other frame of video.

# PLEASE NOTE: This example requires OpenCV (the `cv2` library) to be installed only to read from your webcam.
# OpenCV is *not* required to use the face_recognition library. It's only required if you want to run this
# specific demo. If you have trouble installing it, try any of the other demos that don't require it instead.







#makes a (face encoding, name) tuple from an image and name
def create_face_encoding_plus_name(img, name):
    image = face_recognition.load_image_file(img)
    return (face_recognition.face_encodings(image)[0], name)

#puts takes a list of pictures and their names in tuples and inserts them in the known face encodings and known face names lists
def append_to_face_encodings_and_name_arrays (list_of_tuple_pic_names, known_face_encodings, known_face_names):
    for pic in list_of_tuple_pic_names:
        face_enc_name = create_face_encoding_plus_name(pic[0], pic[1])
        known_face_encodings.append (face_enc_name[0])
        known_face_names.append (face_enc_name[1])
    return

#takes in a new picture and identifies a list of faces in it
def identify_from_new (new, known_face_encodings, known_face_names):
    face_locations = []
    face_encodings = []
    face_names = []
    new_encoding = face_recognition.load_image_file(new)
    face_locations = face_recognition.face_locations(new_encoding)
    face_encodings = face_recognition.face_encodings(new_encoding, face_locations)
    for face_encoding in face_encodings:
        # See if the face is a match for the known face(s)
        matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
        name = "Unknown"
        #look at each of the values of the match, see which names they associate to and add those to 
        #the list of face_names
        for m in range (len(matches)):
            if matches[m]:
                face_names.append(known_face_names[m])
    return face_names





def main():
    # Create arrays of known face encodings and their names
    known_face_encodings = []
    known_face_names = []

    #HERE IS WHERE WE INPUT NAMES AND PICS hardcode some pics and names
    list_of_tuple_pic_names = [("obama.jpg", "Barack Obama"), ("sophia1.jpg", "Sophia Lau")]
    new = "sophia2.jpg"

    append_to_face_encodings_and_name_arrays (list_of_tuple_pic_names, known_face_encodings, known_face_names)
    print (identify_from_new (new, known_face_encodings, known_face_names))
    return

main()

