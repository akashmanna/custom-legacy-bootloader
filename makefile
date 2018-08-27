bootloader.img: bootloader.asm
	rm -rf bootloader.img
	nasm -f bin bootloader.asm -o bootloader.img

run: bootloader.img
	qemu-system-x86_64 bootloader.img