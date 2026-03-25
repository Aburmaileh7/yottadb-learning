main
	SET $ETRAP="DO handleError"
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "      Student System    ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "1) Show all students",!
	WRITE "2) Add student",!
	WRITE "3) Edit student",!
	WRITE "4) Search student",!
	WRITE "5) Delete student",!
	WRITE "6) Exit",!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Choice: " READ choice WRITE !
	IF choice=1 DO showAll
	IF choice=2 DO addStudent
	IF choice=3 DO editMenu
	IF choice=4 DO searchMenu
	IF choice=5 DO deleteStudent
	IF choice=6 QUIT
	DO main
	QUIT

showAll
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "     All Students       ",!
	WRITE "════════════════════════",!
	WRITE !
	SET I=""
	SET count=0
	FOR  SET I=$ORDER(^std(I)) QUIT:I=""  DO printOne
	WRITE !
	WRITE "Total: ",count," students",!
	WRITE !
	WRITE "════════════════════════",!
	QUIT

printOne
	WRITE !
	WRITE I,") ",^std(I,"name"),!
	SET field=""
	FOR  SET field=$ORDER(^std(I,field)) QUIT:field=""  DO
	. IF field'="name" WRITE "   ",field,": ",^std(I,field),!
	SET count=count+1
	QUIT

addStudent
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "      Add Student       ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Name (or 0 to cancel): " READ name WRITE !
	IF name="0" QUIT
	IF name="" WRITE "Name cannot be empty!",! DO addStudent QUIT
	WRITE "Age: " READ age WRITE !
	IF age="" WRITE "Age cannot be empty!",! DO addStudent QUIT
	WRITE "Major: " READ major WRITE !
	IF major="" WRITE "Major cannot be empty!",! DO addStudent QUIT
	SET ID=$ORDER(^std(""),-1)+1
	SET ^std(ID,"name")=name
	SET ^std(ID,"age")=age
	SET ^std(ID,"major")=major
	WRITE !
	WRITE "════════════════════════",!
	WRITE "✓ Added! ID=",ID,!
	QUIT

editMenu
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "      Edit Student      ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "1) Show all students",!
	WRITE "2) Enter ID directly",!
	WRITE "3) Back",!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Choice: " READ echoice WRITE !
	IF echoice=1 DO showAllForEdit
	IF echoice=2 DO enterEditID
	IF echoice=3 DO main
	QUIT

showAllForEdit
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "   Select Student       ",!
	WRITE "════════════════════════",!
	WRITE !
	SET I=""
	FOR  SET I=$ORDER(^std(I)) QUIT:I=""  DO
	. WRITE I,") ",^std(I,"name"),!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Enter ID: " READ ID WRITE !
	IF ID="" QUIT
	IF '$DATA(^std(ID)) WRITE "ID not found!",! QUIT
	DO editFields
	QUIT

enterEditID
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "      Edit Student      ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Enter ID (or 0 to cancel): " READ ID WRITE !
	IF ID="0" QUIT
	IF ID="" QUIT
	IF '$DATA(^std(ID)) WRITE "ID not found!",! QUIT
	DO editFields
	QUIT

editFields
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "   Editing: ",^std(ID,"name"),"   ",!
	WRITE "════════════════════════",!
	WRITE !
	SET field=""
	SET num=0
	FOR  SET field=$ORDER(^std(ID,field)) QUIT:field=""  DO
	. SET num=num+1
	. SET fieldList(num)=field
	. WRITE num,") Edit ",field,!
	SET addNum=num+1
	SET backNum=num+2
	WRITE addNum,") Add new field",!
	WRITE backNum,") Back",!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Choice: " READ echoice WRITE !
	IF echoice=backNum QUIT
	IF echoice=addNum DO addField QUIT
	SET field=""
	SET num=0
	FOR  SET field=$ORDER(^std(ID,field)) QUIT:field=""  DO
	. SET num=num+1
	. IF echoice=num DO editField
	QUIT

editField
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "  Edit: ",fieldList(echoice),"  ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Current: ",^std(ID,fieldList(echoice)),!
	WRITE !
	WRITE "New value (or 0 to cancel): " READ newval WRITE !
	IF newval="0" QUIT
	IF newval'="" SET ^std(ID,fieldList(echoice))=newval
	WRITE "════════════════════════",!
	WRITE "✓ Updated!",!
	QUIT

