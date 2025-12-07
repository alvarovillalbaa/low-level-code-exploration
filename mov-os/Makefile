PY ?= python3
BUILD := build

.PHONY: build test smoke clean

build: $(BUILD)/mov-os.img

$(BUILD)/mov-os.img: scripts/build_image.sh bootloader/stage1.asm mov-core/mov_vm.asm mov-core/console_service.c
	mkdir -p $(BUILD)
	$(PY) scripts/build_image.sh $@

test: build
	scripts/run_qemu.sh $(BUILD)/mov-os.img

smoke:
	@if command -v $(PY) >/dev/null 2>&1; then $(MAKE) test; else echo "skip mov-os (python missing)"; fi

clean:
	rm -rf $(BUILD)

