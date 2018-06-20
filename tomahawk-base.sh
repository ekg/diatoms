#!/bin/bash



cat ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta.fai | cut -f 1 | parallel -k -j 28 'tabix -h pmulti.vcf.gz {} | vcfremovesamples - pool40.MT- pool40.MT+ | bcftools filter -i "QUAL > 1" | vcfallelicprimitives' | vcffirstheader | vcf-sort -c | bgziptabix pmulti.Q1.norm.vcf.gz
time bcftools view -Ob pmulti.Q1.norm.vcf.gz >pmulti.Q1.norm.bcf
time tomahawk import -i pmulti.Q1.norm.bcf -o pmulti.Q1.norm -n 1.0 -far
time tomahawk calc -pdi pmulti.Q1.norm.twk -o pmulti.Q1.norm.calc -a 0 -t 28
time tomahawk sort -i pmulti.Q1.norm.calc.two -o pmulti.Q1.norm.calc_psort
time tomahawk sort -i pmulti.Q1.norm.calc_psort.two -o pmulti.Q1.norm.calc_sorted -M
mkdir -p linkage_graph_mean && cat ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta.fai | cut -f 1 | parallel './render-tig-linkage-mean.sh {} linkage_graph_mean/ pmulti.Q1.norm.calc_sorted.two && echo {}'
time find linkage_graph_mean -type f | parallel 'zcat {}' | sort --parallel=8 >pmulti.Q1.norm.linkage_graph_mean.tsv
neighborly-tour/neighborly-tour pmulti.Q1.norm.linkage_graph_mean.tsv >pmulti.Q1.norm.linkage_graph_mean.tours
head -1 pmulti.Q1.norm.linkage_graph_mean.tours | cut -f 2 | tr ',' '\n' | head -n-1 >uPseMul2.contig_order.txt
( cat uPseMul2.contig_order.txt ; comm -13 <(sort uPseMul2.contig_order.txt ) <(cat ../diatom/assemblies/uPseMul2.contigs.fasta.fai | cut -f 1 | sort)  ) >uPseMul2.contig_order.plus_isolated.txt
join <(cat uPseMul2.contig_order.plus_isolated.txt | awk '{ print $1, NR"."$0 }' | tr ' ' '\t' | sort ) <(cat ../diatom/assemblies/uPseMul2.contigs.fasta.fai ) | tr ' ' '\t' | cut -f 2,3  | sort -n | awk 'BEGIN { n=0; } { print $0, n; n+=$2 }' | tr ' ' '\t'  | cut -f 2 -d. | cut -f 1,3 >monotig.mapping.txt

