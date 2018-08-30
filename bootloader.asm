section .boot
bits 16
global boot
boot:
	mov ax, 0x2401
	int 0x15 								; A20 bit
	mov ax, 0x3
	int 0x10 								; VGA - text mode
	
	mov [disk],dl			; disk number

	mov ah, 0x2    			;read sectors INT 0x13 
	mov al, 6      			;sectors to read
	mov ch, 0      			;cylinder idx
	mov dh, 0      			;head idx
	mov cl, 2      			;sector idx
	mov dl, [disk] 			;disk idx
	mov bx, copy_target		;target pointer
	int 0x13				;INT to read sector

	cli
	lgdt [gdt_pointer]
	mov eax, cr0
	or eax,0x1
	mov cr0, eax
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp CODE_SEG:boot2


;GDT Declarations
;Intel Basic Flat model - has code seg and data seg same 
;Access bit[4] is 1 for code segment, see Intel x86 instructions
gdt_start:
	dq 0x0
gdt_code:
	dw 0xFFFF			; LIMIT - LOW 
	dw 0x0 				; BASE - LOW 
	db 0x0 				; BASE - MID 
	db 10011010b  		; ACCESS BITS
	db 11001111b 		; | FLAGS | LIMIT - HIGH |
	db 0x0 				; BASE - HIGH
gdt_data:
	dw 0xFFFF			; LIMIT - LOW
	dw 0x0 				; BASE - LOW
	db 0x0 				; BASE - MID
	db 10010010b 		; ACCESS BITS
	db 11001111b 		; | FLAGS | LIMIT - HIGH |
	db 0x0 				; BASE - HIGH
gdt_end:
gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

disk:
	db 0x0

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
boot2:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esi,text
	mov ebx,0xb8000 							; VGA Text Buffer addr

.println:
	lodsb
	or al,al
	jz halt
	or eax,0x0400 								; | BG | FG | CHAR | , 0000 - Blk, 0100 - Blue, ... 0F00 - White
	mov word [ebx], ax
	add ebx,2
	jmp .println

halt:
	mov esp,kernel_stack_top
	extern main
	call main
	cli
	hlt

text: db "Protected Mode",0

times 510 - ($-$$) db 0
dw 0xaa55


copy_target:

section .bss
align 4
kernel_stack_bottom: equ $
	resb 16384 ; 16 KB
kernel_stack_top:
