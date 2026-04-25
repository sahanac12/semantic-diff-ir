#!/bin/bash
echo "=== Semantic Diff IR - Demo Run ==="

if [ "$#" -eq 2 ]; then
    python3 src/semdiff.py "$1" "$2"
else
    echo "Running on default test cases..."
    echo ""
    echo "--- Test Case 1: Known vs Unknown Loop Bound ---"
    python3 src/semdiff.py testcases/v1.c testcases/v2.c
    echo ""
    echo "--- Test Case 2: Conditional Inside Loop ---"
    python3 src/semdiff.py testcases/tc2_v1.c testcases/tc2_v2.c
    echo ""
    echo "--- Test Case 5: Loop Stride Change ---"
    python3 src/semdiff.py testcases/tc5_v1.c testcases/tc5_v2.c
    echo ""
    echo "Done! Run with: ./scripts/run.sh file1.c file2.c"
fi
