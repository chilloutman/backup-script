#!/bin/bash -e

. /etc/backup.conf

mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"

# 1. Create Backup Directory

DESTINATION="backup_$(date '+%FT%H-%M')"
mkdir "$DESTINATION"

# 2. Create Backup Archives

cd "$DESTINATION"

echo "Creating backups in: $(pwd)"
for SOURCE in "${BACKUP_SOURCES[@]}" ; do
  ARCHIVE_NAME="$(hostname)_${SOURCE:1}" # Remove first /
  ARCHIVE_NAME="${ARCHIVE_NAME//\//-}" # / to -
  ARCHIVE_NAME="${ARCHIVE_NAME// /_}" # space to _

  EXCLUDE_FILE="$SOURCE/.backup-exclude"
  if ! [ -r "$EXCLUDE_FILE" ] ; then
    EXCLUDE_FILE=
  fi

  set -x
  tar -czp -f "$ARCHIVE_NAME.tar.gz" ${EXCLUDE_FILE:+-X "$EXCLUDE_FILE"} "$SOURCE"
  set +x
done

# 3. Delete Old Backups

cd "$BACKUP_DIR"

ALL_BACKUPS=()
while read -r -d '' ; do
  ALL_BACKUPS+=("$REPLY")
done < <(find . -maxdepth 1 -type d -name 'backup_*' -print0 | sort -rz)

OLD_BACKUPS=("${ALL_BACKUPS[@]:$BACKUPS_TO_KEEP}")
OLD_BACKUPS_COUNT="${#OLD_BACKUPS[@]}"
if (( $OLD_BACKUPS_COUNT > 0 )) ; then
  echo "Deleting $OLD_BACKUPS_COUNT old backups"
  rm -r "${OLD_BACKUPS[@]}"
fi
