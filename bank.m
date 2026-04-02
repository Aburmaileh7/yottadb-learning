main
	SET $ETRAP="DO handleError"
	IF '$DATA(^bank(1)) DO setupAccounts
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "      Bank System       ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Account 1: ",^bank(1,"name")," - $",^bank(1,"balance"),!
	WRITE "Account 2: ",^bank(2,"name")," - $",^bank(2,"balance"),!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Transfer amount (0 to cancel): " READ amount WRITE !
	IF amount=0 QUIT
	IF amount="" QUIT
	IF amount'=+amount WRITE "✗ Invalid amount!",! DO main QUIT
	IF amount<=0 WRITE "✗ Amount must be positive!",! DO main QUIT
	IF ^bank(1,"balance")<amount WRITE "✗ Insufficient balance!",! DO main QUIT
	TSTART ()
	SET ^bank(1,"balance")=^bank(1,"balance")-amount
	SET ^bank(2,"balance")=^bank(2,"balance")+amount
	TCOMMIT
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "✓ Transfer done!",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Account 1: $",^bank(1,"balance"),!
	WRITE "Account 2: $",^bank(2,"balance"),!
	DO main
	QUIT

setupAccounts
	SET ^bank(1,"name")="Mohammad"
	SET ^bank(1,"balance")=1000
	SET ^bank(2,"name")="Ali"
	SET ^bank(2,"balance")=500
	QUIT

handleError
	TROLLBACK
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "✗ Error! Transaction cancelled!",!
	WRITE "No money was transferred!",!
	WRITE "════════════════════════",!
	SET $ECODE=""
	DO main
	QUIT
