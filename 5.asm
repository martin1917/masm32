; LABA 5
.386
.model flat, stdcall

include kernel32.inc
include msvcrt.inc
Include masm32.inc
includelib kernel32.lib
includelib msvcrt.lib
includelib masm32.lib

;=====defain======
SPACE EQU 20h
SYMBOL_A EQU 61h
;=================

.const
	Zapros db "Write string:",10,0

.data	
	stringForm db "%s", 10,0	;формат вывода строки
	lenBuff dw 0				;кол-во заполненых ячеек в буфере

.data?
	InputString db 10240 dup(?)	; входная строка
	Buffer db 1024 dup(?)		; буфер для очередного слова из строки
	lenString dw ?				; кол-во введенных символов в строке {InputString}

.code
start:
	invoke StdOut, addr Zapros
	invoke StdIn, addr InputString, LengthOf InputString
	mov lenString, ax		; в регистре ax хранится кол-во прочитанных символов из консоли
	lea esi, InputString	; считывать символы будем из строки InputString
	lea edi, Buffer			; записывать будем в буфер Buffer
	cld						; читаем слева направо
	
extract_word:
	cmp lenString, 0
	je pre_exit				; если прочитали все символы из строки, то идем в pre_exit; для завершения
	lodsb					; читаем очередной символ из строки InputString
	dec lenString			; уменьшаем кол-во оставшихся повторений (т.к. был считан 1 символ)
	cmp al, SPACE
	jne take_symbol			; если считанный символ не пробел, то идем в take_symbol; для извлечения очередного символа
	cmp lenBuff, 0			
	jne check_word			; если встретили пробел и буфер не пуст, то идем в check_word; для проверки слова
	jmp extract_word		; повторяем
	
check_word:
	lea edi, Buffer			; перемещаем указатель в начало буфера
	mov bl, [edi]			; помещаем в регистр bl первый элемент из буфера
	cmp bl, SYMBOL_A		
	je write_correct_word	; если первый символ это 'a', то идем в write_correct_word; для вывода этого слова
	jmp clear_buffer		; иначе идем в clear_buffer; для очистки буфера
	
write_correct_word:
	invoke crt_printf, addr stringForm, addr Buffer	; выводим на экран содержимое буфера
	jmp clear_buffer								; переходим в clear_buffer; для очистки буфера

ptr_buffer_start:
	lea edi, Buffer		; переводим указатель в начало буфера
	jmp extract_word	; переходим в extract_word; извлекаем слова дальше

clear_buffer:				; очищение бефера
	cmp lenBuff, 0
	je ptr_buffer_start		; если буфер очищен, то идем в ptr_buffer_start; для возврата указателя в начало буфера
	mov al, 0
	stosb
	dec lenBuff
	jmp clear_buffer

take_symbol:
	stosb				; записываем прочитанный символ в буфер Buffer
	inc lenBuff			; увеличиваем кол-во записанных символов в буфер
	jmp extract_word	; возвращаемся к обработке строки 

pre_exit:
	cmp lenBuff, 0
	jne check_word		; если в буфере что-то есть - выводим
	jmp exit			; если буфер пуст, то выходим

exit:
	invoke ExitProcess, 0
	
end start