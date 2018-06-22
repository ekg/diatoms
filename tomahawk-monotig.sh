#!/bin/bash


time cat ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta.fai | cut -f 1 | parallel -k -j 28 'tabix -h pmulti.vcf.gz {} | vcfremovesamples - pool40.MT- pool40.MT+ | vcffixup - | vcfkeepinfo - AF AC | vcfkeepgeno - GT | ./vcfnulldotslashdot-clean | bcftools filter -i "QUAL > 1" | vcfallelicprimitives | ./vcfnulldotslashdot-clean | python3 order-vcf.py monotig.mapping.txt monotig ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta' | vcffirstheader | vcf-sort -c | bgziptabix pmulti.monotig.Q1.norm.vcf.gz
time bcftools view -Ob pmulti.monotig.Q1.norm.vcf.gz >pmulti.monotig.Q1.norm.bcf
time tomahawk import -i pmulti.monotig.Q1.norm.bcf -o pmulti.monotig.Q1.norm -n 1.0 -far
#time tomahawk calc -pdi pmulti.monotig.Q1.norm.twk -o pmulti.monotig.Q1.norm.calc -a 2 -r 0.2 -t 32
rm -rf monotig-calc && mkdir -p monotig-calc
seq 1 990 | parallel -k -j 3 "echo 'tomahawk calc -i pmulti.monotig.Q1.norm.twk -o monotig-calc/pmulti.monotig.Q1.norm.calc.{} -a 2 -r 0.2 -P 0.01 -t 8 -c 990 -C {}' | run-bsub -a -m 16000 -A -q normal -c 8 -Panalysis-rd" >tomahawk-monotig.jobids
while [ $(comm -12 <(cat tomahawk-monotig.jobids | grep ^Job | cut -f 2 -d\  | tr '<' ' ' | tr '>' ' ' | awk '{ print $1 }'| sort ) <(bjobs | grep 'RUN\|PEND' | awk '{ print $1 }' | sort)  | wc -l) -ne 0 ]; do echo running $(comm -12 <(cat tomahawk-monotig.jobids | grep ^Job | cut -f 2 -d\  | tr '<' ' ' | tr '>' ' ' | awk '{ print $1 }'| sort ) <(bjobs | grep 'RUN\|PEND' | awk '{ print $1 }' | sort)  | wc -l) ;sleep 60 ;done
time tomahawk concat -F <(find monotig-calc -type f) -o pmulti.monotig.Q1.norm.calc
time tomahawk sort -i pmulti.monotig.Q1.norm.calc.two -o pmulti.monotig.Q1.norm.calc_psort -t 32
time tomahawk sort -i pmulti.monotig.Q1.norm.calc_psort.two -o pmulti.monotig.Q1.norm.calc_sorted -M -t 32
