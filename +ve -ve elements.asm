;Assignment No.	: 2
;Assignment Name	: Write an ALP to find no. of positive / negative elements from 64-bit array 
;-------------------------------------------------------------------
section    .data                        ; initialize memory
    nline	    db	   10,10
	nline_len	equ	   $-nline

    ano		    db	   10,"	Assignment No.	: 2",10
    			db	   "Positive / Negative elements from 64-bit array", 10 
    ano_len	    equ	   $-ano
	
	arr64	    dq	   -11111111H, 22222222H, -33333333H, 44444444H, 55555555H     ; H acts as the base of hex number
	n		    equ	    5 

	pmsg		db	    10,10,"The no. of Positive elements from 64-bit array :	"
	pmsg_len	equ	    $-pmsg

	nmsg		db	    10,10,"The no. of Negative elements from 64-bit array :	"
	nmsg_len	equ	    $-nmsg

;---------------------------------------------------------------------
section .bss
    p_count     resq    1       ; Reserve space for a 64-bit integer (count of something, e.g., processes)
    n_count     resq    1       ; Reserve space for another 64-bit integer (count of something else)

    char_ans    resb    2       ; Reserve space for 2 bytes (for character input/output)
;---------------------------------------------------------------------

; Macro to print data to stdout
%macro  Print   2
    mov      rax, 1          ; syscall number for sys_write (1)
    mov      rdi, 1          ; file descriptor 1 is stdout
    mov      rsi, %1         ; address of the buffer to print (1st parameter)
    mov      rdx, %2         ; number of bytes to print (2nd parameter)
    syscall                   ; make the syscall to print
%endmacro

; Macro to read data from stdin
%macro    Read   2
    mov     rax,   0         ; syscall number for sys_read (0)
    mov     rdi,   0         ; file descriptor 0 is stdin
    mov     rsi,   %1        ; address of the buffer to read into (1st parameter)
    mov     rdx,   %2        ; number of bytes to read (2nd parameter)
    syscall                   ; make the syscall to read
%endmacro

; Macro to exit the program
%macro    Exit    0
    mov     rax,    60       ; syscall number for exit (60)
    mov     rdi,    0        ; exit code 0 (success)
    syscall                   ; make the syscall to exit
%endmacro

;---------------------------------------------------------------------
section    .text
	global   _start
_start:
	Print	ano, ano_len

	mov		rsi, arr64	;rsi is pointer that points to the first element of array
	mov		rcx, n      ;value of n is copied 

	mov		rbx,0;		; counter for 	+ve nos.
	mov		rdx,0;		; counter for	-ve nos.

next_num:
	mov		rax,[rsi]	; take no. in RAX without sq brac the location of the element will be copied
	Rol		rax,1		; rotate left 1 bit to check for sign bit 
	jc		negative    ; is  carry set

positive:
	inc		rbx			; no carry, so no. is +ve
	jmp		next        ; unconditional jump

negative:
	inc		rdx			; carry, so no. is -ve

next:
	add 	rsi,8		; 64 bit nos i.e. 8 bytes i.e points to next element
	dec 	rcx         ; decrement
	jnz  	next_num    ; jump if not zero

	mov		[p_count], rbx		; store positive count
	mov		[n_count], rdx		; store negative count

	Print	pmsg, pmsg_len
	mov 	rax,[p_count]		; load value of p_count in rax
	call 	disp64_proc		    ; display p_count

	Print	nmsg, nmsg_len
	mov 	rax,[n_count]		; load value of n_count in rax
	call 	disp64_proc		    ; display n_count

	Print	nline, nline_len
	Exit
;--------------------------------------------------------------------	
disp64_proc:
	mov 	rbx,16			; divisor=16 for hex
	mov 	rcx,2			; number of digits 
	mov 	rsi,char_ans+1	; load last byte address of char_ans buffer in rsi

cnt:mov 	rdx,0			; make rdx=0 (as in div instruction rdx:rax/rbx)
	div 	rbx

	cmp 	dl, 09h			; check for remainder in rdx
	jbe  	add30
	add  	dl, 07h 
add30:
	add 	dl,30h			; calculate ASCII code
	mov 	[rsi],dl		; store it in buffer
	dec 	rsi				; point to one byte back

	dec 	rcx				; decrement count
	jnz 	cnt				; if not zero repeat
	
	Print 	char_ans,2		; display result on screen
ret
;----------------------------------------------------------------
