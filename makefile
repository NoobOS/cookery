# packages required : sudo apt-get install g++ binutils libc6-dev-i386 virtualbox virtualbox-qt xorriso gnu-coreboot

GCCPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore -Wno-write-strings
ASPARAMS = --32
LDPARAMS = -melf_i386

objects = obj/loader.o \
	  obj/gdt.o \
	  obj/port.o \
	  obj/interruptstubs.o \
	  obj/interrupts.o \
	  obj/kernel.o
setup:
	ruby cook.rb

obj/%.o: kernel/%.cpp
	mkdir -p $(@D)
	gcc $(GCCPARAMS) -c -o $@ $<

obj/%.o: src/%.cpp
	gcc $(GCCPARAMS) -c -o $@ $<

obj/%.o: src/hw/%.cpp
	gcc $(GCCPARAMS) -c -o $@ $<

obj/%.o: src/hw/%.s
	gcc $(GCCPARAMS) -c -o $@ $<

obj/%.o: kernel/%.s
	mkdir -p $(@D)
	as $(ASPARAMS) -o $@ $<

out/noob_kernel.bin: linker.ld $(objects)
	mkdir -p $(@D)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

#make install
install: out/noob_kernel.bin
	sudo cp $< /boot/noob_kernel.bin

# make CD/DVD Image
NoobOS: out/noob_kernel.bin
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp out/noob_kernel.bin iso/boot/noob_kernel.bin
	echo 'set timeout=0'                      > iso/boot/grub/grub.cfg
	echo 'set default=0'                     >> iso/boot/grub/grub.cfg
	echo ''                                  >> iso/boot/grub/grub.cfg
	echo 'menuentry "Noob OS" {'             >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/noob_kernel.bin'  >> iso/boot/grub/grub.cfg
	echo '  boot'                            >> iso/boot/grub/grub.cfg
	echo '}'                                 >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=NoobOS.iso iso
	rm -rf iso
#make run
run: NoobOS.iso
	(killall VirtualBox && sleep 1) || true #Life Hack
	virtualbox --startvm "Noob OS" &

#make clean
.PHONY : clean
clean:
	rm -rf obj\
	       out\
	       *iso


