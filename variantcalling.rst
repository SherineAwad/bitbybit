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

.. _calling_samtools: 

Calling variants using Samtools 
#################################

Here, we will call variants using samtools. We can also use the sorted BAM to call variants using Gatk pipeline :doc:`calling_gatk` ::  

  samtools mpileup -uf genome.fa reads.sorted.bam | bcftools call -vmO v -o reads.vcf --threads 2



.. _calling_gatk: 

Calling variants using GATK pipeline
#######################################

Lets add read groups to our sam file reads.sam :: 

   java -Dlog4j.configurationFile="log4j2.xml" -jar picard.jar AddOrReplaceReadGroups I=reads.sam O=rg_added_sorted.bam \
    SO=coordinate RGID=@HWI-D00380_37_C4H2JACXX_2 RGLB=D109573_TAAGGCGA RGPL=ILLUMINA RGPU=@HWI-D00380_37_C4H2JACXX_2.D109573_TAAGGCGA RGSM=D109573

Then lets do some sorting :: 

  samtools sort -T reads.sorted -o reads.sorted.bam rg_added_sorted.bam
  samtools index reads.sorted.bam 


Indel realignments is optional since we will use haplotype caller.
So lets do base recabliration :: 
 
  java -jar GenomeAnalysisTK.jar -T BaseRecalibrator -R genome.fa -I reads.sorted.bam \
  -knownSites dbsnp_138.hg19.vcf  -o reads.recal_data.table 

And post recabliration :: 

  java -jar GenomeAnalysisTK.jar -T BaseRecalibrator -R genome.fa -I reads.sorted.bam \
  -knownSites dbsnp_138.hg19.vcf -BQSR reads.recal_data.table -o reads.post_recal_data.table


Then get our recablirated bam file :: 

  java -jar GenomeAnalysisTK.jar -T PrintReads -R genome.fa -I reads.sorted.bam \
  -BQSR reads.post_recal_data.table -o reads.recablirated.bam 

Finally, lets use haplotype caller to call variants :: 

  java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R genome.fa -I reads.recablirated.bam \
  -dontUseSoftClippedBases -stand_call_conf 20.0  -o reads.haplotype.vcf 


Annovar Annotations 
#####################

Lets annotate our vcf file using Annovar :: 

  table_annovar.pl reads.haplotype.vcf humandb/ -buildver hg19 -out annotated_vcf -remove -protocol refGene,ensGene,cytoBand,exac03,gnomad_exome,avsnp147,\
  dbnsfp30a,clinvar_20170130,mitimpact2,revel -operation g,g,f,f,f,f,f,f,f,f  -nastring . -vcfinput 


Notes on filtering variants 
##################################


Be very cautious  with hard filtering.
High/low GC content have an effect on coverage in NGS. Ignoring variants with lower coverage in these regions could lead to missing an interesting variant. Be very cautious. 

Take a deep look into variants in duplicate genes. Human genome  exhibits lots of similarity. Ignoring variants just becasuse it is in a duplicate gene could lead  to missing interesting variants.
When it comes to duplicate gene, investigate the mapping quality and region mappability.


