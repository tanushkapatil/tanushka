; Assignment 6: (using 64-bit registers)
; This program first checks the mode of the processor (Real or Protected),
; then reads GDTR, IDTR, LDTR, TR, MSW and displays the same.

section    .data
	nline	db	10,10                    ; New line character (two line feeds)
	nline_len	equ	$-nline               ; Length of new line string
	colon		db	":"                     ; Colon string for output

	rmsg 	db 	10,'Processor is in Real Mode...' ; Message for Real Mode
	rmsg_len	equ 	$-rmsg               ; Length of Real Mode message

	pmsg 	db 	10,'Processor is in Protected Mode...' ; Message for Protected Mode
	pmsg_len	equ 	$-pmsg               ; Length of Protected Mode message

	gmsg		db	10,"GDTR (Global Descriptor Table Register)	: " ; GDTR message
	gmsg_len	equ	$-gmsg               ; Length of GDTR message

	imsg		db	10,"IDTR (Interrupt Descriptor Table Register)	: " ; IDTR message
	imsg_len	equ	$-imsg               ; Length of IDTR message

	lmsg		db	10,"LDTR (Local Descriptor Table Register)	: " ; LDTR message
	lmsg_len	equ	$-lmsg               ; Length of LDTR message

	tmsg		db	10,"TR (Task Register)		: " ; TR message
	tmsg_len	equ	$-tmsg               ; Length of TR message

	mmsg		db	10,"MSW (Machine Status Word)	: " ; MSW message
	mmsg_len	equ	$-mmsg               ; Length of MSW message

section   .bss
	GDTR		resw	3		; Reserve space for GDTR (3 words, 48 bits)
	IDTR		resw	3		; Reserve space for IDTR (3 words)
	LDTR		resw	1		; Reserve space for LDTR (1 word, 16 bits)
	TR		resw	1		; Reserve space for TR (1 word)
	MSW		resw	1		; Reserve space for MSW (1 word)

	char_ans	resb	4		; Buffer for character output (4 bytes)

; Macros for system calls and exit
%macro  Print   2
	mov   rax, 1                      ; System call for write
	mov   rdi, 1                      ; File descriptor 1 (stdout)
	mov   rsi, %1                     ; Pointer to message
	mov   rdx, %2                     ; Length of message
	syscall                           ; Call kernel
%endmacro

%macro  Read   2
	mov   rax, 0                      ; System call for read
	mov   rdi, 0                      ; File descriptor 0 (stdin)
	mov   rsi, %1                     ; Pointer to buffer
	mov   rdx, %2                     ; Length of buffer
	syscall                           ; Call kernel
%endmacro

%macro	Exit	0
	mov  rax, 60                       ; System call for exit
	mov  rdi, 0                        ; Exit code 0
	syscall                           ; Call kernel
%endmacro

section    .text
	global   _start                    ; Entry point for the program

_start:
	SMSW		[MSW]                 ; Store Machine Status Word in MSW

	mov		rax,[MSW]              ; Move MSW value into RAX
	ror 		rax,1                  ; Rotate right to check the PE bit (bit 1)
	jc 		p_mode                 ; If carry flag is set, jump to protected mode

	Print	rmsg,rmsg_len            ; Print Real Mode message
	jmp		next                   ; Jump to next section

p_mode:	
	Print	pmsg,pmsg_len            ; Print Protected Mode message

next:
	SGDT		[GDTR]                ; Store GDTR in GDTR variable
	SIDT		[IDTR]                ; Store IDTR in IDTR variable
	SLDT		[LDTR]                ; Store LDTR in LDTR variable
	STR		[TR]                   ; Store Task Register in TR variable
	SMSW		[MSW]                  ; Store Machine Status Word in MSW

	Print	gmsg, gmsg_len            ; Print GDTR message
	mov 		ax,[GDTR+4]            ; Load GDTR high word into AX
	call 	disp16_proc              ; Display GDTR contents
	mov 		ax,[GDTR+2]            ; Load GDTR middle word into AX
	call 	disp16_proc              ; Display GDTR contents
	Print	colon,1                   ; Print colon
	mov 		ax,[GDTR+0]            ; Load GDTR low word into AX
	call 	disp16_proc              ; Display GDTR contents

	Print	imsg, imsg_len            ; Print IDTR message
	mov 		ax,[IDTR+4]            ; Load IDTR high word into AX
	call 	disp16_proc              ; Display IDTR contents
	mov 		ax,[IDTR+2]            ; Load IDTR middle word into AX
	call 	disp16_proc              ; Display IDTR contents
	Print	colon,1                   ; Print colon
	mov 		ax,[IDTR+0]            ; Load IDTR low word into AX
	call 	disp16_proc              ; Display IDTR contents

	Print	lmsg, lmsg_len            ; Print LDTR message
	mov 		ax,[LDTR]              ; Load LDTR into AX
	call 	disp16_proc              ; Display LDTR contents

	Print	tmsg, tmsg_len            ; Print TR message
	mov 		ax,[TR]                ; Load TR into AX
	call 	disp16_proc              ; Display TR contents

	Print	mmsg, mmsg_len            ; Print MSW message
	mov 		ax,[MSW]               ; Load MSW into AX
	call 	disp16_proc              ; Display MSW contents

	Print	nline, nline_len          ; Print new line
	Exit                              ; Exit program

; Procedure to display a 16-bit value in hexadecimal
disp16_proc:
	mov 		rbx,16                  ; Divisor = 16 for hexadecimal
	mov 		rcx,4                   ; Number of digits (4 hex digits)
	mov 		rsi,char_ans+3          ; Pointer to the last byte of char_ans buffer

cnt:	mov 		rdx,0                   ; Clear RDX for division
	div 		rbx                      ; Divide RAX by 16, result in RAX, remainder in RDX

	cmp 		dl, 09h                 ; Check remainder (0-9)
	jbe  	add30                     ; If <= 9, jump to add30
	add  	dl, 07h                   ; Adjust remainder for hex (A-F)

add30:
	add 		dl,30h                  ; Convert to ASCII
	mov 		[rsi],dl                ; Store it in buffer
	dec 		rsi                     ; Move to the next byte

	dec 		rcx                     ; Decrement digit count
	jnz 		cnt                     ; If not zero, repeat

	Print 	char_ans,4               ; Print the resulting hexadecimal string
ret                                 ; Return from procedure
