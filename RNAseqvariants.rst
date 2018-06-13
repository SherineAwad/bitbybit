====================================
Variant Calling for RNASeq Data 
====================================

Here we will follow GATK pipeline for variant calling from RNAseq data. 


Lets first create an index::  

  STAR --runMode genomeGenerate --genomeDir hg38Index --genomeFastaFiles hg38.fasta  --runThreadN 4

Using our reference fasta files hg38.fasta, we created the index hg38Index, which will be used in further steps. 

Now, we will use Star to align our fastq files in 2 passes as follows::  
 
 
  STAR --genomeDir hg38Index --readFilesIn pair1.fq pair2.fq --runThreadN 2  
  STAR --runMode genomeGenerate --genomeDir current/ --genomeFastaFiles  hg38.fasta \  
  --sjdbFileChrStartEnd SJ.out.tab --sjdbOverhang 75 --runThreadN 2 
 
Here we used 2 threads, and assumed the genomeDir is current/

::  
 
  STAR --genomeDir ${WHERE} --readFilesIn ${WHERE}/${s1_1}.fq ${WHERE}/${s1_2}.fq --runThreadN 2 

And by this step, we will have our alignments in Aligned.out.sam 

Now, we use picard to mark duplicates as follows:: 


  java -Dlog4j.configurationFile="log4j2.xml" -jar ${PICARD}/picard.jar AddOrReplaceReadGroups I=Aligned.out.sam O=rg_added_sorted.bam \
  SO=coordinate RGID="@E00461_116.Sp1483_S13" RGLB=Sp1483_S13 RGPL=ILLUMINA RGPU="@E00461_116_GW170602261_1.Sp1483_S13" RGSM=Sp1483
 
:: 

 
  java -Dlog4j.configurationFile="log4j2.xml" -jar ${PICARD}/picard.jar MarkDuplicates I=rg_added_sorted.bam O=sample.dedupped.bam  CREATE_INDEX=true \
  VALIDATION_STRINGENCY=SILENT M=output.metrics 
        
       
Then, we need to split N in caring in Cigar reads :: 

	
  java -jar GenomeAnalysisTK.jar -T SplitNCigarReads -R hg38.fasta -I sample.dedupped.bam -o sample.split.bam \
  -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS


This step is not necessary if you will use haplotype caller or Mutect2, here we do realign around indels ::

 
  java -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R hg38.fasta \
  -known Homo_sapiens_assembly38.known_indels.vcf -I sample.split.bam -o sample.realignertargetcreator.intervals \ 
  java -jar GenomeAnalysisTK.jar -T BaseRecalibrator -R hg38.fasta -I sample.split.bam -knownSites dbsnp138.vcf   

 :: 

 
  java -jar GenomeAnalysisTK.jar  -T BaseRecalibrator -R hg38.fasta  -I sample.split.bam -knownSites  dbsnp138.vcf \
  -knownSites Mills_and_1000G_gold_standard.indels.hg38.vcf  -BQSR sample.recal_data.table -o sample.post_recal_data.table 

Then lets generate some plots to check whether post recabliration is better than pre recabliration:: 
 
 
  java -jar GenomeAnalysisTK.jar -T AnalyzeCovariates -R hg38.fasta -before sample.recal_data.table  -after sample.post_recal_data.table  \
  -plots sample.recalibration_plots.pdf

Assuming post recabliration is better than before recabliration, we create our bam file as follows::  


  java -jar GenomeAnalysisTK.jar  -T PrintReads -R hg38.fasta -I  sample.split.bam \
  -BQSR sample.post_recal_data.table -o sample.bam  


