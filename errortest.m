main
	SET $ETRAP="DO handleError"
	WRITE "Looking for student...",!
	WRITE ^std(999,"name"),!
	WRITE "This line won't run if error!",!
	QUIT

handleError
	WRITE "════════════════════════",!
	WRITE "✗ Error: Student not found!",!
	WRITE "════════════════════════",!
	SET $ECODE=""
	QUIT
