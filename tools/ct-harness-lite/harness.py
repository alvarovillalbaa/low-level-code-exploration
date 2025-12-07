#!/usr/bin/env python3
"""
Tiny timing harness: runs a target binary multiple times with two input files.
Collects coarse runtimes; not a real t-test.
"""
import subprocess, statistics, time, sys, pathlib

def run_once(bin_path, arg):
    start = time.perf_counter_ns()
    subprocess.run([bin_path, arg], check=True, stdout=subprocess.DEVNULL)
    return time.perf_counter_ns() - start

def main():
    if len(sys.argv) < 4:
        print("usage: harness.py binary input_a input_b [runs]", file=sys.stderr)
        sys.exit(1)
    bin_path = sys.argv[1]
    a, b = sys.argv[2], sys.argv[3]
    runs = int(sys.argv[4]) if len(sys.argv) > 4 else 10
    for p in (bin_path, a, b):
        if not pathlib.Path(p).exists():
            print(f"missing {p}", file=sys.stderr)
            sys.exit(1)
    def measure(arg):
        return [run_once(bin_path, arg) for _ in range(runs)]
    a_times, b_times = measure(a), measure(b)
    print(f"A median ns: {statistics.median(a_times)}")
    print(f"B median ns: {statistics.median(b_times)}")

if __name__ == "__main__":
    main()

