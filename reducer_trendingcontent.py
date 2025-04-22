#!/usr/bin/env python3
import sys

current_id = None
likes = 0
shares = 0

for line in sys.stdin:
    content_id, action, count = line.strip().split("\t")
    count = int(count)

    if current_id and content_id != current_id:
        trending_score = likes + shares
        if trending_score >= 100:  # threshold can be tuned based on dataset
            print(f"{current_id}\tTRENDING_SCORE={trending_score}")
        current_id, likes, shares = content_id, 0, 0

    if content_id != current_id:
        current_id = content_id

    if action == "like":
        likes += count
    elif action == "share":
        shares += count

# Final content
if current_id:
    trending_score = likes + shares
    if trending_score >= 100:
        print(f"{current_id}\tTRENDING_SCORE={trending_score}")
