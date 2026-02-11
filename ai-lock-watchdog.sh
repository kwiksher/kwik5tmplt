#!/bin/bash
# --- SINGLETON CHECK ---
# If another instance of this script is running, exit silently
pgrep -f "ai-lock-watchdog.sh" | grep -v $$ > /dev/null && exit 0

# Configuration
LOCK_EXTENSION=".lock"
STALE_THRESHOLD_MINS=5
CHECK_INTERVAL_SECS=30

echo "🚀 AI Agent Lock Watchdog started..."
echo "Monitoring for stale *$LOCK_EXTENSION files (older than $STALE_THRESHOLD_MINS mins)"

while true; do
    # Find all .lock files older than X minutes
    STALE_LOCKS=$(find . -name "*$LOCK_EXTENSION" -mmin +$STALE_THRESHOLD_MINS)

    if [ -n "$STALE_LOCKS" ]; then
        echo "⚠️ Found stale locks:"
        echo "$STALE_LOCKS"

        for lock in $STALE_LOCKS; do
            echo "🧹 Removing stale lock: $lock"
            rm "$lock"
            # Optional: Send a desktop notification (macOS/Linux)
            # osascript -e 'display notification "Stale AI lock removed" with title "Watchdog"'
        done
    fi

    sleep $CHECK_INTERVAL_SECS
done