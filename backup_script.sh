#!/bin/bash

# Variables
SOURCE_DIRS="/etc /home /var/www"  # Directories to back up
BACKUP_DIR="/var/tmp/backups"  # Backup destination directory
TIMESTAMP=$(date +"%Y%m%d%H%M%S")  # Timestamp for the backup
LOG_FILE="/var/log/local_backup.log"  # Log file

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Function to perform backup of directories
perform_backup() {
    for DIR in $SOURCE_DIRS; do
        DEST="$BACKUP_DIR/$(basename $DIR)-$TIMESTAMP"
        rsync -av --delete "$DIR" "$DEST" >> "$LOG_FILE" 2>&1
        if [ $? -eq 0 ]; then
            echo "Backup of $DIR completed successfully" >> "$LOG_FILE"
        else
            echo "Backup of $DIR failed" >> "$LOG_FILE"
        fi
    done
}

# Function to save command outputs to the backup directory
save_command_outputs() {
    OUTPUT_DIR="$BACKUP_DIR/system_info-$TIMESTAMP"
    mkdir -p "$OUTPUT_DIR"

    df -h > "$OUTPUT_DIR/df-h.txt"
    lsblk > "$OUTPUT_DIR/lsblk.txt"
    adquery user > "$OUTPUT_DIR/adquery_user.txt"
    cat /etc/passwd > "$OUTPUT_DIR/passwd.txt"
    cat /etc/fstab > "$OUTPUT_DIR/fstab.txt"
    ifconfig > "$OUTPUT_DIR/ifconfig.txt"
    netstat -rn > "$OUTPUT_DIR/netstat-rn.txt"
    sar -r > "$OUTPUT_DIR/sar-r.txt"
    sar -u > "$OUTPUT_DIR/sar-u.txt"
    top -b -n 1 | head -n 20 > "$OUTPUT_DIR/top.txt"
}

# Run backup functions
perform_backup
save_command_outputs

# Optional: Remove old backups (older than 7 days)
find "$BACKUP_DIR" -type d -mtime +7 -exec rm -rf {} \; >> "$LOG_FILE" 2>&1

echo "Backup script completed at $(date)" >> "$LOG_FILE"
