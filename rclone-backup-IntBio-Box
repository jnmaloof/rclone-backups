#!/usr/bin/env bash
# This script backs up IntBio Box folder to another folder on Box

set -euo pipefail

STAMP="$(date +%Y-%m-%d_%H-%M)"

SRC_REMOTE="Box-UCD:IntBioTeam"
DST_REMOTE="Box-UCD:IntBioTeam-BoxBackupRclone/current"
ARCHIVE_REMOTE="Box-UCD:IntBioTeam-BoxBackupRclone/archive"
LOG_FILE="$HOME/logs/rclone-IntBioBoxlog-$STAMP.log"
CHANGES_FILE="$HOME/logs/rclone-IntBioBox-changes-$STAMP.txt"
LOG_REMOTE_DIR="Box-UCD:IntBioTeam-BoxBackupRclone/logs"
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
