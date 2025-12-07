PY ?= python3
CC ?= cc
BUILD := build

.PHONY: build test smoke clean

build: $(BUILD)/png-exe/polyglot.png $(BUILD)/wav-elf/polyglot.wav $(BUILD)/png-exe/payload $(BUILD)/wav-elf/payload

$(BUILD)/png-exe/polyglot.png: png-exe/gen_polyglot.py
	mkdir -p $(BUILD)/png-exe
	$(PY) $< $@

$(BUILD)/wav-elf/polyglot.wav: wav-elf/gen_polyglot.py
	mkdir -p $(BUILD)/wav-elf
	$(PY) $< $@

$(BUILD)/png-exe/payload: png-exe/payload.c
	mkdir -p $(BUILD)/png-exe
	$(CC) -Os -s -o $@ $<

$(BUILD)/wav-elf/payload: wav-elf/payload.c
	mkdir -p $(BUILD)/wav-elf
	$(CC) -Os -s -o $@ $<

test: build
	png-exe/tests/validate_png.sh $(BUILD)/png-exe/polyglot.png $(BUILD)/png-exe/payload
	wav-elf/tests/validate_wav.sh $(BUILD)/wav-elf/polyglot.wav $(BUILD)/wav-elf/payload

smoke:
	@if command -v $(PY) >/dev/null 2>&1 && command -v $(CC) >/dev/null 2>&1; then $(MAKE) test; else echo "skip identity-polyglot (deps missing)"; fi

clean:
	rm -rf $(BUILD)

