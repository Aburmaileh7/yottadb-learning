main
	SET $ETRAP="DO handleError"
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "       Bank System      ",!
	WRITE "════════════════════════",!
	WRITE !
        WRITE "1) Show all accounts",!
	WRITE "2) Add account",!
	WRITE "3) Deposit / Withdraw",!
	WRITE "4) Transfer",!
	WRITE "5) Transaction History",!
	WRITE "6) Change PIN",!
	WRITE "7) Freeze account",!
	WRITE "8) Delete account",!
	WRITE "9) Exit",!	
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Choice: " READ choice WRITE !
	IF choice=1 DO showAll
	IF choice=2 DO addAccount
	IF choice=3 DO depositWithdraw
	IF choice=4 DO transfer
	IF choice=5 DO history
	IF choice=6 DO changePIN
	IF choice=7 DO freezeAccount
	IF choice=8 DO deleteAccount
	IF choice=9 QUIT
	DO main
	QUIT

showAll
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "      All Accounts      ",!
	WRITE "════════════════════════",!
	WRITE !
	SET I=""
	SET count=0
	FOR  SET I=$ORDER(^bank(I)) QUIT:I=""  DO printAccount
	WRITE !
	WRITE "Total: ",count," accounts",!
	WRITE !
	WRITE "════════════════════════",!
	QUIT

printAccount
	WRITE I,") ",^bank(I,"name")," - Balance: $",^bank(I,"balance"),!
	SET count=count+1
	QUIT

checkPIN
	SET pinOK=0
	IF ^bank(ID,"attempts")>=3 DO
	. WRITE "✗ Account locked! Use Freeze menu to unlock.",!
	. QUIT
	IF pin=^bank(ID,"pin") DO
	. SET ^bank(ID,"attempts")=0
	. SET pinOK=1
	ELSE  DO
	. SET ^bank(ID,"attempts")=^bank(ID,"attempts")+1
	. SET left=3-^bank(ID,"attempts")
	. IF left>0 WRITE "✗ Wrong PIN! ",left," attempts left!",!
	. IF left=0 DO
	.. SET ^bank(ID,"frozen")=1
	.. WRITE "✗ Account frozen! Too many wrong attempts!",!
	QUIT


addAccount
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "       Add Account      ",!
	WRITE "════════════════════════",!
	WRITE !
	WRITE "Name (0 to cancel): " READ name WRITE !
	IF name="0" QUIT
	IF name="" WRITE "✗ Name cannot be empty!",! DO addAccount QUIT
	WRITE "PIN (4 digits): " READ pin WRITE !
	IF pin="0" QUIT
	IF pin="" WRITE "✗ PIN cannot be empty!",! DO addAccount QUIT
	WRITE "Initial balance: $" READ balance WRITE !
	IF balance="0" QUIT
	IF balance'=+balance WRITE "✗ Invalid amount!",! DO addAccount QUIT
	IF balance<0 WRITE "✗ Balance cannot be negative!",! DO addAccount QUIT
	SET ID=$ORDER(^bank(""),-1)+1
	SET ^bank(ID,"name")=name
	SET ^bank(ID,"pin")=pin
	SET ^bank(ID,"balance")=balance
	SET ^bank(ID,"history",1)="Account opened - $"_balance
	SET ^bank(ID,"attempts")=0
	WRITE !
	WRITE "════════════════════════",!
	WRITE "✓ Account created! ID=",ID,!
	QUIT

depositWithdraw
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "    Deposit / Withdraw  ",!
	WRITE "════════════════════════",!
	WRITE !
	DO showAll
	WRITE "Account ID (0 to cancel): " READ ID WRITE !
	IF ID="0" QUIT
	IF ID="" QUIT
	IF '$DATA(^bank(ID)) WRITE "✗ Account not found!",! QUIT
	WRITE "PIN: " READ pin WRITE !
	DO checkPIN
	IF pinOK=0 QUIT
	WRITE !
	WRITE "Current balance: $",^bank(ID,"balance"),!
	SET frozen=0
	DO checkFrozen
	IF frozen=1 QUIT
	WRITE !
	WRITE "1) Deposit",!
	WRITE "2) Withdraw",!
	WRITE "0) Cancel",!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Choice: " READ dchoice WRITE !
	IF dchoice=1 DO deposit
	IF dchoice=2 DO withdraw
	QUIT

