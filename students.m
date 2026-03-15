main
	WRITE "========================",!
	WRITE "   Student System       ",!
	WRITE "========================",!
	WRITE !
	WRITE "1) Show all students",!
	WRITE "2) Add student",!
	WRITE "3) Delete student",!
	WRITE "4) Exit",!
	WRITE !
	WRITE "Choice: " READ choice WRITE !
	WRITE !
	IF choice=1 DO showAll
	IF choice=2 DO addStudent
	IF choice=3 DO deleteStudent
	IF choice=4 QUIT
	DO main
	QUIT

showAll
	WRITE "--- Students ---",!
	WRITE !
	SET I=""
	FOR  SET I=$ORDER(^std(I)) QUIT:I=""  DO printOne
	WRITE !
	WRITE "----------------",!
	QUIT

printOne
	WRITE I,") ",^std(I,"name")," - ",^std(I,"age")," - ",^std(I,"major"),!
	QUIT

addStudent
	WRITE "--- Add Student ---",!
	WRITE !
	WRITE "Name: " READ name WRITE !
	WRITE "Age: " READ age WRITE !
	WRITE "Major: " READ major WRITE !
	SET ID=$ORDER(^std(""),-1)+1
	SET ^std(ID,"name")=name
	SET ^std(ID,"age")=age
	SET ^std(ID,"major")=major
	WRITE !
	WRITE "Added! ID=",ID,!
	QUIT

deleteStudent
	WRITE "--- Delete Student ---",!
	WRITE !
	WRITE "Enter ID: " READ ID WRITE !
	IF '$DATA(^std(ID)) WRITE "ID not found!",! QUIT
	WRITE "Deleting: ",^std(ID,"name"),!
	KILL ^std(ID)
	WRITE "Deleted!",!
	QUIT
