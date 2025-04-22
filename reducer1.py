#!/usr/bin/env python
import sys
from collections import defaultdict

current_user = None
action_counts = defaultdict(int)

for line in sys.stdin:
    try:
        print(f"Reducer received: {line.strip()}", file=sys.stderr)  # Debug info
        user_id, action_type = line.strip().split('\t')

        if current_user and current_user != user_id:
            for action, count in action_counts.items():
                print(f"{current_user}\t{action}\t{count}")
            action_counts = defaultdict(int)

        current_user = user_id
        action_counts[action_type] += 1

    except Exception as e:
        print(f"Reducer error: {e}", file=sys.stderr)  # Catch line format errors
        continue

if current_user:
    for action, count in action_counts.items():
        print(f"{current_user}\t{action}\t{count}")
