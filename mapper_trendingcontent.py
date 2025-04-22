#!/usr/bin/env python3
import sys

for line in sys.stdin:
    try:
        parts = line.strip().split("\t")
        if len(parts) < 5:
            continue

        action = parts[1]
        content_id = parts[2]

        if action in ("like", "share"):
            print(f"{content_id}\t{action}\t1")
    except:
        continue
