#!/bin/bash

tig=$1
base=$2
input=$3

tomahawk view -i $3 -N -I $tig -a 0 -F 2 | grep -v "^#" | cut -f 2,4,13 | tail -n+2 | sort | awk 'BEGIN { q=0; t=0; s=0; c=0; } { if (NR==1) { q=$1; t=$2; s=$3; c=1; } else if (q!=$1 || t!=$2) { print q, t, s/c; s=$3; q=$1; t=$2; c=1; } else { s+=$3; c+=1; } }' | tr ' ' '\t' | sort -nr -k 3 | gzip >${base}${tig}.corr.gz
