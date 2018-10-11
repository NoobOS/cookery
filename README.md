# Noob OS
To build Noob OS we need different sources from remote so read below instructions carefully.

## Build

- Setup environment by double clicking / executing `setup.sh`

- cd into root directory (cookery) and execute `make` from terminal to build noobkernel.bin which can be directly used or further can be used to create CD/DVD image.

- To create CD/DVD iso : `make noobkernel.iso`


## Installation

### Physical Device

- After successful make there will be `noobkernel.bin` in `out` directory.

- Again enter command `make install`. This will copy the noobkernel.bin to `/boot`

- check if makefile really pushed compiled kernel to `/boot` directory by `ls -l /boot`

- open grub configuration file by `sudo vim /boot/grub/grub.cfg` to enter noob kernel to bootloader menu.

- Edit `grub.cfg` and add  noobkernel to menu entry :

```
### BEGIN NOOBKERNEL ###

menuentry 'Noob OS'{
	multiboot /boot/noobkernel.bin
	boot
}

### END NOOBKERNEL ###
```

### Virtual Device

- Required softwares (Installed by `setup` script): `apt install virtualbox virtualbox-qt xorriso grub-coreboot`

- cd into root directory (cookery) and execute `make noobkernel.iso`

- After successful build of CD/DVD iso we can run it in virtualbox. A Screenshot is provided below for demo.

- ![Screenshot](https://image.ibb.co/k4o2eU/Screenshot_from_2018_10_10_17_38_24.png)


- For Quick test : `make run` this will run our iso as a background process.

_Note: I created a virtualbox profile manually named "Noob OS" before doing `make run` therefor `make run` works for me.If you want to quick test like this then build a new machine profile in VM manually once named 'Noob OS'_

## Developers

- [chankruze](https://github.com/chankruze)