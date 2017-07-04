---
title: "Running calculations"
author: "Paweł Obrępalski"
date: "July 4, 2017"
output: html_document
---

#Usage
```bash
CLB/MODEL_NAME/main case_path
```
Where `MODEL_NAME` is the name of the desired model(e.g.`d2q9`) and `case_path` is the location of case file(.xml), relative to the TCLB folder.

For example, to run `karman.xml` case, located in subfolder `example\flow\2d`, using `d2q9` model:

```bash
CLB/d2q9/main example/flow/2d/karman.xml
```

###CPU-based usage

By default the code will run on GPU, which requires a NVIDIA GPU with CUDA support. In order to run it on CPU, the code must be compiled using `--disable-cuda` option. In order to run the calculations on CPU in parallel, one need to start calculations using `mpirun` option:

```bash
mpirun -np X CLB/MODEL_NAME/main case_path
```
Where `X` is number of threads that will be created. Usually max number of threads is equal to number of cores of a processor, with the exception of CPUs with multi-threading.

TODO: Może też coś o tym jak odpalać obliczenia na klastrze?(instrukcja z wiki github)