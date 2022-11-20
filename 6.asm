; LABA 6
.386
.model flat, stdcall

include kernel32.inc
include msvcrt.inc
Include masm32.inc
includelib kernel32.lib
includelib msvcrt.lib
includelib masm32.lib

N EQU 32

.const
	ZaprosNum db "Enter a number in binary form", 0
	AnswerZero db "Count of zero %d", 10, 0
	AnswerOne db "Count of ones %d", 10, 0

.data
	numForm db "%d", 0		
	count_zero db 0			
	count_one db 0			
	
.data?
	InputString db N dup(?)	
	lenString dw ?			
	num dword ?				

.code
start:
	invoke StdOut, addr ZaprosNum
	invoke StdIn, addr InputString, LengthOf InputString	
	
	mov lenString, ax	
	lea esi, InputString
	cld
	
	xor eax, eax

ten2bin:
	cmp lenString, 0
	je main
	lodsb
	sub al, 30h
	shl num, 1
	add num, eax
	dec lenString
	jmp ten2bin

main:
	mov eax, num

metka:
	cmp eax, 0
	je exit
	test eax, 1
	jz add_zero
	jmp add_one
	
add_zero:
	inc count_zero
	shr eax, 1
	jmp metka
	
add_one:
	inc count_one
	shr eax, 1
	jmp metka
	
exit:
	invoke crt_printf, addr AnswerZero, count_zero
	invoke crt_printf, addr AnswerOne, count_one
	invoke ExitProcess, 0
	
end start