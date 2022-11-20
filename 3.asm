.586
.model flat, stdcall
option casemap:none

Include kernel32.inc
Include masm32.inc
IncludeLib kernel32.lib
IncludeLib masm32.lib

.data
	res db 13,10,'elem = '
	Output DB 8 DUP (' '),0
	ZaprosNumber db 13,10,'Write a number',13,10,0
	ZaprosMultiplier db 13,10,'Write a multiplier',13,10,0
	k db 8
	
.data?
	Buffer DB 10 DUP (?)
	q word ?

.code

start:

	Invoke StdOut, ADDR ZaprosNumber
	Invoke StdIn, ADDR Buffer, LengthOf Buffer
	Invoke StripLF, ADDR Buffer
	Invoke atol, ADDR Buffer
	mov bx, ax
	
	Invoke StdOut, ADDR ZaprosMultiplier
	Invoke StdIn, ADDR Buffer, LengthOf Buffer
	Invoke StripLF, ADDR Buffer
	Invoke atol, ADDR Buffer
	mov q, ax
	
mark:
	xor eax, eax
	mov ax, bx
	Invoke dwtoa, eax, ADDR Output
	Invoke StdOut, ADDR res	
	
	mov ax, bx
	mul q
	mov bx, ax
	dec k
	cmp k, 0
	jg mark

	Invoke ExitProcess, 0

end start