section .data
        nline       db      10,10                   ; Define newline characters
        nline_len   equ     $-nline                  ; Calculate length of newline

        space       db      " "                       ; Define a space character

        ano         db      10,"    Assignment no    :4-B",  ; Assignment header
                    db      10,"-------------------------------------------------------------------", 
                    db      10,"    Block Transfer-Overlapped with String instruction.",
                    db      10,"-------------------------------------------------------------------",10
        ano_len     equ     $-ano                     ; Calculate length of assignment header

        bmsg        db      10,"Before Transfer::"    ; Message before data transfer
        bmsg_len    equ     $-bmsg                    ; Length of the before message

        amsg        db      10,"After Transfer::"     ; Message after data transfer
        amsg_len    equ     $-amsg                    ; Length of the after message
        
        smsg        db      10,"    Source Block      :" ; Message for source block
        smsg_len    equ     $-smsg                    ; Length of the source message

        dmsg        db      10,"    Destination Block  :" ; Message for destination block
        dmsg_len    equ     $-dmsg                    ; Length of the destination message

        sblock      db      11h,22h,33h,44h,55h       ; Define source block with hex values
        dblock      times    5   db 0                  ; Reserve space for destination block, initialized to 0
	
;------------------------------------------------------------------------------
section .bss
        char_ans    resB    2                         ; Reserve 2 bytes for character answer
	
;-----------------------------------------------------------------------------

%macro   Print   2                                   ; Macro to print data
        MOV     RAX,1                                   ; Syscall number for write
        MOV     RDI,1                                   ; File descriptor 1 (stdout)
        MOV     RSI,%1                                  ; Pointer to the data to write
        MOV     RDX,%2                                  ; Length of the data
    syscall                                              ; Call the kernel
%endmacro

%macro   Read    2                                   ; Macro to read data (not used in this snippet)
        MOV     RAX,0                                   ; Syscall number for read
        MOV     RDI,0                                   ; File descriptor 0 (stdin)
        MOV     RSI,%1                                  ; Pointer to buffer to store input
        MOV     RDX,%2                                  ; Length of the input buffer
    syscall                                              ; Call the kernel
%endmacro

%macro   Exit    0                                   ; Macro to exit program
        Print   nline,nline_len                        ; Print a newline
        MOV     RAX,60                                  ; Syscall number for exit
        MOV     RDI,0                                   ; Exit status
    syscall                                              ; Call the kernel
%endmacro
;---------------------------------------------------------------       

section .text
        global _start                                   ; Entry point for the program

_start:
        Print   ano,ano_len                            ; Print assignment header

        Print   bmsg,bmsg_len                          ; Print before transfer message

        Print   smsg,smsg_len                          ; Print source block message
        mov     rsi,sblock                             ; Load address of source block into rsi
        call    disp_block                             ; Call function to display source block

        Print   dmsg,dmsg_len                          ; Print destination block message
        mov     rsi,dblock-2                           ; Load address of destination block into rsi
        call    disp_block                             ; Call function to display destination block
	
        call    BT_OS                                  ; Call block transfer operation

        Print   amsg,amsg_len                          ; Print after transfer message

        Print   smsg,smsg_len                          ; Print source block message again
        mov     rsi,sblock                             ; Load address of source block into rsi
        call    disp_block                             ; Call function to display source block

        Print   dmsg,dmsg_len                          ; Print destination block message again
        mov     rsi,dblock-2                           ; Load address of destination block into rsi
        call    disp_block                             ; Call function to display destination block

        Exit                                           ; Exit program
;-----------------------------------------------------------------
BT_OS:
        mov     rsi,sblock+4                           ; Set rsi to point to the 5th byte of source block
        mov     rdi,dblock+2                           ; Set rdi to point to the 3rd byte of destination block
        mov     rcx,5                                   ; Set counter for 5 bytes to transfer

        STD                                             ; Set direction flag for decreasing address
        REP MOVSB                                       ; Repeat move string byte: move byte from [rsi] to [rdi]
                                                        ; and decrement rcx until it reaches zero

    RET                                                 ; Return from the function
;-----------------------------------------------------------------
disp_block:
        mov     rbp,5                                   ; Set counter for 5 bytes to display

next_num:
        mov     al,[rsi]                                ; Load byte from the source block into al
        push    rsi                                     ; Save rsi on stack

        call    Disp_8                                  ; Call function to display byte in hex
        Print    space,1                                ; Print a space after each byte
        
        pop     rsi                                     ; Restore rsi from stack
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

