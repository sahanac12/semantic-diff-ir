#!/bin/bash
echo "=== Semantic Diff IR - Build ==="
echo "Checking dependencies..."

if ! command -v clang &> /dev/null; then
    echo "ERROR: clang not found. Run: sudo apt install clang"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "ERROR: python3 not found. Run: sudo apt install python3"
    exit 1
fi

echo "clang: $(clang --version | head -1)"
echo "python3: $(python3 --version)"
echo "All dependencies satisfied!"
echo "Build complete. Run ./scripts/run.sh to test."
