fact	START	0
	EXTDEF	push
	EXTDEF	pop
	EXTDEF	result

	COMP	#1
	JEQ	exit
	STA	tmpA
	STL	tmpL

	+JSUB	push
	LDA	tmpL
	+JSUB	push
	LDA	tmpA
	JSUB	fact
	JSUB	fact
	+JSUB	pop
	STA	tmpL
	+JSUB	pop

	ADD	result
	STA	result
	LDL	tmpL
	RSUB
exit	RSUB

resilt	WORD 	1
tmpL	RESW	1
tmpA	RESW	1
gap	RESW	64