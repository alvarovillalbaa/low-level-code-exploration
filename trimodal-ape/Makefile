CC ?= cc
CFLAGS := -Os -s
BUILD := build

.PHONY: build test smoke clean

$(BUILD)/trimodal.com: src/main.c
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -o $@ $<

build: $(BUILD)/trimodal.com

test: build
	./tests/run_on_linux.sh $(BUILD)/trimodal.com
	./tests/run_in_bios_qemu.sh $(BUILD)/trimodal.com
	./tests/run_in_uefi_qemu.sh $(BUILD)/trimodal.com

smoke:
	@if command -v $(CC) >/dev/null 2>&1; then $(MAKE) test; else echo "skip trimodal-ape (compiler missing)"; fi

clean:
	rm -rf $(BUILD)

