# Design Document

## What This Tool Does
Semantic Diff for Compiler IR takes two versions of a C source file,
compiles both to LLVM IR, and reports meaningful optimization-level
changes — not just textual differences.

## Architecture

### Pipeline
v1.c ──► clang -O2 ──► v1.ll ──► normalize ──► v1_norm.ll ──┐
├──► CFG Diff + Classifier ──► Report
v2.c ──► clang -O2 ──► v2.ll ──► normalize ──► v2_norm.ll ──┘

### Components

**1. Compiler (clang)**
We use clang -O2 to compile source files to LLVM IR. O2 is chosen
because it applies real-world optimizations like vectorization,
loop unrolling, and inlining that we want to detect.

**2. Normalizer (src/normalizer.py)**
Raw IR contains noise — debug metadata, source filenames, and
random temp variable names. We strip these so two IR files can
be fairly compared without false differences.

**3. CFG Diff Engine (src/cfg_diff.py)**
We parse the normalized IR into functions and basic blocks, then
compare them structurally. Changes in block count indicate control
flow changes like added branches or loop restructuring.

**4. Change Classifier (src/classifier.py)**
We detect specific optimization changes using pattern matching on
the IR:
- Vector types `<N x iM>` → vectorization
- getelementptr count → loop unrolling
- br instruction count → branch complexity
- icmp count → guard checks
- load count → memory access patterns

**5. CLI Tool (src/semdiff.py)**
Wraps all components into a single command. Accepts either .c or
.ll files as input and produces a human-readable semantic diff report.

## Design Decisions

**Why LLVM IR?**
IR is the compiler's internal representation after parsing and before
code generation. It captures optimization decisions that are invisible
at the source level.

**Why O2?**
O2 is the standard optimization level used in production builds. It
applies enough optimizations to make semantic differences visible
without being too aggressive (O3 can obscure patterns).

**Why regex-based classification?**
A full IR parser would be more accurate but significantly more complex.
Regex pattern matching on key IR constructs gives us 80% of the value
with 20% of the effort — sufficient for detecting the most common
optimization changes.

## Alternatives Considered

**Using llvmlite library:** More accurate IR parsing but heavy dependency
and steeper learning curve. Rejected for simplicity.

**AST-level diff:** Comparing source ASTs instead of IR would miss
compiler optimization decisions entirely. Rejected.

**Dynamic analysis:** Running both programs and comparing behavior would
be more accurate but requires test inputs and is much slower. Rejected.

## Future Improvements
- Type-level change detection (float vs double)
- Interprocedural analysis across multiple files
- Integration with git to automatically diff commits
- HTML report output for better readability
