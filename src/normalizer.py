import re
import sys

def normalize_ir(content):
    lines = content.split('\n')
    normalized = []
    
    for line in lines:
        # Remove metadata lines (start with !)
        if line.strip().startswith('!'):
            continue
        # Remove debug metadata references
        line = re.sub(r',\s*!dbg\s+!\d+', '', line)
        line = re.sub(r',\s*!tbaa\s+!\d+', '', line)
        line = re.sub(r',\s*!llvm\.loop\s+!\d+', '', line)
        # Remove source filename (differs between versions)
        if line.strip().startswith('source_filename'):
            continue
        # Remove ModuleID (differs between versions)
        if line.strip().startswith('; ModuleID'):
            continue
        normalized.append(line)
    
    return '\n'.join(normalized)

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 normalizer.py v1.ll v2.ll")
        sys.exit(1)
    
    with open(sys.argv[1]) as f:
        v1 = normalize_ir(f.read())
    with open(sys.argv[2]) as f:
        v2 = normalize_ir(f.read())
    
    with open(sys.argv[1].replace('.ll', '_norm.ll'), 'w') as f:
        f.write(v1)
    with open(sys.argv[2].replace('.ll', '_norm.ll'), 'w') as f:
        f.write(v2)
    
    print("Normalized IR written!")
    print(f"  {sys.argv[1].replace('.ll', '_norm.ll')}")
    print(f"  {sys.argv[2].replace('.ll', '_norm.ll')}")

if __name__ == '__main__':
    main()