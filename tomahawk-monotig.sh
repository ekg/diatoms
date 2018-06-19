#!/bin/bash


cat ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta.fai | cut -f 1 | parallel -k -j 28 'tabix -h pmulti.vcf.gz {} | bcftools filter -i "QUAL > 1" | vcfallelicprimitives | python3 order-vcf.py monotig.mapping.txt monotig ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta' | vcffirstheader | vcf-sort -c | bgziptabix pmulti.monotig.Q1.norm.vcf.gz
time bcftools view -Ob pmulti.monotig.Q1.norm.vcf.gz >pmulti.monotig.Q1.norm.bcf
time tomahawk import -i pmulti.Q1.norm.bcf -o pmulti.Q1.norm -n 1.0 
time tomahawk calc -pdi pmulti.monotig.Q1.norm.twk -o pmulti.monotig.Q1.norm.calc -a 0 -r 0.1 -P 0.1 -t 28
time tomahawk sort -i pmulti.monotig.Q1.norm.calc.two -o pmulti.monotig.Q1.norm.calc_psort
time tomahawk sort -i pmulti.monotig.Q1.norm.calc_psort.two -o pmulti.monotig.Q1.norm.calc_sorted -M
time tomahawk view -i pmulti.Q1.norm.tomahawk.calc_sorted.two -N -I monotig:34512712-39515908 -a 0 | grep -v "^#" >monotig:34512712-39515908.ld
time ./ld-plot-any.R monotig:34512712-39515908.ld monotig:34512712-39515908.ld.pdf


