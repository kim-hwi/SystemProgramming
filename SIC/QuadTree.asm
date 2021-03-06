MAIN	START	1000

	JSUB	SCAN1


ALG	LDX	#1
	LDA	#0
	STX	FIRST	.first에 초기값 설정
	LDCH	DATA,X	.data 의 첫번째 값
	STA	TMP	.첫번째 값을 tmp에 넣음.
	STX	TMP2
	LDA	TMP2
	COMP	CASE
	JEQ	PRINT .다음재귀 가는것도 생각
	TIX	CASE	.case와 같다면 끝

	LDA	#-1
	+JSUB	PUSH1	.스텍에 종료값 입력
	
	LDA	#1	.a에 1을 넣음
	STA	NOWCOL	.nowcol초기화
	STA	NOWMAT	.nowmat초기화
	J	ALG2	.alg2로

ALG1	+JSUB	POP1	.pop로 괄호나 숫자를 x레지스터에 넣음
	LDX	TMP2	.x에 스텍상위값을 넣음
	LDA	TMP2	.a에 스텍상위값을 넣음
	
	COMP	#-1
	JEQ	FIN
	
	COMP	#41	.닫는 괄호와 같을때
	JEQ	PRINT2
	
	STA	FIRST	.first에 스텍상위값 넣음
	
	+JSUB	POP2	.collm, matlm 가져오기
	LDA	TMP2
	STA	COLLM
	+JSUB	POP2
	LDA	TMP2
	STA	MATLM 
	
	STX	FIRST
	LDA	#1
	STA	NOWCOL	.cowcol,nowmat 초기화
	STA	NOWMAT
	LDCH	DATA,X
	STA	TMP
	TIX	CASE

ALG2	LDA	NOWMAT	.nowmat을 a에 넣음
	COMP	MATLM	.matlm과 비교
	JEQ	PRINT3	.같다면 quit로

	LDA	COLLM 
	COMP	#1	.collm이 1이되면 재귀 종료/////
	JEQ	ALG1	

	LDA	NOWCOL	.nowcol을 a에 넣음
	COMP	COLLM	.collm과 비교
	JEQ	PLUSE 	.같다면 배열의 다음줄로 넘어가기 위해 pluse로 이동



REPLUSE	LDA	NOWMAT	.a에 nowmat를 넣음
	COMP	MATLM	.해당 행렬을 전부 돌았을 경우
	JEQ	PRINT3	.print2로 이동
	ADD	#1	.1을 더함
	STA	NOWMAT	.nowmat에 저장
	LDA	NOWCOL	.a에 nowcol을 넣음
	ADD	#1	.1을 더함
	STA	NOWCOL	.nowcol에 저징
	

	LDCH	DATA,X	.data의 x를 읽어옴
	TIX	CASE	.x+1

	COMP	TMP	.tmp와 data x를 비교
	STA	TMP	.지금의 값 tmp에 넣기
	JEQ	ALG2	.같다면 alg2로 가서 반복.

	LDA	MATLM
	COMP	NOWMAT
	JEQ	ALG1
	
	LDCH	STG
	JSUB	PRINT1	.재귀발생시 '('출력
	
	LDCH	FIG	.스텍에 ')' push
	+JSUB	PUSH1	
	
	LDA	COLLM
	DIV	#2
	STA	TMP2
	MUL	COL
	ADD	FIRST
	ADD	TMP2
	STA	FOUR
	+JSUB	PUSH1	.스텍에 네번째 값

	LDA	TMP2
	MUL	COL
	ADD	FIRST
	STA	THREE
	+JSUB	PUSH1	.스텍에 세번째 값

	LDA	COLLM
	DIV	#2
	ADD	FIRST
	STA	SECOND
	+JSUB	PUSH1	.스텍에 두번째 값

	LDA	FIRST	
	+JSUB	PUSH1	.스텍에 첫번째 값

	.LDA	STG	.스텍에 ) push
	.+JSUB	PUSH1	


	LDA	MATLM
	DIV	#4	
	+JSUB	PUSH2	.스텍에 matlm 추가
	LDA	COLLM
	DIV	#2
	+JSUB	PUSH2	.스텍에 collm추가
	LDA	MATLM
	DIV	#4	
	+JSUB	PUSH2	.스텍에 matlm 추가
	LDA	COLLM
	DIV	#2
	+JSUB	PUSH2	.스텍에 collm추가
	LDA	MATLM	
	DIV	#4
	+JSUB	PUSH2	.스텍에 matlm 추가
	LDA	COLLM
	DIV	#2
	+JSUB	PUSH2	.스텍에 collm추가
	LDA	MATLM	
	DIV	#4
	+JSUB	PUSH2	.스텍에 matlm 추가
	LDA	COLLM
	DIV	#2
	+JSUB	PUSH2	.스텍에 collm추가

	J	ALG1	.리컬시브




