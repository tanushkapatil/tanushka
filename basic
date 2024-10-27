section .data
    ano  db  10, "ASSIGNMENT 1" , 10
    ano_len  equ  $-ano
    msg  db  10 , "Hello World" , 10
    msg_len: equ  $-msg

section .text
    global _start

_start:
    mov rax, 1                  ;system call 1 is write
    mov rdi, 1                  ;file handle 1 is STDOUT
    mov rsi, ano                ;"ASSIGNMENT 1"
    mov rdx, ano_len            ;number of bytes
    syscall                     ;invoke operating system to do the write

    mov rax, 1                  ;system call 1 is write
    mov rdi, 1                  ;file handle 1 is STDOUT
    mov rsi, msg                ;address of string to output
    mov rdx, msg_len            ;number of bytes
    syscall                     ;invoke operating system to do the write

    ;exit(0)
    mov rax, 60                 ;system call 60 is exit
    mov rdi, 0                  ;we want return code 0
    syscall                     ;invoke operating system to exit
