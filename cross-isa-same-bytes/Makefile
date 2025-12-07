PY ?= python3
BUILD := build

.PHONY: build test smoke clean

build: $(BUILD)/polyglot.bin

$(BUILD)/polyglot.bin: src/build.py src/polyglot.asm
	mkdir -p $(BUILD)
	$(PY) src/build.py $@

test: build
	tests/run_x86.sh $(BUILD)/polyglot.bin
	tests/run_rv64.sh $(BUILD)/polyglot.bin

smoke:
	@if command -v $(PY) >/dev/null 2>&1; then $(MAKE) test; else echo "skip cross-isa-same-bytes (python missing)"; fi

clean:
	rm -rf $(BUILD)