QUIT	JSUB	PRINT3
	

PLUSE	STX	XTMP
	LDA	XTMP	.x값 xtmp에 저장
	SUB	#1
	STA	XTMP	.1이 이미 증가한 상황이라 빼줌.
	LDA	COLLM	.a에 collm 저장
	SUB	#1	.1빼줌
	STA	TMP3
	LDA	COL
	SUB	TMP3
	ADD	XTMP
	STA	XTMP	
	LDX	XTMP
	LDA	#0
	STA	NOWCOL
	J	REPLUSE	.회귀

PRINT	TD	OUTDEV
	JEQ	PRINT
	LDA	TMP
	ADD	#48
	WD	OUTDEV
	J	FIN

PRINT1	TD	OUTDEV
	JEQ	PRINT
	WD	OUTDEV
	RSUB

PRINT2	TD	OUTDEV
	JEQ	PRINT
	WD	OUTDEV
	J	ALG1

PRINT3	TD	OUTDEV
	JEQ	PRINT
	LDA	TMP
	ADD	#48
	WD	OUTDEV
	J	ALG1


SCAN1	TD	INDEV
	JEQ	SCAN1
	RD	INDEV
	SUB	#48
	STA	CASE
	STA	COL
	STA	COLLM
	MUL	CASE
	STA	CASE
	STA	MATLM
	RD	INDEV
	COMP	ASEN
	LDX	#1
	JEQ 	SCAN2
	
SCAN2	LDA	#0
	TD	INDEV
	JEQ	SCAN2
	RD	INDEV
	COMP	ASEN
	JEQ 	SCAN2
	SUB	#48
	STCH	DATA,X
	LDA	#0
	TIX	CASE
	
	JLT	SCAN2
	JEQ 	SCAN2
	COMP	ASEN

	LDA	#STACK1
	STA	POINTER1
	LDA	#STACK2
	STA	POINTER2
	
	RSUB
	
PUSH1	STCH	@POINTER1
	LDA	POINTER1
	ADD	#1
	STA	POINTER1
	LDA	#0
	RSUB

PUSH2	STCH	@POINTER2
	LDA	POINTER2
	ADD	#1
	STA	POINTER2
	LDA	#0
	RSUB

POP1	LDA	POINTER1	
	SUB	#1		.스텍포인터 다운
	STA	POINTER1
	LDA	#0
	LDCH	@POINTER1	.a에 스텍상위값 넣음
	STA	TMP2		.그 값을 tmp2에 넣음
	LDX	TMP2		.그 값을 x에 넣음
	LDA	#0
	STA	@POINTER1	.스텍 값 초기화	
	
	RSUB

POP2	LDA	POINTER2
	SUB	#1
	STA	POINTER2
	LDA	#0	
	LDCH	@POINTER2
	STA	TMP2
	.LDX	TMP2
	LDA	#0
	STA	@POINTER2
	
	RSUB


STG	BYTE	C'('
FIG	BYTE	C')'
TMPL	RESW	1
TMPNUM	RESW	1
ASEN	WORD	10
CASE	RESW	1
TEST	RESB	1
INDEV	BYTE	0
OUTDEV	BYTE	1
DATA	RESB	65
TMP	RESW	1
TMP2	RESW	1
TMP3	RESW	1
COL	RESW	1
COLLM	RESW	1
MATLM	RESW	1
NOWCOL	RESW	1
NOWMAT	RESW	1
STACK1	RESB	65
STACK2	RESB	65
XTMP	RESW	1  
FIRST	RESW	1
SECOND	RESW	1
THREE	RESW	1
FOUR	RESW	1
POINTER1	RESW	1
POINTER2	RESW	1


FIN	LDA	#0