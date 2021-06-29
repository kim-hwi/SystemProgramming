main	START	0
	EXTREF	result
	EXTREF	fact
	EXTREF	print
	EXTREF	stinit

	LDA	#gap
	+JSUB	stinit
loop	LDA	#1
	+STA	result
	LDA	i
	ADD	#1
	STA	i
	COMP	#10
	JEQ	halt
	+JSUB	fact
	+LDA	result
	+JSUB	print
	J	loop
halt	J	halt

i	WORD 	0
gap	RESW	64
	END	main