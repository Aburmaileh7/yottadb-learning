main
	SET x=1000
	WRITE "Before: ",x,!
	DO addByValue(x)
	WRITE "After By Value: ",x,!
	DO addByRef(.x)
	WRITE "After By Reference: ",x,!
	QUIT

addByValue(amount)
	SET amount=amount+500
	QUIT

addByRef(amount)
	SET amount=amount+500
	QUIT
