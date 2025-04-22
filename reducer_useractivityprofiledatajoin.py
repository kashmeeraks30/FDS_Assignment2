#!/usr/bin/env python3
import sys

current_user = None
profile = None
activity = None

for line in sys.stdin:
    parts = line.strip().split("\t", 2)
    if len(parts) != 3:
        continue

    user_id, tag, data = parts

    if user_id != current_user:
        if current_user and profile and activity:
            print(f"{current_user}\t{profile}\t{activity}")
        current_user = user_id
        profile = activity = None

    if tag == "PROFILE":
        profile = data
    elif tag == "ACTIVITY":
        activity = data

if current_user and profile and activity:
    print(f"{current_user}\t{profile}\t{activity}")
