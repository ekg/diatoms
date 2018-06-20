#!/bin/bash

#x=$(cat monotig.mapping.txt | grep -B 10 -A 11 tig00000855 | head -1 | cut -f 2)
#y=$(cat monotig.mapping.txt | grep -B 10 -A 11 tig00000855  | tail -1 | cut -f 2)
x=$1
y=$2
z=$3
tomahawk view -i pmulti.monotig.Q1.norm.tomahawk.calc_sorted.two -N -I monotig:$x-$y -a 2 | grep -v "^#" | awk 'BEGIN { OFS ="\t" } ($3 >= '$x' && $5 >= '$x' && $3 < '$y' && $5 < '$y') { print } NR==1 { print }' >monotig_$x-$y.$z.ld
./ld-plot-any.square.special.R monotig_$x-$y.$z.ld monotig_$x-$y.$z.ld.pdf
convert -density 300 monotig_$x-$y.$z.ld.pdf monotig_$x-$y.$z.ld.png


