Good, this is the playground repo, not the bank-grade one. Let’s design it so you actually *finish* artifacts instead of drowning in cleverness.

I’ll structure this as:

1. Purpose and top-level layout of `weird-binaries/`.
2. Shared tooling & conventions (applies to all experiments).
3. Per-project guides:

   * Trimodal APE (OSes + BIOS + UEFI)
   * Single-image cross-ISA (x86-64 ↔ RISC-V)
   * Verified packer stub / PCE / meta-assembler
   * Identity polyglot EXE/ELF + PNG/WAV
   * MOV-subset OS service
   * 1 KB parser
4. A realistic sequencing plan so this doesn’t explode.

---

## 1. What `weird-binaries/` is

**Goal:**
A single repo that collects **finished, demonstrable low-level experiments** that:

* Stress file formats, loaders, ISAs, and proofs.
* Each has:

  * A clear *demo* (scripted or video),
  * A write-up (Markdown),
  * Automated validity checks (e.g. “is this still a valid PNG and still runs?”).

This is **not** production code; it’s:

* “Hire me because I did *this*” portfolio.
* Source material for talks/blogs.
* A personal playground for crazy constraints that would be unsafe/overkill in Clous.

---

## 2. Top-level layout

Something like:

```text
weird-binaries/
  README.md                    # overview + index of experiments
  tools/                       # shared helpers
    disas/                     # disassembly helpers (objdump, radare, etc wrappers)
    format-validators/         # scripts to validate PNG/WAV/ELF/PE
    ct-harness-lite/           # tiny dudect-like harness you can reuse
  trimodal-ape/                # APE + BIOS + UEFI experiment
  cross-isa-same-bytes/        # x86-64 <-> RISC-V minimal program
  verified-packer/             # formally verified packer stub
  pce/                         # proof-carrying executables prototype
  meta-assembler/              # proof-carrying asm peephole engine
  identity-polyglot/           # EXE/ELF + PNG/WAV “identity” files
  mov-os/                      # MOV-subset bootable service
  parser-1kb/                  # 1 KB text parser
  .github/workflows/ci.yml     # run format & execution tests
```

You *don’t* have to fill every directory on day 1. But you want the structure visible so it nudges you to finish discrete experiments.

---

## 3. Shared tooling & conventions

Before individual projects, set some baseline rules.

### 3.1 “Demo completeness” checklist

Every experiment must have:

* `README.md` with:

  * **What** it is (1–2 sentences)
  * **Constraints** (e.g. “same bytes valid as ELF & PNG”)
  * **How to run** (commands, expected output)
  * **How to validate** (format + correctness)
* `Makefile` or `justfile`:

  * `make build`
  * `make test`
  * `make demo` (runs the cool thing)
* `scripts/validate.sh`:

  * Calls format validators (e.g. `file`, `pngcheck`, `ffmpeg -i`, `objdump`, etc).

### 3.2 Tooling stash

In `tools/`:

* Format validators:

  * PNG: `pngcheck`, `identify` (ImageMagick).
  * WAV: basic header checker.
  * ELF/PE: `readelf`, `objdump`, maybe custom Python checks. ([GitHub][1])
* Disassembly helpers:

  * Simple scripts to run objdump/radare with consistent flags.
* A tiny **timing harness** (borrow ideas from dudect) to reuse:

  * Takes a binary and two input generators, outputs t-test stats. ([labs.withsecure.com][2])

The point: each weird project shouldn’t re-solve plumbing.

---

## 4. Per-project guides

### 4.1 Trimodal APE: multi-OS + BIOS + UEFI

**Goal:**
One artifact that:

* Runs as a userland process via **Cosmopolitan/APE** on the usual OS set (Linux, macOS, Windows, *BSD). ([til.simonwillison.net][3])
* Boots via **legacy BIOS**.
* Boots via **UEFI application** path (PE/COFF).

You’re extending what redbean/APE already does (multi-OS + BIOS) by embedding a UEFI path in the same bytes; UEFI support has been a long-standing request in Cosmopolitan issues. ([GitHub][4])

**Subdir:**

```text
trimodal-ape/
  README.md
  src/main.c              # shared C “payload” (framebuffer demo)
  ape-layout.md           # notes on binary layout / headers
  gen_image.py            # script to assemble the final artifact
  tests/run_on_linux.sh
  tests/run_in_bios_qemu.sh
  tests/run_in_uefi_qemu.sh
```

**Phases:**

1. **Baseline APE + BIOS:**

   * Build a standard APE binary that:

     * Prints “hello” on OSes.
     * Boots in BIOS mode (Cosmopolitan already demonstrates this).
   * Put this under test with QEMU.

