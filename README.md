# Data and Pointer Prioritization (DPP)

This repository contains the source code and evaluation datasets of our proposed `Data and Pointer Prioritization (DPP)` framework utilizing rule-based heuristics to identify `sensitive` memory objects automatically from an application and protect only those sensitive data utilizing existing countermeasures. This work has been accepted in The 32nd USENIX Security Symposium (`USENIX Security'23`). The title of the paper is `Not All Data are Created Equal: Data and Pointer Prioritization for Scalable Protection Against Data-Oriented Attacks.`

### Getting Started

To install prerequisite, run the following command:
```bash
./prerequisites.sh
```

Download the code:
```bash
git clone https://github.com/salmanyam/DPP.git
```

This repo contains submodules and needs to be initiated:
```bash
cd DPP
git submodule update --init --recursive --progress
```

To install a CMake version 3.13.4 or higher, run the `install_cmake.sh` script. The script will install the CMake version 3.27.
```bash
./install_cmake.sh
```

To build the `dpp-llvm` source code along with `SVF`, run the `build.sh` script:
```bash
./build.sh
```
This script will do in-source compilation of `SVF` and build LLVM binaries (`clang`, `opt`, `llvm-ar`, `lld`, etc) are under
`dpp-llvm/build/bin`.

### Prioritization of data objects
Each of our rules is implemented as an Analysis pass located in `llvm/lib/DPP`. Please note that the rule number in the repository is slightly different than the rule number in our paper. The rule number mapping between this repo to our paper is given below for convenience.
```
Source code        Paper
-----------        -----
DPPRule1.cpp       Taint analysis
DPPRule2.cpp       Rule 1
DPPRule3.cpp       Rule 2
DPPRule4.cpp       -
DPPRule5.cpp       Rule 3
DPPRule6.cpp       Rule 4
DPPRule7.cpp       Rule 5
DPPRule8.cpp       Rule 6
DPPRule9.cpp       Rule 7
```

To run the prioritization, please use the following command. It is recommended to start with a simple program (`dpp-data/example/example.c`) to understand the result. The LLVM bitcode is also provided to the example directory (`dpp-data/example/example.opt`).
```bash
LLVM_DIR=${PWD}/dpp-llvm/build/bin
${LLVM_DIR}/opt -S -passes="print-dpp-global" --dpp-rule="all" -disable-output < ${PWD}/dpp-data/example/example.opt
```

The command will provide the following output for the `example` program by applying `all` our rules.
> **Note**: 
> please note that the optimization level is set to zero for the example. Our prioritization works better when no optimization-level is used. However, this can cause some duplicate objects in the `IR` file of the same high-level language object.


```
#################### SUMMARY: 4 data objects #########################
AddrVFGNode ID: 17 AddrPE: [34<--35]	
   %9 = call noalias i8* @malloc(i64 %8) #6, !dbg !25 { ln: 8  cl: 25  fl: example.c }	4	10
--------------------------------------------------------------
AddrVFGNode ID: 15 AddrPE: [22<--23]	
   %4 = alloca i8*, align 8 { ln: 8 fl: example.c }	2	10
--------------------------------------------------------------
AddrVFGNode ID: 11 AddrPE: [6<--7]	
 @stdin = external dso_local global %struct._IO_FILE*, align 8 { Glob  }	1	1
--------------------------------------------------------------
AddrVFGNode ID: 14 AddrPE: [20<--21]	
   %3 = alloca [10 x i8], align 1 { ln: 6 fl: example.c }	1	0
--------------------------------------------------------------

TOP-K = 4, Actual = 0
12(5) 12(5) 10(2) 0(0)  - 0(0) 10(3) 0(0) 11(2) 10(1) 11(4)
```

To run a single rule, modify the `--dpp-rule` field in the command. For example, if want to run `Rule 7` (i.e., `Rule 9` in the source code), use the following command: 
```bash
LLVM_DIR=${PWD}/dpp-llvm/build/bin
${LLVM_DIR}/opt -S -passes="print-dpp-global" --dpp-rule="rule9" -disable-output < ${PWD}/dpp-data/example/example.opt
```
The command will give the following output:
```
AddrVFGNode ID: 17 AddrPE: [34<--35]	
   %9 = call noalias i8* @malloc(i64 %8) #6, !dbg !25 { ln: 8  cl: 25  fl: example.c }
--------------------------------------------------------------

rule9:: 12(5) 10(1)
```
