; LABA 1
.586
.model flat, stdcall
option casemap:none

Include kernel32.inc
Include masm32.inc
IncludeLib kernel32.lib
IncludeLib masm32.lib

.CONST
	MsgExit DB 13,10,"Press Enter to Exit",0AH,0DH,0

.data
	Zapros DB 13,10,'Input number',13,10,0
	Result DB 'Result='
	ResStr DB 16 DUP (' '),0

.data?
	Buffer DB 10 DUP (?)
	inbuf DB 100 DUP (?)
	a word ?
	b word ?
	c_ word ?

.code

; Ввод числа с клавиатуры,
; конвертация в числовой вид,
; и запись результата в регистр eax
write_number proc
	Invoke StdOut, ADDR Zapros
	Invoke StdIn, ADDR Buffer, LengthOf Buffer
	Invoke StripLF, ADDR Buffer
	Invoke atol, ADDR Buffer
	ret
write_number endp

start:
	call write_number
	mov a, AX
	
	call write_number
	mov b, AX
	
	call write_number
	mov c_, AX
	
	xor eax, eax
	
	mov ax, b	; в регистр ax записываем число b
	dec ax		; уменьшаем значение регистра ax на единицу (b-1)
	mov bx, ax	; перемещаем значение из регистра ex в регистр bx 
	mov ax, c_	; в регистр ax записываем число
	mov cx, 2	; в регистр сx записываем 2 (множитель)
	mul cx		; умножаем значение регистра ax на значение регистра cx (c * 2). Результат будет храниться в DX:AX
	div bx		; делим резульат на значение регистра bx (2*c/(b-1))
	add ax, a	; плюсуем a (2*c/(b-1) + a)
	
	Invoke dwtoa, eax, ADDR ResStr
	Invoke StdOut, ADDR Result
	
	Invoke StdOut, ADDR MsgExit
	Invoke StdIn, ADDR inbuf,LengthOf inbuf
	Invoke ExitProcess, 0

end start