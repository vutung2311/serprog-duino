CC=avr-gcc
CFLAGS=-Wall -Os -DF_CPU=$(F_CPU) -mmcu=$(MCU)
MCU=atmega328p
F_CPU=16000000L

OBJCOPY=avr-objcopy
BIN_FORMAT=ihex

PORT=/dev/ttyACM0
BAUD=115200
PROTOCOL=stk500v1
PART=$(MCU)
AVRDUDE=avrdude -F -V

AVRSIZE=avr-size -C --mcu=$(MCU)

RM=rm -f

.PHONY: all
all: size

serprog.hex: serprog.elf

serprog.elf: serprog.s

serprog.s: serprog.c

.PHONY: clean
clean:
	$(RM) serprog.elf serprog.hex serprog.s

.PHONY: upload
upload: serprog.hex
	$(AVRDUDE) -c $(PROTOCOL) -p $(PART) -P $(PORT) -b $(BAUD) -U flash:w:$<

.PHONY: size
size: serprog.elf
	$(AVRSIZE) $<

%.elf: %.s ; $(CC) $(CFLAGS) -s -o $@ $<

%.s: %.c ; $(CC) $(CFLAGS) -S -o $@ $<

%.hex: %.elf ; $(OBJCOPY) -O $(BIN_FORMAT) -R .eeprom $< $@
