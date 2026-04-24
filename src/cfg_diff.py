import re
import sys

def parse_functions(ll_content):
    functions = {}
    current_func = None
    current_blocks = []
    current_block = []
    current_block_name = None

    for line in ll_content.split('\n'):
        # Detect function start
        func_match = re.match(r'define.*@(\w+)\(', line)
        if func_match:
            current_func = func_match.group(1)
            current_blocks = []
            current_block = []
            current_block_name = 'entry'
            continue

        # Detect function end
        if line.strip() == '}' and current_func:
            if current_block:
                current_blocks.append((current_block_name, current_block))
            functions[current_func] = current_blocks
            current_func = None
            current_blocks = []
            continue

        # Detect basic block label
        block_match = re.match(r'^(\d+):\s*', line)
        if block_match and current_func:
            if current_block:
                current_blocks.append((current_block_name, current_block))
            current_block_name = block_match.group(1)
            current_block = []
            continue

        # Collect instructions
        if current_func and line.strip():
            current_block.append(line.strip())

    return functions

def diff_functions(funcs1, funcs2):
    results = []

    all_funcs = set(list(funcs1.keys()) + list(funcs2.keys()))

    for func in all_funcs:
        if func not in funcs1:
            results.append(f"[ADDED]   Function @{func} is new in v2")
            continue
        if func not in funcs2:
            results.append(f"[REMOVED] Function @{func} was removed in v2")
            continue

        blocks1 = funcs1[func]
        blocks2 = funcs2[func]

        if len(blocks1) != len(blocks2):
            results.append(
                f"[CHANGED] @{func}: basic block count changed "
                f"{len(blocks1)} -> {len(blocks2)}"
            )
        
        instrs1 = sum(len(b[1]) for b in blocks1)
        instrs2 = sum(len(b[1]) for b in blocks2)

        if instrs1 != instrs2:
            results.append(
                f"[CHANGED] @{func}: instruction count changed "
                f"{instrs1} -> {instrs2}"
            )

        if blocks1 == blocks2:
            results.append(f"[SAME]    @{func}: no semantic change detected")

    return results

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 cfg_diff.py v1_norm.ll v2_norm.ll")
        sys.exit(1)

    with open(sys.argv[1]) as f:
        v1 = f.read()
    with open(sys.argv[2]) as f:
        v2 = f.read()

    funcs1 = parse_functions(v1)
    funcs2 = parse_functions(v2)

    print("=== CFG Diff Report ===\n")
    results = diff_functions(funcs1, funcs2)
    for r in results:
        print(r)

if __name__ == '__main__':
    main()