deposit
	WRITE "Amount: $" READ amount WRITE !
	IF amount'=+amount WRITE "✗ Invalid amount!",! QUIT
	IF amount<=0 WRITE "✗ Must be positive!",! QUIT
	LOCK +^bank(ID)
	TSTART ()
	SET ^bank(ID,"balance")=^bank(ID,"balance")+amount
	SET hID=$ORDER(^bank(ID,"history",""),-1)+1
	SET ^bank(ID,"history",hID)="Deposit: +$"_amount
	TCOMMIT
	LOCK -^bank(ID)
	WRITE !
	WRITE "════════════════════════",!
	WRITE "✓ Deposited $",amount,!
	WRITE "New balance: $",^bank(ID,"balance"),!
	QUIT

withdraw
	WRITE "Amount: $" READ amount WRITE !
	IF amount'=+amount WRITE "✗ Invalid amount!",! QUIT
	IF amount<=0 WRITE "✗ Must be positive!",! QUIT
	IF ^bank(ID,"balance")<amount WRITE "✗ Insufficient balance!",! QUIT
	LOCK +^bank(ID)
	TSTART ()
	SET ^bank(ID,"balance")=^bank(ID,"balance")-amount
	SET hID=$ORDER(^bank(ID,"history",""),-1)+1
	SET ^bank(ID,"history",hID)="Withdraw: -$"_amount
	TCOMMIT
	LOCK -^bank(ID)
	WRITE !
	WRITE "════════════════════════",!
	WRITE "✓ Withdrawn $",amount,!
	WRITE "New balance: $",^bank(ID,"balance"),!
	QUIT

transfer
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "        Transfer        ",!
	WRITE "════════════════════════",!
	WRITE !
	DO showAll
	WRITE "From Account ID (0 to cancel): " READ fromID WRITE !
	IF fromID="0" QUIT
	IF fromID="" QUIT
	IF '$DATA(^bank(fromID)) WRITE "✗ Account not found!",! QUIT
	WRITE "PIN: " READ pin WRITE !
	DO checkPIN
	IF pinOK=0 QUIT
	SET frozen=0
	DO checkFrozen
	IF frozen=1 QUIT
	WRITE "To Account ID: " READ toID WRITE !
	IF toID="0" QUIT
	IF toID="" QUIT
	IF '$DATA(^bank(toID)) WRITE "✗ Account not found!",! QUIT
	IF fromID=toID WRITE "✗ Cannot transfer to same account!",! QUIT
	WRITE "Amount: $" READ amount WRITE !
	IF amount'=+amount WRITE "✗ Invalid amount!",! QUIT
	IF amount<=0 WRITE "✗ Must be positive!",! QUIT
	IF ^bank(fromID,"balance")<amount WRITE "✗ Insufficient balance!",! QUIT
	LOCK +^bank(fromID),+^bank(toID)
	TSTART ()
	SET ^bank(fromID,"balance")=^bank(fromID,"balance")-amount
	SET ^bank(toID,"balance")=^bank(toID,"balance")+amount
	SET hID=$ORDER(^bank(fromID,"history",""),-1)+1
	SET ^bank(fromID,"history",hID)="Transfer to "_^bank(toID,"name")_": -$"_amount
	SET hID=$ORDER(^bank(toID,"history",""),-1)+1
	SET ^bank(toID,"history",hID)="Transfer from "_^bank(fromID,"name")_": +$"_amount
	TCOMMIT
	LOCK -^bank(fromID),-^bank(toID)
	WRITE !
	WRITE "════════════════════════",!
	WRITE "✓ Transfer done!",!
	WRITE ^bank(fromID,"name"),": $",^bank(fromID,"balance"),!
	WRITE ^bank(toID,"name"),": $",^bank(toID,"balance"),!
	QUIT

