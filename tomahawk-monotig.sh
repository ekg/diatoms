#!/bin/bash


time cat ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta.fai | cut -f 1 | parallel -k -j 28 'tabix -h pmulti.vcf.gz {} | vcfremovesamples - pool40.MT- pool40.MT+ | vcffixup - | vcfkeepinfo - AF AC | vcfkeepgeno - GT | ./vcfnulldotslashdot-clean | bcftools filter -i "QUAL > 1" | vcfallelicprimitives | ./vcfnulldotslashdot-clean | python3 order-vcf.py monotig.mapping.txt monotig ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta' | vcffirstheader | vcf-sort -c | bgziptabix pmulti.monotig.Q1.norm.vcf.gz
time bcftools view -Ob pmulti.monotig.Q1.norm.vcf.gz >pmulti.monotig.Q1.norm.bcf
time tomahawk import -i pmulti.monotig.Q1.norm.bcf -o pmulti.monotig.Q1.norm -n 1.0 -far
time tomahawk calc -pdi pmulti.monotig.Q1.norm.twk -o pmulti.monotig.Q1.norm.calc -a 0 -t 28
time tomahawk sort -i pmulti.monotig.Q1.norm.calc.two -o pmulti.monotig.Q1.norm.calc_psort
time tomahawk sort -i pmulti.monotig.Q1.norm.calc_psort.two -o pmulti.monotig.Q1.norm.calc_sorted -M
