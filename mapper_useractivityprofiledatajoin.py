#!/usr/bin/env python3
import sys
import os

input_source = os.environ.get('map_input_file', '')

for line in sys.stdin:
    parts = line.strip().split("\t")
    if 'user_profiles.txt' in input_source:
        if len(parts) >= 4:
            user_id = parts[0]
            profile_data = "\t".join(parts[1:])
            print(f"{user_id}\tPROFILE\t{profile_data}")
    else:
        user_id = parts[0]
        activity_data = "\t".join(parts[1:])
        print(f"{user_id}\tACTIVITY\t{activity_data}")
