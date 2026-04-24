import sys
import os
import subprocess
import re

def compile_to_ir(c_file, out_ll):
    result = subprocess.run(
        ['clang', '-O2', '-emit-llvm', '-S', c_file, '-o', out_ll],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"Error compiling {c_file}:\n{result.stderr}")
        sys.exit(1)

def normalize_ir(content):
    lines = content.split('\n')
    normalized = []
    for line in lines:
        if line.strip().startswith('!'):
            continue
        line = re.sub(r',\s*!dbg\s+!\d+', '', line)
        line = re.sub(r',\s*!tbaa\s+!\d+', '', line)
        line = re.sub(r',\s*!llvm\.loop\s+!\d+', '', line)
        if line.strip().startswith('source_filename'):
            continue
        if line.strip().startswith('; ModuleID'):
            continue
        normalized.append(line)
    return '\n'.join(normalized)

def parse_functions(ll_content):
    functions = {}
    current_func = None
    current_blocks = []
    current_block = []
    current_block_name = None
    for line in ll_content.split('\n'):
        func_match = re.match(r'define.*@(\w+)\(', line)
        if func_match:
            current_func = func_match.group(1)
            current_blocks = []
            current_block = []
            current_block_name = 'entry'
            continue
        if line.strip() == '}' and current_func:
            if current_block:
                current_blocks.append((current_block_name, current_block))
            functions[current_func] = current_blocks
            current_func = None
            current_blocks = []
            continue
        block_match = re.match(r'^(\d+):\s*', line)
        if block_match and current_func:
            if current_block:
                current_blocks.append((current_block_name, current_block))
            current_block_name = block_match.group(1)
            current_block = []
            continue
        if current_func and line.strip():
            current_block.append(line.strip())
    return functions

def classify(v1, v2):
    results = []

    vec1 = len(re.findall(r'<\d+ x i\d+>', v1))
    vec2 = len(re.findall(r'<\d+ x i\d+>', v2))
    if vec1 > vec2:
        results.append(f"[LOST]    Vectorization — vector ops {vec1} -> {vec2}")
    elif vec2 > vec1:
        results.append(f"[GAINED]  Vectorization — vector ops {vec1} -> {vec2}")

    gep1 = len(re.findall(r'getelementptr', v1))
    gep2 = len(re.findall(r'getelementptr', v2))
    if gep1 > gep2:
        results.append(f"[LOST]    Loop unrolling — GEP count {gep1} -> {gep2}")
    elif gep2 > gep1:
        results.append(f"[GAINED]  Loop unrolling — GEP count {gep1} -> {gep2}")

    br1 = len(re.findall(r'\bbr\b', v1))
    br2 = len(re.findall(r'\bbr\b', v2))
    if br2 > br1:
        results.append(f"[ADDED]   Branch complexity {br1} -> {br2} branches")

    icmp1 = len(re.findall(r'icmp', v1))
    icmp2 = len(re.findall(r'icmp', v2))
    if icmp2 > icmp1:
        results.append(f"[ADDED]   Guard checks {icmp1} -> {icmp2} comparisons")

    load1 = len(re.findall(r'\bload\b', v1))
    load2 = len(re.findall(r'\bload\b', v2))
    if load1 != load2:
        results.append(f"[CHANGED] Memory loads {load1} -> {load2}")

    return results

def cfg_diff(funcs1, funcs2):
    results = []
    all_funcs = set(list(funcs1.keys()) + list(funcs2.keys()))
    for func in all_funcs:
        if func not in funcs1:
            results.append(f"[ADDED]   Function @{func} is new in v2")
        elif func not in funcs2:
            results.append(f"[REMOVED] Function @{func} removed in v2")
        else:
            b1, b2 = len(funcs1[func]), len(funcs2[func])
            if b1 != b2:
                results.append(f"[CHANGED] @{func}: blocks {b1} -> {b2}")
    return results

def main():
    if len(sys.argv) < 3:
        print("Usage: python3 semdiff.py file1.c file2.c")
        print("   or: python3 semdiff.py file1.ll file2.ll --ir")
        sys.exit(1)

    f1, f2 = sys.argv[1], sys.argv[2]
    use_ir = '--ir' in sys.argv

    if use_ir:
        ll1_path, ll2_path = f1, f2
    else:
        ll1_path = f1.replace('.c', '_tmp.ll')
        ll2_path = f2.replace('.c', '_tmp.ll')
        print(f"Compiling {f1} -> {ll1_path}")
        compile_to_ir(f1, ll1_path)
        print(f"Compiling {f2} -> {ll2_path}")
        compile_to_ir(f2, ll2_path)

    with open(ll1_path) as f:
        raw1 = f.read()
    with open(ll2_path) as f:
        raw2 = f.read()

    v1 = normalize_ir(raw1)
    v2 = normalize_ir(raw2)

    funcs1 = parse_functions(v1)
    funcs2 = parse_functions(v2)

    print("\n" + "="*45)
    print("   SEMANTIC DIFF REPORT")
    print("="*45)
    print(f"  v1: {f1}")
    print(f"  v2: {f2}")
    print("="*45 + "\n")

    print("--- CFG Changes ---")
    cfg_results = cfg_diff(funcs1, funcs2)
    for r in cfg_results:
        print(r)

    print("\n--- Optimization Changes ---")
    opt_results = classify(v1, v2)
    for r in opt_results:
        print(r)

    if not cfg_results and not opt_results:
        print("[SAME] No semantic changes detected")

    print("\n" + "="*45)

if __name__ == '__main__':
    main()