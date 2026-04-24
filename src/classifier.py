import re
import sys

def load_ll(path):
    with open(path) as f:
        return f.read()

def check_vectorization(v1, v2):
    vec1 = len(re.findall(r'<\d+ x i\d+>', v1))
    vec2 = len(re.findall(r'<\d+ x i\d+>', v2))
    if vec1 > vec2:
        return f"[LOST]    Vectorization — vector ops reduced {vec1} -> {vec2}"
    elif vec2 > vec1:
        return f"[GAINED]  Vectorization — vector ops increased {vec1} -> {vec2}"
    return None

def check_unrolling(v1, v2):
    # Unrolled loops have more getelementptr instructions
    gep1 = len(re.findall(r'getelementptr', v1))
    gep2 = len(re.findall(r'getelementptr', v2))
    if gep1 > gep2:
        return f"[LOST]    Loop unrolling — GEP count reduced {gep1} -> {gep2}"
    elif gep2 > gep1:
        return f"[GAINED]  Loop unrolling — GEP count increased {gep1} -> {gep2}"
    return None

def check_inlining(v1, v2):
    # If a function call disappears, it was inlined
    calls1 = set(re.findall(r'call.*@(\w+)\(', v1))
    calls2 = set(re.findall(r'call.*@(\w+)\(', v2))
    inlined = calls1 - calls2
    lost = calls2 - calls1
    results = []
    for f in inlined:
        results.append(f"[GAINED]  Inlining — @{f} was inlined in v2")
    for f in lost:
        results.append(f"[LOST]    Inlining — @{f} call added back in v2")
    return results

def check_branch_complexity(v1, v2):
    br1 = len(re.findall(r'\bbr\b', v1))
    br2 = len(re.findall(r'\bbr\b', v2))
    if br2 > br1:
        return f"[ADDED]   Branch complexity increased {br1} -> {br2} branches"
    elif br1 > br2:
        return f"[REDUCED] Branch complexity decreased {br1} -> {br2} branches"
    return None

def check_bounds_check(v1, v2):
    icmp1 = len(re.findall(r'icmp', v1))
    icmp2 = len(re.findall(r'icmp', v2))
    if icmp2 > icmp1:
        return f"[ADDED]   Bounds/guard checks increased {icmp1} -> {icmp2} comparisons"
    return None

def check_memory_ops(v1, v2):
    load1 = len(re.findall(r'\bload\b', v1))
    load2 = len(re.findall(r'\bload\b', v2))
    if load1 != load2:
        return f"[CHANGED] Memory loads changed {load1} -> {load2}"
    return None

def classify(v1_path, v2_path):
    v1 = load_ll(v1_path)
    v2 = load_ll(v2_path)

    print("=== Semantic Change Classifier ===\n")

    checks = [
        check_vectorization(v1, v2),
        check_unrolling(v1, v2),
        check_branch_complexity(v1, v2),
        check_bounds_check(v1, v2),
        check_memory_ops(v1, v2),
    ]

    found = False
    for result in checks:
        if result:
            print(result)
            found = True

    # Inlining returns a list
    inline_results = check_inlining(v1, v2)
    for r in inline_results:
        print(r)
        found = True

    if not found:
        print("[SAME]    No significant semantic changes detected")

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python3 classifier.py v1_norm.ll v2_norm.ll")
        import sys; sys.exit(1)
    classify(sys.argv[1], sys.argv[2])