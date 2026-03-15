main
	DO greet
	DO calculate
	QUIT
greet
	WRITE "Hallo Mohammad!",!
	QUIT
calculate
	FOR I=1:1:10 DO check
	QUIT
check
	WRITE I," "
	IF I#2=0 WRITE "Even",!
	ELSE  WRITE "Odd",!
	QUIT
