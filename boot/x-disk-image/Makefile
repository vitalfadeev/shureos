all: image sector_0
	echo Making disk image...
	echo [ OK ]

image:
	echo Making image...
	rm -f out/c.raw
	bximage -q -func=create -hd=64M -imgmode=flat -sectsize=512 out/c.raw
	echo [ OK ]

sector_0:
	echo Making sector 0...
	dd if=../bios/out/boot-sect-bios.bin of=out/c.raw conv=notrunc
	echo [ OK ]


