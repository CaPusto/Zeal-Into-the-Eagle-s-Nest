#!/bin/bash

# Backup script for Into the Eagle's Nest Zeal port

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
BACKUP_DIR="$HOME/backups"

# Create backups directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="zeal-eaglenest_backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

echo "Creating backup: $BACKUP_PATH"

# Backup project (exclude build and large files)
tar -czf "$BACKUP_PATH" \
    --exclude='build' \
    --exclude='*.bin' \
    --exclude='*.ihx' \
    --exclude='.git' \
    -C "$(dirname "$PROJECT_DIR")" \
    "$(basename "$PROJECT_DIR")"

if [ $? -eq 0 ]; then
    echo "✓ Backup created: $BACKUP_PATH"
    echo "  Size: $(du -h "$BACKUP_PATH" | cut -f1)"
    
    # List recent backups
    echo ""
    echo "Recent backups:"
    ls -lh "$BACKUP_DIR"/eaglenest_backup_*.tar.gz | tail -5
else
    echo "✗ Error creating backup"
    exit 1
fi
