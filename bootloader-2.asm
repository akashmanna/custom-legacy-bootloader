; A boot sector that boots a C kernel in 32 - bit protected mode
[ org 0 x7c00 ]
KERNEL_OFFSET equ 0 x1000 ; This is the memory offset to which we will load our kernel
mov [ BOOT_DRIVE ] , dl ; BIOS stores our boot drive in DL , so it ’s
; best to remember this for later.
mov bp , 0 x9000
mov sp , bp
; Set - up the stack.
mov bx , MSG_REAL_MODE ; Announce that we are starting
call print_string
; booting from 16 - bit real mode
call load_kernel ; Load our kernel
call switch_to_pm ; Switch to protected mode , from which
; we will not return
jmp $
; Include our useful , hard - earned routines
% include " print / p r i n t_ s t r i n g . a s m "
% include " disk / disk_load.asm "
% include " pm / gdt.asm "
% include " pm / p r i n t _ s t r i n g _ p m . a s m "
% include " pm / s w i t c h _ t o _ p m . a sm "
[ bits 16]
; load_kernel
load_kernel :
mov bx , M SG _ LO AD _K E RN EL
call print_string
mov bx , KERNEL_OFFSET
mov dh , 15
mov dl , [ BOOT_DRIVE ]
call disk_load
; Print a message to say we are loading the kernel
; Set - up parameters for our disk_load routine , so
; that we load the first 15 sectors ( excluding
; the boot sector ) from the boot disk ( i.e. our
; kernel code ) to address KERNEL_OFFSET
ret
[ bits 32]
; This is where we arrive after switching to and initialising protected mode.