2. **Understand layout:**

   * Reverse engineer the APE file:

     * Where is the DOS stub/PE header?
     * Where do ELF-like sections live?
   * Write `ape-layout.md` with diagrams (offsets, overlaps).

3. **Add UEFI header:**

   * UEFI looks for a PE/COFF header at the beginning of the image.
   * Trick: reuse/extend the existing PE header (APE already uses PE structure for Windows) so that:

     * OS loader is happy,
     * UEFI firmware sees a valid PE executable.

4. **UEFI entry stub:**

   * Write a small PE entry that:

     * Initializes minimal UEFI environment.
     * Jumps into the same C payload as the OS/BIOS code expects (e.g. a known offset or symbol).
   * Test in QEMU’s OVMF.

5. **Validation:**

   * `make test`:

     * `qemu-system-x86_64 -bios bios.bin` loads artifact as boot disk (BIOS path).
     * `qemu-system-x86_64 -bios OVMF.fd` loads UEFI version.
     * On Linux, just `./trimodal.com` should print something.

**Risks / failure modes:**

* PE header alignment issues break Windows loader.
* UEFI firmware more strict on sections/alignments than Windows.
* Size creep: keep the UEFI stub tiny.

---

### 4.2 Single-image cross-ISA same-bytes: x86-64 ↔ RISC-V

**Goal:**
A minimal program whose **exact byte sequence** is executed as valid instructions by both x86-64 and RV64, doing something observable (e.g. writes `OK\n` to stdout).

**Subdir:**

```text
cross-isa-same-bytes/
  README.md
  src/polyglot.asm         # hand-written mixed-ISA code
  src/build.py             # assembles bytes (or just a .inc file)
  tests/run_x86.sh         # qemu-system-x86_64 flow
  tests/run_rv64.sh        # qemu-system-riscv64 flow
```

**Approach:**

1. **Research decoder quirks:**

   * Find overlapping encodings where:

     * On x86, sequence decodes into sequence A;
     * On RV64, the same bytes decode into sequence B;
     * Both sequences can be made to converge on “write to stdout & exit”.
   * Prior art on polyglot instruction encodings and polyglot binaries gives some hints; you’re pushing to whole-file sameness. ([GitHub][5])

2. **Start with “no headers” baremetal:**

   * Begin with flat binaries executed directly by QEMU in “-kernel” style or minimal boot stub.
   * Avoid OS ABI differences initially; just speak to a known I/O address or trap.

3. **Self-synchronizing layout:**

   * Design a byte layout where:

     * The first few bytes set up registers/stack differently per ISA.
     * Then both decoders fall into a region that coincidentally treats the same bytes as “store ‘O’, store ‘K’, sys_exit”.

4. **Upgrade to OS ABI (stretch goal):**

   * On x86-64 Linux: use `sys_write` / `sys_exit`.
   * On RV64 Linux: matching syscalls (via RISC-V ABI).
   * Map instruction sequences so that both call into correct syscall numbers & registers.

5. **Testing:**

   * `qemu-system-x86_64` and `qemu-system-riscv64` scripts.
   * CI asserts both runs produce the same output.

**Risks:**

* This is highly brittle; tiny changes may break one ISA’s decode.
* Debuggability is awful; heavy use of disassemblers per-ISA (script them).

---

### 4.3 Verified packer stub / PCE / meta-assembler

These are related; don’t tackle all at once. I’d scope them into *three* experiments but share infra.

#### 4.3.1 `verified-packer/`

**Goal:**
A small packer whose decompression stub is **machine-checked equivalent** to “decompress+run original program”, with memory-safety and simple CT properties.

**Subdir:**

```text
verified-packer/
  spec/                # hash of what 'correct decompressor' means
  jasmin/              # or Vale: decompressor implementation + proofs
  stub/                # C/asm version produced
  packer/              # host-side tool to compress ELF segments
  tests/               # equivalence tests original vs packed
  README.md
```

**Flow:**

1. Specify a tiny LZ-like format and semantics.
2. Implement decompressor in **Jasmin/Vale** and prove:

   * No out-of-bounds,
   * CT w.r.t. compressed data.
3. Compile that to assembly.
4. Wrap into an ELF stub that:

   * Allocates memory,
   * Decompresses payload,
   * Jumps to entry.
5. Test on small toy programs; confirm behavior matches exactly.

You’re applying verified crypto tooling to packer territory. ([recon.cx][6])

#### 4.3.2 `pce/` – Proof-Carrying Executables

