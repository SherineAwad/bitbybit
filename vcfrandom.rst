====================================
VCF Handler 
====================================

Here is a bunch of different operation we need regulary to do with vcf files. 

Megre vcf files:: 

    bgzip -c file1.vcf.vcf > file1.vcf.gz
    bgzip -c file1.vcf.vcf > file1.vcf.gz
    bgzip -c file1.vcf.vcf > file1.vcf.gz
    tabix -p vcf file1.vcf.gz
    tabix -p vcf file2.vcf.gz
    tabix -p vcf file3.vcf.gz 
    vcf-merge file1.vcf.gz file2.vcf.gz file3.vcf.gz > merged.vcf


Split vcf grouped samples into one sample per vcf::

    for sample in `bcftools query -l grouped.vcf`
        do
        vcf-subset --exclude-ref -c $sample grouped.vcf > "${sample}.vcf"
        done



Split vcf grouped samples per chromosome:: 

    bgzip -c allsamples.vcf > allsamples.vcf.gz
    tabix -p vcf allsamples.vcf.gz
    tabix -h allsamples.vcf.gz chr1 > allsamples_chr1.vcf

Sort:: 
   
    vcf-sort myvcf.vcf > new.vcf 
