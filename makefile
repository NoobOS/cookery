# packages required : sudo apt-get install g++ binutils libc6-dev-i386 virtualbox virtualbox-qt xorriso gnu-coreboot

GCCPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore -Wno-write-strings
ASPARAMS = --32
LDPARAMS = -melf_i386

objects = obj/loader.o \
	  obj/gdt.o \
	  obj/kernel.o

obj/%.o: kernel/%.cpp
	mkdir -p $(@D)
	gcc $(GCCPARAMS) -c -o $@ $<

obj/%.o: src/%.cpp
	gcc $(GCCPARAMS) -c -o $@ $<

obj/%.o: kernel/%.s
	mkdir -p $(@D)
	as $(ASPARAMS) -o $@ $<

out/noobkernel.bin: linker.ld $(objects)
	mkdir -p $(@D)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

#make install
install: out/noobkernel.bin
	sudo cp $< /boot/noobkernel.bin

# make noobkernel.iso
noobkernel.iso: out/noobkernel.bin
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp out/noobkernel.bin iso/boot/noobkernel.bin
	echo 'set timeout=0'                      > iso/boot/grub/grub.cfg
	echo 'set default=0'                     >> iso/boot/grub/grub.cfg
	echo ''                                  >> iso/boot/grub/grub.cfg
	echo 'menuentry "Noob OS" {'             >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/noobkernel.bin'  >> iso/boot/grub/grub.cfg
	echo '  boot'                            >> iso/boot/grub/grub.cfg
	echo '}'                                 >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=noobkernel.iso iso
	rm -rf iso
#make run
run: noobkernel.iso
	(killall VirtualBox && sleep 1) || true #Life Hack
	virtualbox --startvm "Noob OS" &