addField
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "      Add New Field     ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Field name (or 0 to cancel): " READ fname WRITE !
	IF fname="0" QUIT
	IF fname="" QUIT
	WRITE "Value (or 0 to cancel): " READ fvalue WRITE !
	IF fvalue="0" QUIT
	SET ^std(ID,fname)=fvalue
	WRITE "════════════════════════",!
	WRITE "✓ Field '",fname,"' added!",!
	QUIT

searchMenu
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "        Search          ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "1) Search by name",!
	WRITE "2) Search by ID",!
	WRITE "3) Back",!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Choice: " READ schoice WRITE !
	IF schoice=1 DO searchByName
	IF schoice=2 DO searchByID
	IF schoice=3 DO main
	QUIT

searchByName
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "    Search by Name      ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Enter name (or 0 to cancel): " READ sname WRITE !
	IF sname="0" QUIT
	IF sname="" QUIT
	SET I=""
	SET found=0
	FOR  SET I=$ORDER(^std(I)) QUIT:I=""  DO checkName
	IF found=0 DO
	. WRITE "════════════════════════",!
	. WRITE "✗ Not found!",!
	QUIT

checkName
	IF $ZCONVERT(^std(I,"name"),"U")[$ZCONVERT(sname,"U") DO
	. FOR i=1:1:3 WRITE !
	. WRITE "════════════════════════",!
	. WRITE "✓ Found!",!
	. WRITE "════════════════════════",!
	. WRITE !
	. WRITE "ID: ",I,!
	. SET field=""
	. FOR  SET field=$ORDER(^std(I,field)) QUIT:field=""  DO
	.. WRITE "   ",field,": ",^std(I,field),!
	. SET found=1
	QUIT

searchByID
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "     Search by ID       ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Enter ID (or 0 to cancel): " READ ID WRITE !
	IF ID="0" QUIT
	IF ID="" QUIT
	IF '$DATA(^std(ID)) DO  QUIT
	. WRITE "════════════════════════",!
	. WRITE "✗ Not found!",!
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "✓ Found!",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "ID: ",ID,!
	SET field=""
	FOR  SET field=$ORDER(^std(ID,field)) QUIT:field=""  DO
	. WRITE "   ",field,": ",^std(ID,field),!
	WRITE !
	WRITE "════════════════════════",!
	QUIT

deleteStudent
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "     Delete Student     ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "1) Show all students",!
	WRITE "2) Enter ID directly",!
	WRITE "3) Back",!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Choice: " READ dchoice WRITE !
	IF dchoice=1 DO showAllForDelete
	IF dchoice=2 DO enterDeleteID
	IF dchoice=3 DO main
	QUIT

showAllForDelete
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "   Select to Delete     ",!
	WRITE "════════════════════════",!
	WRITE !
	SET I=""
	FOR  SET I=$ORDER(^std(I)) QUIT:I=""  DO
	. WRITE I,") ",^std(I,"name"),!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Enter ID: " READ ID WRITE !
	IF ID="" QUIT
	IF '$DATA(^std(ID)) WRITE "ID not found!",! QUIT
	DO confirmDelete
	QUIT

enterDeleteID
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "     Delete Student     ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Enter ID (or 0 to cancel): " READ ID WRITE !
	IF ID="0" QUIT
	IF ID="" QUIT
	IF '$DATA(^std(ID)) WRITE "ID not found!",! QUIT
	DO confirmDelete
	QUIT

confirmDelete
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "  ⚠ Confirm Delete      ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Student: ",^std(ID,"name"),!
	WRITE "Age: ",^std(ID,"age"),!
	WRITE "Major: ",^std(ID,"major"),!
	WRITE !
	WRITE "Type 'yes' to confirm: " READ confirm WRITE !
	IF confirm="yes" DO
	. KILL ^std(ID)
	. WRITE "════════════════════════",!
	. WRITE "✓ Deleted!",!
	IF confirm'="yes" DO
	. WRITE "════════════════════════",!
	. WRITE "Cancelled!",!
	QUIT

handleError
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "✗ Something went wrong! ",!
	WRITE "  Returning to menu...  ",!
	WRITE "════════════════════════",!
	SET $ECODE=""
	DO main
	QUIT
