;when source and destination memory location are different : non-overlapping
;1 digit = 4bit
;db = 8 bit so 2 digits
;dw = 16 bits so 4 digits
section .data
    nline       db      10,10                        ; Defines two newline characters (ASCII 10)
    nline_len   equ     $-nline                       ; Calculate the length of the newline

    space       db      " "                            ; Define a space character

    ano         db      10,"    Assignment no    :3-A",  ; Assignment header
                db      10,"-------------------------------------------------------------------",
                db      10,"    Block Transfer-Non overlapped without String instruction.",
                db      10,"-------------------------------------------------------------------",10
    ano_len     equ     $-ano                          ; Calculate the length of the assignment header

    bmsg        db      10,"Before Transfer::"        ; Message indicating the state before transfer
    bmsg_len    equ     $-bmsg                         ; Length of the before transfer message

    amsg        db      10,"After Transfer::"         ; Message indicating the state after transfer
    amsg_len    equ     $-amsg                         ; Length of the after transfer message
    
    smsg        db      10,"Source Block :"            ; Message for the source block
    smsg_len    equ     $-smsg                         ; Length of the source message

    dmsg        db      10,"Destination Block :"       ; Message for the destination block
    dmsg_len    equ     $-dmsg                         ; Length of the destination message

    sblock      db      11h,22h,33h,44h,55h            ; Define the source block with hex values
    dblock      times    5   db 0                       ; Reserve space for the destination block, initialized to 0

;------------------------------------------------------------------------------
section .bss
    char_ans    resB    2                             ; Reserve 2 bytes for a buffer to hold hexadecimal numbers

;-----------------------------------------------------------------------------

%macro   Print   2                                   ; Macro to print data
    MOV     RAX,1                                       ; Set syscall number for write (1)
    MOV     RDI,1                                       ; Set file descriptor to stdout (1)
    MOV     RSI,%1                                      ; Load pointer to data to print into RSI
    MOV     RDX,%2                                      ; Load length of data to print into RDX
    syscall                                              ; Make the syscall
%endmacro

%macro   Read    2                                   ; Macro to read data (not used in this snippet)
    MOV     RAX,0                                       ; Set syscall number for read (0)
    MOV     RDI, 0                                     ; Set file descriptor to stdin (0)
    MOV     RSI, %1                                    ; Load pointer to buffer where input will be stored
    MOV     RDX, %2                                    ; Load number of bytes to read
    syscall                                              ; Make the syscall
%endmacro

%macro   Exit    0                                   ; Macro to exit the program
    Print   nline,nline_len                            ; Print a newline before exiting
    MOV     RAX,60                                      ; Set syscall number for exit (60)
    MOV     RDI,0                                       ; Set exit status to 0
    syscall                                              ; Make the syscall
%endmacro
;---------------------------------------------------------------       

section .text
    global _start                                       ; Define entry point for the program

_start:
    Print   ano,ano_len                                ; Print the assignment header

    Print   bmsg,bmsg_len                              ; Print the before transfer message

    Print   smsg,smsg_len                              ; Print the source block message
    mov     rsi,sblock                                 ; Load address of source block into RSI
    call    disp_block                                 ; Display the source block

    Print   dmsg,dmsg_len                              ; Print the destination block message
    mov     rsi,dblock                                 ; Load address of destination block into RSI
    call    disp_block                                 ; Display the destination block
    
    call    BT_NO                                      ; Perform the actual block transfer

    Print   amsg,amsg_len                              ; Print the after transfer message

    Print   smsg,smsg_len                              ; Print the source block message again
    mov     rsi,sblock                                 ; Load address of source block into RSI
    call    disp_block                                 ; Display the source block

    Print   dmsg,dmsg_len                              ; Print the destination block message again
    mov     rsi,dblock                                 ; Load address of destination block into RSI
    call    disp_block                                 ; Display the destination block

    Exit                                               ; Exit the program
;-----------------------------------------------------------------
BT_NO:
    mov     rsi,sblock                                 ; Set RSI to point to the start of the source block
    mov     rdi,dblock                                 ; Set RDI to point to the start of the destination block
    mov     rcx,5                                      ; Set counter for 5 bytes to transfer

back:   
    mov     al, [rsi]                                  ; Load byte from source into AL
    mov     [rdi], al                                  ; Store byte into destination
    inc     rsi                                        ; Move to the next byte in the source
    inc     rdi                                        ; Move to the next byte in the destination
    dec     rcx                                        ; Decrement the counter
    jnz     back                                       ; Repeat if there are more bytes to copy
RET
;-----------------------------------------------------------------
disp_block:
    mov     rbp, 5                                     ; Set the counter to 5 (number of bytes)
next_num:
    mov     al, [rsi]                                  ; Load byte from block into AL
    push    rsi                                         ; Save RSI since it will be modified in Disp_8
    call    Disp_8                                      ; Convert byte to hex and print
    Print   space, 1                                   ; Print space between bytes
    pop     rsi                                        ; Restore RSI
    inc     rsi                                        ; Move to next byte
    dec     rbp                                        ; Decrement counter
    jnz     next_num                                   ; Repeat until 5 bytes are printed
RET

;---------------------------------------------------------------
Disp_8:
    MOV     RSI, char_ans+1                           ; Prepare buffer for hex output
    MOV     RCX, 2                                     ; Set counter for 2 hex digits
    MOV     RBX, 16                                    ; Set base for hex (16)

next_digit:
    XOR     RDX, RDX                                   ; Clear RDX for division
    DIV     RBX                                         ; Divide AL by 16 to extract hexadecimal digits
    CMP     DL, 9                                      ; Check if the digit is less than or equal to 9
    JBE     add30                                     ; Jump to add30 if it is (no need to adjust)
    ADD     DL, 07H                                    ; Adjust for hex characters A-F

add30:
    ADD     DL, 30H                                    ; Convert to ASCII by adding '0'
    MOV     [RSI], DL                                  ; Store character in buffer
    DEC     RSI                                        ; Move to the previous position in buffer
    DEC     RCX                                        ; Decrement digit counter
    JNZ     next_digit                                  ; Jump back if there are more digits
    Print   char_ans, 2                                ; Print the two hex characters
    ret                                                 ; Return from the function
;-------------------------------------------------------------------
