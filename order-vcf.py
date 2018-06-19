#!/usr/bin/env python3

import sys

mapping_file=sys.argv[1]
monotig_name=sys.argv[2]
fasta_file=sys.argv[3]

d = {}
with open(mapping_file) as f:
    for line in f:
        (key, val) = line.split()
        d[key] = int(val)

monotig_length = 0
with open(fasta_file+".fai") as f:
    for line in f:
        (name, length, s, ll, lb) = line.split()
        monotig_length += int(length)

for line in sys.stdin:
    if line.startswith('##'): print(line.strip())
    elif line.startswith('#'): 
        print("##contig=<ID="+monotig_name+",length="+str(monotig_length)+">")
        print(line.strip())
    else:
        fields = line.strip().split('\t')
        tig = fields[0]
        offset = d[tig]
        fields[0] = monotig_name
        fields[1] = str(int(fields[1])+offset)
        print("\t".join(fields))