**Goal:**
Add a `.pceproof` ELF/PE section with a proof that a certain property holds (e.g. no W^X, or no indirect jumps outside a whitelist), plus a tiny verifier that checks it before running.

**Subdir:**

```text
pce/
  spec/pce_format.md
  verifier/            # small C program or loader shim
  examples/            # ELF binaries with embedded proofs
  tools/               # script to attach proofs to ELF
```

Flow:

* Pick one property.
* Choose a proof format (even a tiny custom one).
* Implement a verifier that:

  * Parses ELF,
  * Reads `.pceproof`,
  * Decides ok/fail.
* Provide 1–2 example binaries with proofs.

#### 4.3.3 `meta-assembler/`

**Goal:**
Macro-assembler that applies peephole/e-graph rewrites on assembly and emits **proofs** that optimized code is equivalent to the original.

**Subdir:**

```text
meta-assembler/
  src/
    ir.rs / ir.ml         # internal representation
    rewrites/             # transformations
    proof_export/         # optional proof logs
  examples/
    big_int_add.asm
    matmul_tile.asm
```

Narrow scope:

* Pick one ISA (e.g. AArch64).
* Support a tiny subset of instructions.
* Add a couple of safe rewrites (e.g. algebraic simplifications).
* Emit a trace/proof log a checker can replay.

---

### 4.4 Identity polyglot: EXE/ELF + PNG/WAV

**Goal:**
A file that is:

* A valid **PNG or WAV** media file, validated by existing tools (e.g. `pngcheck`, audio players), **and**
* A valid executable (ELF on Linux or EXE/PE on Windows),
* With the property that when executed, it outputs **exactly the same bytes** as the media representation (identity).

Polyglot file generators like **Mitra** show multi-format files are doable; you’re adding the “identity” constraint. ([GitHub][5])

**Subdir:**

```text
identity-polyglot/
  png-exe/
    gen_polyglot.py
    payload.c
    tests/validate_png.sh
    tests/run_exe.sh
  wav-elf/
    gen_polyglot.py
    payload.c
    tests/validate_wav.sh
    tests/run_elf.sh
  README.md
```

**Approach (PNG+ELF example):**

1. **Learn both formats:**

   * PNG: signature + chunk structure; IDAT location; CRC constraints.
   * ELF: headers + program headers + code segment offsets. ([GitHub][1])

2. **Design shared layout:**

   * Use PNG chunks to hide ELF header/code at known offsets that don’t break PNG decoders.
   * ELF loader ignores PNG-specific parts as data or padding.

3. **Payload program:**

   * When run:

     * Locates its own file on disk (or uses argv[0]),
     * Reads entire file,
     * Writes bytes to stdout (or writes to a new file).
   * That output must be bit-for-bit identical to the PNG data representation.

4. **Generator script:**

   * `gen_polyglot.py`:

     * Takes a base PNG,
     * Inserts ELF headers + compiled payload in safe places,
     * Fixes PNG CRCs,
     * Writes final file.

5. **Validation:**

   * Run `pngcheck` and an image viewer.
   * Run the file as executable; capture stdout; compare to file bytes.

---

### 4.5 MOV-subset OS service

**Goal:**
A bootable image (e.g. BIOS boot sector) where all “actual computation” is under a **MOV-only discipline** (plus minimal unavoidable instructions for entering/exiting). Inspired by M/o/Vfuscator’s “single-instruction compiler” for x86. ([GitHub][7])

**Subdir:**

```text
mov-os/
  bootloader/
    stage1.asm           # 512-byte boot sector, minimal non-mov needed
  mov-core/
    mov_vm.asm           # the mov-only “VM” core
    console_service.c    # compiled with movfuscator
  scripts/
    build_image.sh       # build bootable image
    run_qemu.sh
  README.md
```

**Approach:**

1. **Scope service:**

   * Start with:

     * Text console echo,
     * Maybe a simple “command” that dumps memory.

2. **Bootloader:**

   * Stage1: usual 512-byte boot sector:

     * May need some non-mov instructions to set segments and jump into your MOV-runtime region.
   * After that, all user logic uses only MOV (because generated by Movfuscator).

3. **MOV-runtime:**

   * Reuse M/o/Vfuscator or concept:

     * Compile a C console service to MOV-only code.
     * Link into your boot image.
   * Bootloader just transfers control to start of MOV-coded VM.

4. **Testing:**

   * `qemu-system-x86_64 -hda mov-os.img`.
   * Should show some text, accept minimal keyboard input.

**Risks:**