history
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "   Transaction History  ",!
	WRITE "════════════════════════",!
	WRITE !
	DO showAll
	WRITE "Account ID (0 to cancel): " READ ID WRITE !
	IF ID="0" QUIT
	IF ID="" QUIT
	IF '$DATA(^bank(ID)) WRITE "✗ Account not found!",! QUIT
	WRITE "PIN: " READ pin WRITE !
	DO checkPIN
	IF pinOK=0 QUIT
	SET frozen=0
	DO checkFrozen
	IF frozen=1 QUIT
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "  History: ",^bank(ID,"name"),"  ",!
	WRITE "════════════════════════",!
	WRITE !
	SET hI=""
	FOR  SET hI=$ORDER(^bank(ID,"history",hI)) QUIT:hI=""  DO
	. WRITE hI,") ",^bank(ID,"history",hI),!
	WRITE !
	WRITE "Current balance: $",^bank(ID,"balance"),!
	WRITE !
	WRITE "════════════════════════",!
	QUIT

deleteAccount
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "      Delete Account    ",!
	WRITE "════════════════════════",!
	WRITE !
	DO showAll
	WRITE "Account ID (0 to cancel): " READ ID WRITE !
	IF ID="0" QUIT
	IF ID="" QUIT
	IF '$DATA(^bank(ID)) WRITE "✗ Account not found!",! QUIT
	WRITE "PIN: " READ pin WRITE !
	DO checkPIN
	IF pinOK=0 QUIT
	WRITE !
	WRITE "Account: ",^bank(ID,"name"),!
	WRITE "Balance: $",^bank(ID,"balance"),!
	WRITE !
	WRITE "════════════════════════",!
	WRITE "Type 'yes' to confirm: " READ confirm WRITE !
	IF confirm="yes" DO
	. KILL ^bank(ID)
	. WRITE "✓ Account deleted!",!
	IF confirm'="yes" WRITE "Cancelled!",!
	QUIT

changePIN
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "       Change PIN       ",!
	WRITE "════════════════════════",!
	WRITE !
	DO showAll
	WRITE "Account ID (0 to cancel): " READ ID WRITE !
	IF ID="0" QUIT
	IF ID="" QUIT
	IF '$DATA(^bank(ID)) WRITE "✗ Account not found!",! QUIT
	WRITE "Current PIN: " READ pin WRITE !
	DO checkPIN
	IF pinOK=0 QUIT
	WRITE "New PIN (4 digits): " READ newpin WRITE !
	IF newpin="" WRITE "✗ PIN cannot be empty!",! QUIT
	SET ^bank(ID,"pin")=newpin
	SET hID=$ORDER(^bank(ID,"history",""),-1)+1
	SET ^bank(ID,"history",hID)="PIN changed"
	WRITE !
	WRITE "════════════════════════",!
	WRITE "✓ PIN changed!",!
	QUIT

freezeAccount
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "      Freeze Account    ",!
	WRITE "════════════════════════",!
	WRITE !
	DO showAll
	WRITE "Account ID (0 to cancel): " READ ID WRITE !
	IF ID="0" QUIT
	IF ID="" QUIT
	IF '$DATA(^bank(ID)) WRITE "✗ Account not found!",! QUIT
	WRITE "PIN: " READ pin WRITE !
	DO checkPIN
	IF pinOK=0 QUIT
	IF $DATA(^bank(ID,"frozen")) DO
	. KILL ^bank(ID,"frozen")
	. WRITE "✓ Account unfrozen!",!
	ELSE  DO
	. SET ^bank(ID,"frozen")=1
	. WRITE "✓ Account frozen!",!
	QUIT

checkFrozen
	IF $DATA(^bank(ID,"frozen")) DO
	. WRITE "✗ Account is frozen!",!
	. SET frozen=1
	ELSE  SET frozen=0
	QUIT

handleError
	FOR i=1:1:3 WRITE !
	WRITE "════════════════════════",!
	WRITE "✗ Something went wrong!",!
	WRITE "  Returning to menu...  ",!
	WRITE "════════════════════════",!
	SET $ECODE=""
	DO main
	QUIT
EOF
