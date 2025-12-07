CC ?= cc
PY ?= python3
BUILD := build

.PHONY: build test smoke clean

$(BUILD)/verifier: verifier/main.c
	mkdir -p $(BUILD)
	$(CC) -Os -s -o $@ $<

$(BUILD)/example.bin: examples/hello.bin examples/hello.proof tools/embed_proof.py
	mkdir -p $(BUILD)
	$(PY) tools/embed_proof.py examples/hello.bin examples/hello.proof $@

build: $(BUILD)/verifier $(BUILD)/example.bin

test: build
	out="$$( $(BUILD)/verifier $(BUILD)/example.bin )"; \
	if [ "$$out" != "demo-proof" ]; then echo "proof mismatch"; exit 1; fi; \
	echo "pce verifier ok"

smoke:
	@if command -v $(CC) >/dev/null 2>&1 && command -v $(PY) >/dev/null 2>&1; then $(MAKE) test; else echo "skip pce (deps missing)"; fi

clean:
	rm -rf $(BUILD)

