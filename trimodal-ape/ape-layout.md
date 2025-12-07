Notes toward a tri-modal APE/BIOS/UEFI image:
- APE already carries DOS stub + PE header used by Windows loader; we would extend that PE header to satisfy UEFI.
- BIOS path: stage1 boot code jumps into shared payload.
- UEFI path: PE entry does minimal init then jumps to payload address.
- Keep sections aligned to both UEFI and Windows requirements to avoid loader rejection.

This scaffold does not yet emit a true APE/UEFI binary; it compiles a hello ELF placeholder for iterative work.

