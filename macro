section .data
pmsg db 10, "This is my First Program", 10, 10
pmsg_len equ $ - pmsg

%macro Print 2
    mov rax, 1        ; syscall number for sys_write
    mov rdi, 1        ; file descriptor 1 (stdout)
    mov rsi, %1       ; pointer to the message
    mov rdx, %2       ; length of the message
    syscall
%endmacro

%macro Exit 0
    mov rax, 60       ; syscall number for sys_exit
    xor rdi, rdi      ; exit code 0
    syscall
%endmacro

section .text
global _start
_start:
    mov rbx, 10       ; Set loop counter to 10

print_loop:
    Print pmsg, pmsg_len ; Print the message
    dec rbx            ; Decrement the counter
    jnz print_loop     ; Jump to print_loop if counter is not zero

    Exit               ; Exit the program
