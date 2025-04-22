#!/usr/bin/env python
# MapReduce job to sort in descending order by the number of posts
import sys
import json

for line in sys.stdin:
    user_id, actions_json = line.strip().split('\t')
    actions = json.loads(actions_json)
    post_count = actions.get('post', 0)

    # Emit post_count as part of key to sort by it
    # Negate to sort descending (Hadoop sorts ascending by default)
    print(f"{str(9999999 - post_count).zfill(7)}\t{user_id}\t{actions_json}")
