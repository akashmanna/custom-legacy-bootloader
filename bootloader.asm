bits 16
org 0x7c00

jmp main  

msgA db "Hello World!", 0x0 
msgB db "Welcome to custom Bootloader", 0x0
AnyKey db "Press any key to reboot...", 0x0 

printf:
    lodsb 
    or al, al
    jz complete
    mov ah, 0x0e 	
    int 0x10  
    jmp printf  	
complete:
    call printEndl
 	
printEndl: 
    mov al, 0	
    stosb       
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10      ;\r
    mov al, 0x0A 
    int 0x10      ;\n
	ret
 
Reboot: 
    mov si, AnyKey
    call printf
    call GetPressedKey 
 
GetPressedKey:
    mov ah, 0
    int 0x16 
    ret 

main:
   mov si, msgA 
   call printf 

   mov si, msgB
   call printf 

   call printEndl

   call Reboot 

   times 510 - ($-$$) db 0
   dw 0xAA55 ;magic number
