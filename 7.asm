; LABA 7
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
	posNumOnConsole db "%d ", 0					; формат вывода числа
	negNumOnConsole db "-%d ", 0				; формат вывода числа
		
.data?		
	array dw N dup(?)							; массив
	num dw ?									; очередное вводимое число

.code

; Заполенение массива
; Передается:
; • esi - адрес массива
; • eсx - размер массива
FillArray proc
	push esi	
	put_number:
		push ecx
		invoke crt_printf, addr ZaprosNum
		invoke crt_scanf, addr numForm, addr num
		pop ecx
		mov ax, num
		mov [esi], ax
		add esi, 2
		loop put_number		
	pop esi
	ret
FillArray endp

; Перестановка соседних элементов в массиве
; Передается:
; • esi - адрес массива
; • ebx - размер массива
SwapNeighbourElems proc
	push esi
	shr ebx, 1
	mov ecx, ebx
	swap:
		mov ax, [esi]
		mov bx, [esi+1*2]
		mov [esi], bx
		add esi, 2
		mov [esi], ax
		add esi, 2
		loop swap
	pop esi
	ret
SwapNeighbourElems endp

; Вывод массива
; Передается:
; • esi - адрес массива
; • ebx - размер массива
WriteArrayOnConsole proc
	push esi
	
	xor eax, eax
	write_pos_elem:
		mov ax, [esi]
		cmp ax, 0		
		jl write_negative_elem
		invoke crt_printf, addr posNumOnConsole, eax
		jmp next
	
	write_negative_elem:
		neg ax
		invoke crt_printf, addr negNumOnConsole, eax
		jmp next
	
	next:
		add esi, 2
		dec ebx
		cmp ebx, 0
		jg write_pos_elem
		
	pop esi
	ret
WriteArrayOnConsole endp

start:
	; записываем адрес массива
	lea esi, array
	
	; заполняем массив
	mov ecx, N
	invoke FillArray
	
	; переставить соседние элементы
	mov ebx, N
	invoke SwapNeighbourElems
	
	; вывести массив
	mov ebx, N
	invoke WriteArrayOnConsole
	
	invoke ExitProcess, 0
end start