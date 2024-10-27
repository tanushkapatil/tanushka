section .data
        nline       db      10,10                   ; Define two newline characters
        nline_len   equ     $-nline                  ; Calculate length of newline

        space       db      " "                       ; Define a space character

        ano         db      10,"    Assignment no    :4-A",  ; Assignment header
                    db      10,"-------------------------------------------------------------------", 
                    db      10,"    Block Transfer- Overlapped without String instruction.",
                    db      10,"-------------------------------------------------------------------",10
        ano_len     equ     $-ano                     ; Calculate length of assignment header

        bmsg        db      10,"Before Transfer::"    ; Message displayed before data transfer
        bmsg_len    equ     $-bmsg                    ; Length of the before message

        amsg        db      10,"After Transfer::"     ; Message displayed after data transfer
        amsg_len    equ     $-amsg                    ; Length of the after message
        
        smsg        db      10,"    Source Block      :" ; Message for the source block
        smsg_len    equ     $-smsg                    ; Length of the source message

        dmsg        db      10,"    Destination Block  :" ; Message for the destination block
        dmsg_len    equ     $-dmsg                    ; Length of the destination message

        sblock      db      11h,22h,33h,44h,55h       ; Define the source block with hex values
        dblock      times    5   db 0                  ; Reserve space for the destination block, initialized to 0
	
;------------------------------------------------------------------------------
section .bss
        char_ans    resB    2                         ; Reserve 2 bytes for storing character answer
	
;-----------------------------------------------------------------------------

%macro   Print   2                                   ; Macro to print data
        MOV     RAX,1                                   ; Set syscall number for write
        MOV     RDI,1                                   ; Set file descriptor to 1 (stdout)
        MOV     RSI,%1                                  ; Load pointer to data to write into RSI
        MOV     RDX,%2                                  ; Load length of data to write into RDX
    syscall                                              ; Make the syscall
%endmacro

%macro   Read    2                                   ; Macro to read data (not used in this snippet)
        MOV     RAX,0                                   ; Set syscall number for read
        MOV     RDI,0                                   ; Set file descriptor to 0 (stdin)
        MOV     RSI,%1                                  ; Load pointer to buffer to store input
        MOV     RDX,%2                                  ; Load length of the input buffer
    syscall                                              ; Make the syscall
%endmacro

%macro   Exit    0                                   ; Macro to exit the program
        Print   nline,nline_len                        ; Print a newline before exiting
        MOV     RAX,60                                  ; Set syscall number for exit
        MOV     RDI,0                                   ; Set exit status to 0
    syscall                                              ; Make the syscall
%endmacro
;---------------------------------------------------------------       

section .text
        global _start                                   ; Define entry point for the program

_start:
        Print   ano,ano_len                            ; Print the assignment header

        Print   bmsg,bmsg_len                          ; Print the before transfer message

        Print   smsg,smsg_len                          ; Print the source block message
        mov     rsi,sblock                             ; Load address of source block into RSI
        call    disp_block                             ; Call function to display the source block

        Print   dmsg,dmsg_len                          ; Print the destination block message
        mov     rsi,dblock-2                           ; Load address of destination block into RSI (start at 4th position, overlapped)
        call    disp_block                             ; Call function to display the destination block
	
        call    BT_O                                   ; Call block transfer operation

        Print   amsg,amsg_len                          ; Print the after transfer message

        Print   smsg,smsg_len                          ; Print the source block message again
        mov     rsi,sblock                             ; Load address of source block into RSI
        call    disp_block                             ; Call function to display the source block

        Print   dmsg,dmsg_len                          ; Print the destination block message again
        mov     rsi,dblock-2                           ; Load address of destination block into RSI
        call    disp_block                             ; Call function to display the destination block

        Exit                                           ; Exit the program
;-----------------------------------------------------------------
BT_O:
        mov     rsi,sblock+4                           ; Set RSI to point to the 5th byte of source block (sblock[4])
        mov     rdi,dblock+2                           ; Set RDI to point to the 3rd byte of destination block (dblock[2])
        mov     rcx,5                                   ; Set counter for 5 bytes to transfer

back:   mov     al,[rsi]                                ; Load byte from source block into AL
        mov     [rdi],al                                ; Store byte in destination block
        
        dec     rsi                                     ; Move to the previous byte in source block
        dec     rdi                                     ; Move to the previous byte in destination block

        dec     rcx                                     ; Decrement the byte counter
        jnz     back                                    ; Jump back if counter is not zero
    RET                                                 ; Return from the function
;-----------------------------------------------------------------
disp_block:
        mov     rbp,5                                   ; Set counter for 5 bytes to display

next_num:
        mov     al,[rsi]                                ; Load byte from the source block into AL
        push    rsi                                     ; Save current RSI on the stack

        call    Disp_8                                  ; Call function to display byte in hex
        Print    space,1                                ; Print a space after each byte
        
        pop     rsi                                     ; Restore RSI from stack
        inc     rsi                                     ; Move to the next byte in source block
        
        dec     rbp                                     ; Decrement counter
        jnz     next_num                                ; Jump back if counter is not zero
    RET                                                 ; Return from the function
;---------------------------------------------------------------
Disp_8:
        MOV     RSI,char_ans+1                         ; Prepare buffer for hex output
        MOV     RCX,2                                   ; Set counter for 2 hex digits
        MOV     RBX,16                                  ; Set base for hex (16)

next_digit:
        XOR     RDX,RDX                                 ; Clear RDX for division
        DIV     RBX                                      ; Divide RAX by 16 (RBX); quotient in RAX, remainder in RDX

        CMP     DL,9                                    ; Check if the digit is less than or equal to 9
        JBE     add30                                   ; Jump to add30 if it is (no need to adjust)

        ADD     DL,07H                                  ; Adjust for hex characters A-F

add30:
        ADD     DL,30H                                  ; Convert to ASCII by adding '0'
        MOV     [RSI],DL                                ; Store character in buffer

        DEC     RSI                                     ; Move to the previous position in buffer
        DEC     RCX                                     ; Decrement digit counter
        JNZ     next_digit                              ; Jump back if there are more digits

        Print   char_ans,2                              ; Print the two hex characters
    ret                                                 ; Return from the function
;-------------------------------------------------------------------

