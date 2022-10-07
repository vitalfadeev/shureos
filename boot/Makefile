all: loader image
	echo Making all...
	echo [ OK ]

loader: main.o
	echo Making loader...
	cd bios ; make -s
	echo [ OK ]

image:
	echo Making image...
	cd x-disk-image ; make -s
	echo [ OK ]
	