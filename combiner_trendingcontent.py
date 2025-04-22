#!/usr/bin/env python3
import sys
from collections import defaultdict

content_stats = defaultdict(lambda: {"like": 0, "share": 0})

for line in sys.stdin:
    content_id, action, count = line.strip().split("\t")
    content_stats[content_id][action] += int(count)

for cid, stats in content_stats.items():
    for action in ["like", "share"]:
        if stats[action] > 0:
            print(f"{cid}\t{action}\t{stats[action]}")
