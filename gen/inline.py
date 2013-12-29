#!/usr/bin/env python

import re
import sys

filename = sys.argv[1]

f = open(filename)
lines = f.readlines()
f.close()

FILE_RE=re.compile(r"\s+\.file (\d+) \"(.*)\"")
LOC_RE =re.compile(r"\s+\.loc (\d+) (\d+)")

output = []
files = {}
for line in lines:
    output.append(line)
    mo = FILE_RE.match(line)
    if mo is not None:
       files[mo.group(1)] = open(mo.group(2)).readlines()
       print mo.group(1),"=",mo.group(2)
       continue
    mo = LOC_RE.match(line)
    if mo is not None:
       print mo.group(1),"=",mo.group(2)
       source = files[mo.group(1)][int(mo.group(2))-1]
       output.append("\t#."+source)

f = open(filename+".2","w")
f.writelines(output)
f.close()
