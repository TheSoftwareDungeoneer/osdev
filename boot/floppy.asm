BITS 16

load_base equ 7c00h

SECTION .text
ORG load_base

vid_int equ 10h

entry:
    cli ; Disable interrupts (CLear Interrupt flag)
    clc ; clear carry
    cld ; clear direction

    xor ax, ax ; ax = 0
    mov ss, ax ; Set the stack segment to 0000
    mov sp, load_base ; Put the stack directly below the code load point

    ; Initialize all other base segments to 0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Print message
    push 0000h
    push hello_size
    push hello_world
    call write_str

    sti ; Enable interrupts (SeT Interrup flag)
shutdown:
    hlt
    jmp shutdown

write_str: ; C: write_str(msg, size, position)
    push bp
    mov bp, sp
    push bx

    mov ax, 1301h
    mov bx, 0007h
    mov cx, [bp + 6] ; load the size into cx
    mov dx, [bp + 8] ; load the position into dx

    push bp ; save bp
    mov bp, [bp + 4] ; load the address of the string into bp
    int vid_int
    pop bp ; restore bp

    pop bx
    mov sp, bp
    pop bp
    ret

    hello_world db "Hello World", 0
    hello_size equ $ - hello_world