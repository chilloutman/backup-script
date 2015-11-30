#!/bin/bash -e

. "$(dirname $0)/include/init.sh"

# 1. Create backup directory

DESTINATION="backup_$(date '+%FT%H-%M')"
mkdir "$DESTINATION"

# 2. Create backup archives

cd "$DESTINATION"  || exit

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

# 3. Delete old backups

cd "$BACKUP_DIR" || exit
. "$BASEDIR/include/remove-old-backups.sh"
