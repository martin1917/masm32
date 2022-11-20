; LABA 4
.386
.model flat, stdcall

include kernel32.inc
include msvcrt.inc
includelib kernel32.lib
includelib msvcrt.lib


.data
	N EQU 8										; размер массива
	ZaprosNum db "Write number: ", 0			; запрос на ввод очередного числа
	numForm db "%d", 0							; формат ввода числа
	numOnConsole db "%d ", 0					; формат вывода числа
		
.data?		
	array dw N dup(?)							; массив
	i db ?										; переменная для цикла
	k db ?										
	num dw ?									; очередное вводимое число

.code

start:

;==================заполнение массива================
	lea esi, array
	mov i, N									
fill_array:
	invoke crt_printf, addr ZaprosNum
	invoke crt_scanf, addr numForm, addr num
	mov ax, num
	mov [esi], ax
	add esi, 2
	dec i
	cmp i, 0
	jg fill_array
;=============перестановка соседних элементов=======
	mov k, N
	shr k, 1		;деление на 2
	lea esi, array
alg:
	mov ax, [esi]
	mov bx, [esi+1*2]
	mov [esi], bx
	add esi, 2
	mov [esi], ax
	add esi, 2
	dec k
	cmp k, 0
	jg alg
;==================вывод массива===================
	lea esi, array
	mov i, N
write_array:
	mov ax, [esi]
	invoke crt_printf, addr numOnConsole, ax
	add esi, 2
	dec i
	cmp i, 0
	jg write_array
	
	invoke ExitProcess, 0
end start