.586
.model flat, stdcall
option casemap:none

Include kernel32.inc
Include masm32.inc
IncludeLib kernel32.lib
IncludeLib masm32.lib

.data
	res db ' '
	ResStr DB 16 DUP (' '),0
	Zapros DB 13,10,'Input number',13,10,0
	ans db 13,10,'Answer: ',13,10,0

.data?
	Buffer DB 10 DUP (?)
	a word ?
	b word ?
	
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
	
	cmp a, ax
	jg great
	
	mov ebx, eax
	
	Invoke StdOut, ADDR ans
	Invoke dwtoa, dword ptr a, ADDR ResStr
	Invoke StdOut, ADDR res
	Invoke dwtoa, ebx, ADDR ResStr
	Invoke StdOut, ADDR res
	jmp exit

great:
	Invoke StdOut, ADDR ans
	Invoke dwtoa, dword ptr a, ADDR ResStr
	Invoke StdOut, ADDR res
	jmp exit

exit:
	Invoke ExitProcess, 0

end start