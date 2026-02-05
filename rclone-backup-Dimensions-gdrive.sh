#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y-%m-%d_%H-%M)"

SRC_REMOTE="Google-DimensionsTeam:"
DST_REMOTE="Box-UCD:DimensionsTeam-GoogleBackupRclone/current"
ARCHIVE_REMOTE="Box-UCD:DimensionsTeam-GoogleBackupRclone/archive"
LOG_FILE="$HOME/logs/rclone-DimensionsGdrive-log-$STAMP.log"
CHANGES_FILE="$HOME/logs/rclone-DimensionsGdrive-changes-$STAMP.txt"
LOG_REMOTE_DIR="Box-UCD:DimensionsTeam-GoogleBackupRclone/logs"
mkdir -p "$(dirname "$LOG_FILE")"

# Keep Mac awake while this script runs
caffeinate -i -w $$ &

rclone sync -c "$SRC_REMOTE" "$DST_REMOTE" \
  --backup-dir "$ARCHIVE_REMOTE" \
  --suffix "__$STAMP" \
  --suffix-keep-extension \
  --log-file "$LOG_FILE" \
  --log-level INFO \
  --combined "$CHANGES_FILE" \
  -P --fast-list

# Upload the log file to Box
rclone copy "$LOG_FILE" "$LOG_REMOTE_DIR" --log-level INFO
rclone copy "$CHANGES_FILE" "$LOG_REMOTE_DIR" --log-level INFO
 
# Optionally remove local log after successful upload
# rm -f "$LOG_FILE"
