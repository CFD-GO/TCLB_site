---
title: "Units"
author: "Paweł Obrępalski"
date: "July 6, 2017"
output: html_document
---

**Units** provide a way to connect LB units to real ones. Currently, there are several units defined in the code. There are 

###Defined units:

Unit  | Meaning
 ---  | ---
m     | meter
s     | second
kg    | kilogram
K     | Kelvin
A     | Amper
t     | Second time scale, needed in EOF in steady state simulations
x,y,z | Artificial units(?)



###Derrived units:

Unit  | Definition  | Meaning
---   | ---         | ---
N     | 1kgm/s2     | Newton
Pa    | 1N/m2       | Pascal
J     | 1Nm         | Joul
W     | 1J/s        | Watt
V     | 1kgm2/t3/A  | Volt
C     | 1tA         | Coulomb


###Prefixes:

Prefix| Definition  | Meaning
---   | ---         | ---
nm    | 1e-9m       | nanometre
um    | 1e-6m       | micrometre
cm    | 1e-2m       | centimetre
km    | 1e+3m       | kilometre
h     | 3600s       | hour
ns    | 1e-9s       | nanosecond
us    | 1e-6s       | microsecond
ms    | 1e-3s       | milisecond
mg    | 1e-6s       | miligram
g     | 1e-3s       | gram
An    |6.02e+23     | Avogadro number
d     |atan(1.)*4./180| degree


###Defining units

It is possible to define new units

###Using gauge



