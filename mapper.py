#!/usr/bin/env python3
#MapReduce job to parse and filter out malformed or incomplete records
import sys
import json
from datetime import datetime

DISCARDED_COUNTER = "MalformedRecords"

def is_valid_timestamp(ts):
    try:
        datetime.strptime(ts, "%Y-%m-%dT%H:%M:%SZ")
        return True
    except ValueError:
        return False

for line in sys.stdin:
    line = line.strip()
    parts = line.split('\t')
    
    if len(parts) != 5:
        print(f"reporter:counter:CustomCounters,{DISCARDED_COUNTER},1", file=sys.stderr)
        continue

    timestamp, user_id, action_type, content_id, metadata_json = parts

    if not is_valid_timestamp(timestamp):
        print(f"reporter:counter:CustomCounters,{DISCARDED_COUNTER},1", file=sys.stderr)
        continue

    try:
        metadata = json.loads(metadata_json)
    except json.JSONDecodeError:
        print(f"reporter:counter:CustomCounters,{DISCARDED_COUNTER},1", file=sys.stderr)
        continue

    print(f"{timestamp}\t{user_id}\t{action_type}\t{content_id}\t{json.dumps(metadata)}")
