obj-m := hashmod.o
#ccflags-y := -S -O0 -g -fverbose-asm
hashmod-objs += hash.o md5/md5-i386.o sha1/sha1-i386.o xor/xor-i386.o
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
default:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
