#!/bin/bash
# This script switches to the next audio output sink using wpctl (for PipeWire),
# skipping any sinks defined in the SKIP_LIST by device name.

# Define a list of sink names to skip.
SKIP_LIST=("ALC1220 Digital")

ID_FILE="/tmp/notification_id"

# Read the previous notification id if it exists, or default to 0
if [ -f "$ID_FILE" ]; then
  last_notification_id=$(cat "$ID_FILE")
else
  last_notification_id=0
fi

# delete tmp file if error
if [[ ! "$last_notification_id" =~ ^[0-9]+$ ]]; then
  rm $ID_FILE
  last_notification_id=0
fi


# Function to check if a sink name is in the skip list.
# Usage: in_skip_list <sink_name>
in_skip_list() {
  local sink_name="$1"
  for skip in "${SKIP_LIST[@]}"; do
    if [[ "$sink_name" == "$skip" ]]; then
      return 0  # Found in skip list.
    fi
  done
  return 1  # Not found.
}


send_notification() {
  local header="$1"
  local text="$2"
  # Capture the new notification ID from notify-send, including stderr
  last_notification_id=$(notify-send -e -p -r $last_notification_id --expire-time=200 --app-name="Audio output switcher" "$header" "$text" 2>&1)
  # Save the new ID for future invocations
  echo "$last_notification_id" > "$ID_FILE"
}

# Get the wpctl status output and extract only the Sinks block (ID + Name).
sink_info=$(wpctl status -k | awk '
  /Sinks:/ {sink_block=1; next}
  sink_block && /^[[:space:]]*[├└]/ {sink_block=0}
  sink_block && /^[[:space:]]*│/ {
    sub(/^[[:space:]]*│[[:space:]]*/, "");
    current = ($0 ~ /^\*/) ? 1 : 0;
    sub(/^\*\s*/, "");
    if (match($0, /^([0-9]+)\./, id_match)) {
      id = id_match[1];
      name = substr($0, index($0, ". ") + 2);
      sub(/\[vol: [0-9.]+\]/, "", name);  # Remove volume info.
      gsub(/[[:space:]]+$/, "", name);      # Trim trailing spaces.
      print id, current, name;
    }
  }
')

# Build arrays for sink IDs and names, and identify the current sink.
declare -a sinks sink_names
current_index=-1
index=0
while read -r id is_current name; do
  sinks[index]=$id
  sink_names[index]="$name"
  if [ "$is_current" -eq 1 ]; then
    current_index=$index
  fi
  index=$((index + 1))
done <<< "$sink_info"

# Check that we found sinks.
if [ ${#sinks[@]} -eq 0 ]; then
  echo "No sinks found. Exiting."
  send_notification "Audio switch error" "No sinks found."
  exit 1
fi

# If no current sink was found (unlikely), default to the first sink.
if [ $current_index -eq -1 ]; then
  current_index=0
fi

# Function to find the next valid sink (skipping those in SKIP_LIST by name).
find_next_sink() {
  local start_index=$1
  local count=${#sinks[@]}
  local i=$(( (start_index + 1) % count ))
  while [ $i -ne $start_index ]; do
    if ! in_skip_list "${sink_names[i]}"; then
      echo "$i"
      return 0
    fi
    i=$(( (i + 1) % count ))
  done
  # If the starting sink itself is acceptable, use it.
  if ! in_skip_list "${sink_names[start_index]}"; then
    echo "$start_index"
    return 0
  fi
  return 1
}

next_index=$(find_next_sink "$current_index")

if [ -z "$next_index" ]; then
  echo "No available sink found (all sinks are in the skip list)."
  send_notification "Audio switch error" "No available sink found (all sinks are in the skip list)."
  exit 1
fi

next_sink_id=${sinks[$next_index]}
next_sink_name=${sink_names[$next_index]}

echo "Switching from '${sink_names[$current_index]}' to '${next_sink_name}' (Sink ID: $next_sink_id)"
wpctl set-default "$next_sink_id"

if [ "$?" -eq 0 ]; then
    send_notification "Audio Output Switched" "New Output: ${next_sink_name}"
else
    send_notification "Error" "Audio output switch failed!"
fi