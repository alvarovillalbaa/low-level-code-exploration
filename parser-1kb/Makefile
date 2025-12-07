CC ?= cc
CFLAGS := -Os -s -fdata-sections -ffunction-sections
BUILD := build

.PHONY: build test smoke clean

$(BUILD)/parser: src/parser.c link.ld
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -o $@ $<

build: $(BUILD)/parser

test: build
	./tests/test_parser.sh

smoke:
	@if command -v $(CC) >/dev/null 2>&1; then $(MAKE) test; else echo "compiler missing, skip"; fi

clean:
	rm -rf $(BUILD)

