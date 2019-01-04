DBID=$BUILD_NUMBER
NOW=`date +"%Y-%m-%d %T"`
LOG=$PWD/timer.txt

function insertTable() {
	echo "insert into client_timers(id, version, started_at) values($DBID, $SVN_REVISION, '$NOW');" >> $LOG
}

function updateTable() {
	echo "update client_timers set $1 = '$NOW' where id = $DBID;" >> $LOG
}

case "$1" in
	started_at)
		insertTable;;
	*)
		#echo "$1: $NOW";
		updateTable $1;;
esac
