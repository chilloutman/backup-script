#!bin/bash -e

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
