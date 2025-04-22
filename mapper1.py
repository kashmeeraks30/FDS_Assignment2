#!/usr/bin/env python
#MapReduce job to aggregate, for each user, the total count of each action type (posts, likes, comments, shares)
import sys
import json

for line in sys.stdin:
    line = line.strip()
    parts = line.split('\t')
    if len(parts) != 5:
        continue

    _, user_id, action_type, _, _ = parts
    print(f"{user_id}\t{action_type}")
