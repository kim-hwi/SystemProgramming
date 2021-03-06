MAIN	START	1000
INLOOP	TD	INDEV
	JEQ	INLOOP
	RD	INDEV
	SUB	#48
	STA	CASE
	RD	INDEV
	COMP	ASEN
	LDX	#1
	LDT	CASE
	LDA	#STACK
	STA	POINTER
	JEQ 	LOOP
	

LOOP	LDA	#0
	TD	INDEV2
	JEQ	LOOP
	RD	INDEV2
	SUB	#48
	STCH	DATA,X
	LDA	POINTER
	ADD	#1
	STA	POINTER
	LDA	#0
	RD	INDEV2
	TIX	CASE
	JGT	FINLOOP
	COMP	ASEN
	JEQ 	LOOP
	
POP	RD	INDEV2
	TIX	CASE
	LDA	POINTER
	SUB	#1
	STA	POINTER
	LDA	#0
	STA	@POINTER
	JGT	FINLOOP
	J	LOOP		

FINLOOP	LDX	#0
	LDA	#0
STOP	LDCH	STACK,X
	TIX	CASE
	ADD	RES
	.ADD	#48
	STA	RES
	JLT	STOP
	STA	RES
PRINT	TD	OUTDEV
	JEQ	PRINT
	LDA	RES
	DIV	#10
	COMP	#0
	JEQ	ONE
	STA	TMP	
	ADD	#48
	WD	OUTDEV
	
	LDA	RES
	LDX	#0
	LDL	TMP
SUB10	TIXR	L
	SUB	#10
	JEQ	TWO
	J	SUB10

TWO	ADD	#48
	WD	OUTDEV
	J	FINISH

ONE	LDCH	RES
	ADD	#48
	WD	OUTDEV

FINISH	LDA	RES

.INDEV	BYTE	0
.OUTDEV	BYTE	1
DATA	BYTE	13
TMP	BYTE	1
POINTER	RESW	1
INDEV	BYTE	0
INDEV2	BYTE	0
CASE	RESW	1
STACK	RESB	10	
ASEN	WORD	10
RES	WORD	0
OUTDEV	BYTE	1
	