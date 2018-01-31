##Random operations on VCF file 

Megre vcf files: 

    bgzip -c file1.vcf.vcf > file1.vcf.gz
    bgzip -c file1.vcf.vcf > file1.vcf.gz
    bgzip -c file1.vcf.vcf > file1.vcf.gz
    tabix -p vcf file1.vcf.gz
    tabix -p vcf file2.vcf.gz
    tabix -p vcf file3.vcf.gz 
    vcf-merge file1.vcf.gz file2.vcf.gz file3.vcf.gz > merged.vcf


Split vcf grouped samples into one sample per vcf:

    for sample in `bcftools query -l grouped.vcf`
        do
        vcf-subset --exclude-ref -c $sample grouped.vcf > "${sample}.vcf"
        done

 
