====================================
**Variant Calling** 
====================================



Here we will follow do a simple variant calling. 

Lets first create two folders for organizing our data::

    mkdir galore 
    mkdir fastqc 

Lets trim and quality filter our data :: 

    trim_galore --paired --gzip --retain_unpaired --trim1 --fastqc --fastqc_args "--outdir fastqc" -o galore --path_to_cutadapt cutadapt/ \ 
    reads_mate1.fastq.gz read_mate2.fastq.gz

We have to check the quality of the reads in fastqc folder. 


Then, lets use bwa aln to align our reads :: 

   bwa aln genome.fa  galore/read_mate1_val_1.fq.gz  > read_mate1.sai
   bwa aln genome.fa  galore/read_mate2_val_2.fq.gz  > read_mate2.sai 

Convert to sam:: 

   bwa sampe genome.fa read_mate1.sai read_mate2.sai galore/read_mate1_val_1.fq.gz galore/read_mate2_val_2.fq.gz > reads.sam


And convert our sam to bam using a sorted reference genome genome.fa.fai :: 

  samtools import genome.fa.fai reads.sam reads.bam

Finally sort the bam files :: 

  samtools sort -T reads.sorted -o reads.sorted.bam reads.bam
  samtools index reads.sorted.bam

.. _calling_samtools: 

Calling variants using Samtools 
#################################

Here, we will call variants using samtools ::  

  samtools mpileup -uf genome.fa reads.sorted.bam | bcftools call -vmO v -o reads.vcf --threads 2




Annovar Annotations 
#####################

Lets annotate our vcf file using Annovar :: 

  table_annovar.pl reads.haplotype.vcf humandb/ -buildver hg19 -out annotated_vcf -remove -protocol refGene,ensGene,cytoBand,exac03,gnomad_exome,avsnp147,\
  dbnsfp30a,clinvar_20170130,mitimpact2,revel -operation g,g,f,f,f,f,f,f,f,f  -nastring . -vcfinput 


Notes on variants filtering 
#############################

.. topic:: Be Cautious 

  Be very cautious  with hard filtering. Filtering means throwing data. 
