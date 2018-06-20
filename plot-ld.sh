#!/bin/bash

x=$1 # lower limit
y=$2 # upper limit
z=$3 # version of plot
monotigs=$4
tomahawk view -i pmulti.monotig.Q1.norm.tomahawk.calc_sorted.two -N -I monotig:$x-$y -a 2 | grep -v "^#" | awk 'BEGIN { OFS ="\t" } ($3 >= '$x' && $5 >= '$x' && $3 < '$y' && $5 < '$y') { print } NR==1 { print }' >monotig_$x-$y.$z.ld
./ld-plot-any.square.special.R monotig_$x-$y.$z.ld monotig_$x-$y.$z.ld.pdf $monotigs
convert -density 300 monotig_$x-$y.$z.ld.pdf monotig_$x-$y.$z.ld.png


