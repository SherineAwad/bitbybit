====================================
**GATK Variant Calling** 
====================================


Here, we will do a simplified GATK variant calling. This tutorial will not dig into GVCF mode nor variant recalibration and other advnced stuff in GATK. 

Lets first create two folders for organizing our data::

    mkdir galore 
    mkdir fastqc 

Lets trim and quality filter our data, here our sample is paired-end :: 

    trim_galore --paired --gzip --retain_unpaired --trim1 --fastqc --fastqc_args "--outdir fastqc" -o galore \ 
    sampleA_r1.fastq.gz sampleA_r2.fastq.gz

We have to check the quality of the reads in fastqc folder. 


Now, lets download the reference genome and some supportive resources needed from GATK resource bundle. Assuming out samples are human samples, we can download the human genome and unzip it as follows:: 

    mkdir reference
    cd reference  
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf.gz
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf.gz.tbi
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/1000G_phase1.snps.high_confidence.hg38.vcf.gz
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/1000G_phase1.snps.high_confidence.hg38.vcf.gz.tbi
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/1000G_omni2.5.hg38.vcf.gz
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/1000G_omni2.5.hg38.vcf.gz.tbi
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz
    wget https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz.tbi
    wget https://storage.googleapis.com/genomics-public-data/references/hg38/v0/Homo_sapiens_assembly38.dict
    wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Homo_sapiens/NCBI/GRCh38/Homo_sapiens_NCBI_GRCh38.tar.gz
    cd ../


We will need to index our reference or (you can download the index as well) ::
    
    bowtie2-build  Homo_sapiens_assembly38.fasta Homo_sapiens_assembly38
    samtools faidx Homo_sapiens_assembly38.fasta 

Now, we can use bowtie2 to align our reads :: 

    bowtie2 -x reference/Homo_sapiens_assembly38 -1 galore/sampleA_r1_val_1.fq.gz -2 galore/sampleA_r2_val_2.fq.gz  -S sampleA.sam 


Then we will need to add read groups, we can use picard for that:: 
 
    picard AddOrReplaceReadGroups I=sampleA.sam O=sampleA.RG.sam SO=coordinate RGID=@A00489_467.HT3G5DMXX.s_2 RGSM=sampleA RGPL=Illumina RGLB=sampleA RGPU=A00489_467.HT3G5DMXX.s_2_sampleA VALIDATION_STRINGENCY=SILENT


We need now to mark duplicates::

   picard MarkDuplicates I=sampleA.RG.sam O=sampleA.dedupped.bam CREATE_INDEX=true M=sampleA.output.metrics


Once we added read groups and marked duplicates, we can now do base recalibration:: 

    gatk --java-options -Xmx100g BaseRecalibrator -I sampleA.dedupped.bam -R Homo_sapiens_assembly38.fasta --known-sites Homo_sapiens_assembly38.dbsnp138.vcf --known-sites Homo_sapiens_assembly38.known_indels.vcf.gz --known-sites Mills_and_1000G_gold_standard.indels.hg38.vcf.gz -O sampleA.recal_data.table
    gatk --java-options -Xmx100g ApplyBQSR  -I sampleA.dedupped.bam -R Homo_sapiens_assembly38.fasta --bqsr-recal-file sampleA.recal_data.table -O sampleA.recalibrated.bam 
       

Then, we can finally call haplotypecaller:: 

    gatk --java-options "-Xmx500g -XX:ParallelGCThreads=4" HaplotypeCaller -R Homo_sapiens_assembly38.fasta -I sampleA.recalibrated.bam   -O sampleA.vcf  


Annovar annotation and hard filtering
##############################################


We can annotate our vcf using annovar as follows:: 

    ~/annovar/table_annovar.pl sample.vcf ~/annovar/humandb -buildver hg38 -out sampleA -remove -protocol refGene,ensGene,cytoBand,exac03,gnomad_exome,avsnp147,dbnsfp33a,clinvar_20170130,revel -operation g,g,f,f,f,f,f,f,f  -nastring . -vcfinput


We can also hard filter our vcf, note that this tutorial doesn't cover variant recalibration:: 

     gatk VariantFiltration -V sampleA.hg38_multianno.vcf -filter "QD < 2.0" --filter-name "QD2" -filter "QUAL < 30.0" --filter-name "QUAL30"  -filter "SOR > 3.0" --filter-name "SOR3"    -filter "FS > 60.0" --filter-name "FS60"  -filter "MQ < 40.0" --filter-name "MQ40" -filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5"  -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8"  -O sampleA.hg38_multianno.filtered.vcf.gz         

