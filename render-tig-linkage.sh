#!/bin/bash

tig=$1
base=$2

tomahawk view -i pmulti.Q1.norm.tomahawk.calc_sorted.two -N -I $tig -a 0 -F 2 | grep -v "^#" | cut -f 2,4,13 | tail -n+2 | sort | awk 'BEGIN { q=0; t=0; s=0; } { if (NR==1) { q=$1; t=$2; s=$3; } else if (q!=$1 || t!=$2) { print q, t, s; s=$3; q=$1; t=$2; } else { s+=$3; } }' | tr ' ' '\t' | sort -nr -k 3 | gzip >${base}${tig}.corr.gz
