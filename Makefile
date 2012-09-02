TARGET = ViewSource.dylib

CC = gcc
LD = $(CC)
CFLAGS = -isysroot /var/mobile/sysroot \
	 -Wall \
	 -DTARGET_OS_IPHONE=1 \
	 -c
LDFLAGS = -isysroot /var/mobile/sysroot \
	  -w \
	  -dynamiclib \
	  -lobjc \
	  -lsubstrate \
	  -framework CoreFoundation \
	  -framework Foundation \
	  -framework CoreGraphics \
	  -framework UIKit

OBJECTS = $(patsubst %.m, %.o, $(wildcard *.m))

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $^
	sudo cp $(TARGET) /Library/MobileSubstrate/DynamicLibraries

%.o: %.m
	$(CC) $(CFLAGS) -o $@ $<

