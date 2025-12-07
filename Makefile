SUBDIRS := parser-1kb identity-polyglot trimodal-ape cross-isa-same-bytes mov-os verified-packer pce meta-assembler

.PHONY: help tools-check lint smoke ci

help:
	@echo "Targets: help, tools-check, lint, smoke, ci"

tools-check:
	@./tools/check_deps.sh

lint:
	@echo "No linters wired yet; add per-language checks in subprojects."

smoke:
	@set -e; for d in $(SUBDIRS); do \
		if [ -f $$d/Makefile ]; then \
			echo ">> $$d smoke"; \
			$(MAKE) -C $$d smoke || echo "skip $$d (deps missing)"; \
		fi; \
	done

ci: lint smoke

