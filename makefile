bootloader.bin: bootloader.asm
	rm -rf bootloader.bin
	nasm -f bin bootloader.bin -o bootloader.bin

bootloader.o: bootloader.asm
	nasm bootloader.asm -f elf32  -o bootloader.o

kernel.bin: main.cpp bootloader.o linker.ld
	g++ -m32 main.cpp bootloader.o -o kernel.bin -nostdlib -ffreestanding -std=c++11 -mno-red-zone -fno-exceptions -nostdlib -fno-rtti -Wall -Wextra -Werror -T linker.ld

clean:
	rm -rf bootloader.bin
	rm -rf bootloader.o
	rm -rf kernel.bin

run: kernel.bin
	qemu-system-x86_64 kernel.bin
