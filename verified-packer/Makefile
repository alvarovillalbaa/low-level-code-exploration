CC ?= cc
PY ?= python3
BUILD := build

.PHONY: build test smoke clean

$(BUILD)/decompressor: stub/decompressor.c
	mkdir -p $(BUILD)
	$(CC) -Os -s -o $@ $<

build: $(BUILD)/decompressor

test: build
	tests/equivalence.sh $(BUILD)/decompressor

smoke:
	@if command -v $(CC) >/dev/null 2>&1 && command -v $(PY) >/dev/null 2>&1; then $(MAKE) test; else echo "skip verified-packer (deps missing)"; fi

clean:
	rm -rf $(BUILD)

