====================================
**Samtools Variant Calling** 
====================================


Here we will follow do a simple variant calling. 

Lets first create two folders for organizing our data::

    mkdir galore 
    mkdir fastqc 

Lets trim and quality filter our data, here our sample is paired-end :: 

    trim_galore --paired --gzip --retain_unpaired --trim1 --fastqc --fastqc_args "--outdir fastqc" -o galore \ 
    sampleA_r1.fastq.gz sampleA_r2.fastq.gz

We have to check the quality of the reads in fastqc folder. 


Now, lets download the reference genome. Assuming out samples are human samples, we can download the human genome and unzip it as follows:: 

        wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Homo_sapiens/NCBI/GRCh38/Homo_sapiens_NCBI_GRCh38.tar.gz
        tar -xzvf Homo_sapiens_NCBI_GRCh38.tar.gz
       
You will find the genome.fa under Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa. 

You can link it to your current directory:: 

        ln -fs Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa . 

Similarly, if can download any other reference genome that match your sample. 

Then, lets use bwa aln to align our reads :: 

   bwa aln genome.fa  galore/sampleA_r1_val_1.fq.gz  > sampleA_r1.sai
   bwa aln genome.fa  galore/sampleA_r2_val_2.fq.gz  > sampleA_r2.sai 

Convert to sam:: 

   bwa sampe genome.fa sampleA_r1.sai sampleA_r2.sai galore/sampleA_r1_val_1.fq.gz galore/sampleA_r2_val_2.fq.gz > sampleA.sam


And convert our sam to bam using a sorted reference genome genome.fa.fai, your sorted genome can be found here: Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa.fai 
and you can also link it to your current directory as follows:: 
        
        ln -fs Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa.fai . 

Now, convert sam to bam:: 

  samtools import genome.fa.fai sampleA.sam sampleA.bam

Finally sort the bam files :: 

  samtools sort -T sampleA.sorted -o sampleA.sorted.bam sampleA.bam
  samtools index sampleA.sorted.bam

.. _calling_samtools: 

Calling variants using Samtools 
#################################

Here, we will call variants using samtools ::  

  samtools mpileup -uf genome.fa sampleA.sorted.bam | bcftools call -vmO v -o sampleA.vcf --threads 2




