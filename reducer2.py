#!/usr/bin/env python
#MapReduce job to sort in descending order by the number of posts
import sys

for line in sys.stdin:
    _, user_id, actions_json = line.strip().split('\t', 2)
    print(f"{user_id}\t{actions_json}")