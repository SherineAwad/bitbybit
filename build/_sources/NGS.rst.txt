====================================================
**Next Generation Sequencing Toolkit** 
====================================================


.. _trimming:

Reads Trimming
########################

Using Trimgalore
####################

We need to install :ref:`set_trimgalore` and its requirements :ref:`set_cutadapt` and :ref:`set_fastqc`
 
Then we remove adaptors and quality trim data as follows:: 

  trim_galore --paired --gzip --retain_unpaired --trim1 --fastqc --fastqc_args "--outdir fastqc" -o galore --path_to_cutadapt cutadapt_path  pair_1.fastq.gz pair_2.fastq.gz 

Using BBDuk 
############


A more sensitive trimmer is BBDuk from :ref:`set_bbmap`, but beware trimming is losing data::

  bash bbduk.sh -Xmx1g in1=R1_001.fastq.gz in2=R2_001.fastq.gz out=trimmed_reads.fq ref=resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 stats=stat.txt
 

Estimating Insert Size 
###########################


Here, we estimate the insert size using :ref:`set_bbmap` by aligning 4 million reads to the reference genome, pretty enough for a good estimation.
The output histogram will be written to histmap4m.txt::
 
   bash bbmap.sh -Xmx50g  in1=pair1.fastq.gz in2=pair2.fastq.gz ihist=histmap4m.txt reads=4000000 ref=human_genome.fa



If you don't have enough memory, you can use bbmerge, however, bbmap estimation is more accurate as it is based on alignment to reference:: 

   bash bbmerge.sh in1=pair1.fastq.gz in2=pair2.fastq.gz ihist=hist_merge.txt reads=4000000 prefilter=2 rem extend2=100



Get Unmapped reads from a BAM file 
###################################

Lets first install :ref:`set_samtools`. 

Here, we will get unmapped reads in a BAM file:: 

  samtools view -f 4 alignments.bam > unmapped.reads.sam 

Add -b to get the unmapped reads in a BAM :: 

  samtools view -b -f 4 alignments.bam > unmapped.reads.bam 


Or add -c to  count the unmapped reads :: 

  samtools view -c -f 4  alignments.bam >> unmapped.reads.count


Get Mapped reads from a BAM file 
#################################

Use -F to get the mapped reads as follows:: 

  samtools view -F 4 alignments.bam > mapped.reads.sam 

And similarily, add -b to get the mapped reads in a bam file :: 

 
  samtools view -b -F 4 alignments.bam > mapped.reads.bam 


To count mapped reads from a BAM file ::

  samtools view -c -F 4  alignments.bam >> mapped.reads.count



