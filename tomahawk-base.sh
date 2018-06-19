#!/bin/bash



cat ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta.fai | cut -f 1 | parallel -k -j 28 'tabix -h pmulti.vcf.gz {} | bcftools filter -i "QUAL > 1" | vcfallelicprimitives' | vcffirstheader | vcf-sort -c | bgziptabix pmulti.Q1.norm.vcf.gz
time bcftools view -Ob pmulti.Q1.norm.vcf.gz >pmulti.Q1.norm.bcf
time tomahawk import -i pmulti.Q1.norm.bcf -o pmulti.Q1.norm -n 1.0
time tomahawk calc -pdi pmulti.Q1.norm.twk -o pmulti.Q1.norm.calc -a 0 -r 0.1 -P 0.1 -t 28
time tomahawk sort -i pmulti.Q1.norm.calc.two -o pmulti.Q1.norm.calc_psort
time tomahawk sort -i pmulti.Q1.norm.calc_psort.two -o pmulti.Q1.norm.calc_sorted -M
#time tomahawk view -i pmulti.monotig.Q1.norm.tomahawk.calc_sorted.two -N -I monotig:34512712-39515908 -a 0 | grep -v "^#" >tig:34512712-39515908.ld
mkdir -p linkage_graph_mean && cat ~/graphs/diatom/assemblies/uPseMul2.contigs.fasta.fai | cut -f 1 | parallel './render-tig-linkage-mean.sh {} linkage_graph_mean/ pmulti.Q1.norm.calc_sorted.two && echo {}'
time find linkage_graph_mean -type f | parallel 'zcat {}' | sort --parallel=8 | pigz >pmulti.Q1.norm.linkage_graph_mean.tsv.gztime find linkage_graph_mean -type f | parallel 'zcat {}' | sort --parallel=8 | pigz >pmulti.Q1.norm.linkage_graph_mean.tsv.gz

#time ./ld-plot-any.R monotig:34512712-39515908.ld monotig:34512712-39515908.ld.pdf