* Code size: MOVfuscated binaries are huge, may not fit in trivial setups. ([labs.withsecure.com][2])
* Performance: irrelevant here; this is pure art.

---

### 4.6 1 KB parser

**Goal:**
A sub-1 KiB ELF/EXE that parses a simple textual “profile” format and prints a summary. This ties into sizecoding traditions (1K intros), but focused on parsing not graphics. ([sizecoding.org][8])

**Subdir:**

```text
parser-1kb/
  src/parser.asm          # or C with insane -Os / custom linker script
  format.md               # spec of input format
  link.ld                 # custom linker script for tiny ELF
  Makefile
  tests/
    samples/*.txt
    test_parser.sh
  README.md
```

**Input format example:**

```text
name: Alice
role: Engineer
skills: C, Python, Assembly
```

**Output:**

```text
Alice (Engineer) has 3 skills.
```

**Constraints:**

* Total binary size ≤ 1024 bytes (or pick 1024/2048 as limit).
* No external libraries; syscalls only.

**Approach:**

1. **Design minimal grammar.**
2. **Write straight assembly:**

   * Single-pass tokenizer:

     * Recognize “name:”, “role:”, “skills:”.
     * Count commas in skills.
3. **Custom linker script to strip everything:**

   * No dynamic section.
   * Manual entry symbol.
4. **Size-optimization passes:**

   * Replace syscalls with inline int 0x80 / syscall.
   * Use overlapping data/code where safe.

**Testing:**

* `size` on the binary to enforce size.
* Run on various inputs; fuzz small inputs to ensure robustness.

---

## 5. How to sequence this without burning out

You **cannot** do all of these at once. Here’s a sane order that maximizes learning curve:

### Phase 1 – “Toy but shippable”

1. **1 KB parser (`parser-1kb/`)**

   * Builds muscle in binary size control, linkers, and syscalls.
   * Bounded scope: very doable in a week of evenings.

2. **Identity polyglot PNG+ELF (`identity-polyglot/`)**

   * Forces you to understand *two* file formats deeply.
   * Produces a very visible, shareable artifact.

### Phase 2 – “Loader and CPU weirdness”

3. **Trimodal APE (`trimodal-ape/`)**

   * Deepens knowledge of APE/Cosmopolitan and firmware expectations.
4. **MOV-OS (`mov-os/`)**

   * Lets you play with movfuscator & boot paths without huge spec overhead.

### Phase 3 – “ISA and proofs”

5. **Cross-ISA same-bytes (`cross-isa-same-bytes/`)**

   * Great talk material; shows genuine low-level chops.

6. **Verified packer / PCE / meta-assembler**

   * Multi-month PL/verification projects; worth it once you’ve shipped easier artifacts.

---

## 6. Execution discipline

To keep `weird-binaries/` from becoming a graveyard:

* **Rule 1: one experiment at a time.**

  * Don’t open `cross-isa-same-bytes` until `parser-1kb` has:

    * README,
    * a demo script,
    * passing tests.

* **Rule 2: “demo or delete.”**

  * If after N weekends a subproject doesn’t have a real demo, you either:

    * ruthlessly cut scope, or
    * archive it under `archive/` and move on.

* **Rule 3: write the talk outline early.**

  * For each experiment, keep a `notes/talk-outline.md`:

    * problem,
    * constraints,
    * how you solved it,
    * fun failures.
  * That forces clarity of narrative.

---

[1]: https://github.com/corkami/pics/blob/master/binary/README.md?utm_source=chatgpt.com "pics/binary/README.md at master · corkami/pics"
[2]: https://labs.withsecure.com/publications/avrop?utm_source=chatgpt.com "AVRop VM: A ROP based M/o/Vfuscator VM on a Harvard ..."
[3]: https://til.simonwillison.net/cosmopolitan/ecosystem?utm_source=chatgpt.com "Catching up with the Cosmopolitan ecosystem"
[4]: https://github.com/jart/cosmopolitan/issues/12?utm_source=chatgpt.com "Support UEFI · Issue #12 · jart/cosmopolitan"
[5]: https://github.com/corkami/mitra?utm_source=chatgpt.com "corkami/mitra: A generator of weird files (binary polyglots ..."
[6]: https://recon.cx/2015/slides/recon2015-14-christopher-domas-The-movfuscator.pdf?utm_source=chatgpt.com "The MOVfuscator"
[7]: https://github.com/xoreaxeaxeax/movfuscator?utm_source=chatgpt.com "xoreaxeaxeax/movfuscator: The single instruction C compiler"
[8]: https://www.sizecoding.org/wiki/1K_Intro?utm_source=chatgpt.com "1K Intro"
