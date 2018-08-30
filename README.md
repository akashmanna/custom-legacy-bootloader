# custom-legacy-bootloader  
bootloader program for BIOS (legacy) written in x86 assembly  

#dependencies  
nasm (to compile asm)  
qemu (simulator for x86_64 system)  

#Usage:    

1. Generating bootloader binary file  
make bootloader.bin  

2. Running binary using qemu  
make run  