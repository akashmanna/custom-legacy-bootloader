
extern "C" void main() {
	const short color = 0x0F00;
	const char* hello = "reading from cpp";
	short* vga = (short*)0xb8000;
	for (int i = 0; i<16;++i)
		vga[i+80] = color | hello[i];
}
