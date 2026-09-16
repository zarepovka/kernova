ISO_NAME = kernova.iso
BUILD = build
SRC = src
GRUB = boot/grub
KERNEL = $(BUILD)/kernel.bin

all: $(ISO_NAME)

$(KERNEL): src/boot.s src/kernel.c
	@mkdir -p build
	x86_64-elf-gcc -ffreestanding -m32 -c src/boot.s -o build/boot.o
	x86_64-elf-gcc -ffreestanding -m32 -c src/kernel.c -o build/kernel.o
	x86_64-elf-ld -m elf_i386 -Ttext 0x100000 -o build/kernel.bin build/boot.o build/kernel.o --oformat binary

$(ISO_NAME): $(KERNEL)
	@mkdir -p $(BUILD)/iso/boot/grub
	cp $(KERNEL) $(BUILD)/iso/boot/kernel.bin
	cp $(GRUB)/grub.cfg $(BUILD)/iso/boot/grub/
	grub-mkrescue -o $(BUILD)/$(ISO_NAME) $(BUILD)/iso

clean:
	rm -rf $(BUILD)

run:
	qemu-system-x86_64 -cdrom $(BUILD)/$(ISO_NAME)
