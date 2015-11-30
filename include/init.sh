BASEDIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASEDIR"

if [ -r "$1" ] ; then
  . "$1"
elif [ -r "$(dirname "$0")/backup.conf" ] ; then
	. "$(dirname "$0")/backup.conf"
else
	. /etc/backup.conf
fi

mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"  || exit
