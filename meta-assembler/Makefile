PY ?= python3
BUILD := build

.PHONY: build test smoke clean

build: $(BUILD)/simple.out $(BUILD)/simple.log

$(BUILD)/simple.out $(BUILD)/simple.log: src/meta.py src/rewrites/simple.py src/proof_export/logger.py examples/simple.asm
	mkdir -p $(BUILD)
	$(PY) src/meta.py examples/simple.asm $(BUILD)/simple.out $(BUILD)/simple.log

test: build
	grep -q "rewrite: drop add #0" $(BUILD)/simple.log
	grep -q "rewrite: mov -> alias" $(BUILD)/simple.log
	echo "meta-assembler rewrites ok"

smoke:
	@if command -v $(PY) >/dev/null 2>&1; then $(MAKE) test; else echo "skip meta-assembler (python missing)"; fi

clean:
	rm -rf $(BUILD)

