#!/usr/bin/env python3
import retinasdk
liteClient = retinasdk.LiteClient("6ea5d540-4fb8-11ea-8f72-af685da1b20e")


def get_key_words(text):
    return liteClient.getKeywords(text)
