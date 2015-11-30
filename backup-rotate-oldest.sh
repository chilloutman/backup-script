#!/bin/bash -e

. "$(dirname $0)/include/init.sh"

# 1. Create rotation directory

ROTATION_DIR="$BACKUP_DIR/old"
mkdir -p "$ROTATION_DIR"

# 2. Move least recent backup

OLDEST_BACKUP="$(find . -maxdepth 1 -type d -name 'backup_*' | sort | head -1)"
if [ -d "$OLDEST_BACKUP" ] ; then
	echo "Rotating oldest backup to: $ROTATION_DIR"
	mv "$OLDEST_BACKUP" "$ROTATION_DIR"
fi

# 3. Delete old rotated backups

cd "$ROTATION_DIR" || exit
. "$BASEDIR/include/remove-old-backups.sh"
