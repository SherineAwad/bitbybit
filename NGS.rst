====================================================
**Next Generation Sequencing Toolkit** 
====================================================


Reads Trimming
########################

We need to install Trimgalore :ref:`set_trimgalore` and its requirements Cutadapt  :ref:`set_cutadapt` and FastQC :ref:`set_fastqc`
 
Then we remove adaptors and quality trim data as follows:: 

  trim_galore --paired --gzip --retain_unpaired --trim1 --fastqc --fastqc_args "--outdir fastqc" -o galore --path_to_cutadapt cutadapt_path  pair_1.fastq.gz pair_2.fastq.gz 



Estimating Insert Size 
###########################


Here, we estimate the insert size using bbmap by aligning 4 million reads to the reference genome, pretty enough for a good estimation. The output histogram will be written to histmap1mtxt::
 
   bash bbmap.sh -Xmx50g  in1=pair1.fastq.gz in2=pair2.fastq.gz ihist=histmap4m.txt reads=4000000 ref=human_genome.fa



If you don't have enough memory, you can use bbmerge, however, bbmap estimation is more accurate as it is based on alignment to reference:: 

   bash bbmerge.sh in1= in1=pair1.fastq.gz in2=pair2.fastq.gz ihist=hist_merge.txt reads=4000000 prefilter=2 rem extend2=100


