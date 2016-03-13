(defun evalStatement(statement)
	
	(COND
		((ATOM statement) statement)
		(T (List (evalStatement (CAR statement)) (evalStatement (NTH 2 statement)) (NTH 1 statement)))
	)
)