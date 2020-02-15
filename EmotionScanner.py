#!/usr/bin/env python3

import paralleldots

API_KEY = "4XqGkMlhGvO3sIr3PFliJbblTdfhM8O0NYAVnItsiJM"
paralleldots.set_api_key( API_KEY )


def get_emotion(text):
    return paralleldots.emotion(text)
