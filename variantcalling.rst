====================================
**Variant Calling** 
====================================

In Progress
##############


Here we will follow do variant calling, note that we can follow GATK pipeline or use samtools, we will show both. 

Lets trim our data, we can refer also to our section  :doc:`trimming` for more details :: 

    trim_galore --paired --gzip --retain_unpaired --trim1 --fastqc --fastqc_args "--outdir fastqc" -o galore --path_to_cutadapt cutadapt/ \ 
    reads_mate1.fastq.gz read_mate2.fastq.gz


Then, lets use bwa aln to align our reads :: 

   bwa aln genome.fa  read_mate1_val_1.fq.gz  > read_mate1.sai
   bwa aln genome.fa  read_mate2_val_2.fq.gz  > read_mate2.sai 

Convert to sam:: 

   bwa sampe genome.fa read_mate1.sai read_mate2.sai galore/read_mate1_val_1.fq.gz galore/read_mate2_val_2.fq.gz > reads.sam


And convert our sam to bam using a sorted reference genome genome.fa.fai :: 

  samtools import genome.fa.fai reads.sam reads.bam

Finally sort the bam files :: 

  samtools sort -T reads.sorted -o reads.sorted.bam reads.bam
  samtools index reads.sorted.bam
 
Calling variants using Samtools 
#################################

  samtools mpileup -uf genome.fa reads.sorted.bam | bcftools call -vmO v -o reads.vcf --threads 2
