main
	SET I=""
	FOR  SET I=$ORDER(^std(I)) QUIT:I=""  DO print
	QUIT
print
	WRITE I,") ",^std(I,"name")," - ",^std(I,"age"),!
	QUIT
