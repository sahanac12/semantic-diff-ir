#!/bin/bash
clang -O2 -emit-llvm -S testcases/v1.c -o testcases/v1.ll
clang -O2 -emit-llvm -S testcases/v2.c -o testcases/v2.ll
diff testcases/v1.ll testcases/v2.ll
