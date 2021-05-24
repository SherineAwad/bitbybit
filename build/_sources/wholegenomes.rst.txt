============================
**Whole Genomes Toolkit** 
============================


In Progress 
############


Here, we will show various operations in whole genome Complete Genomics or BGI. 

Evidence to Sam
----------------

Convert to bam from cgatools, and then we can view the sorted bam in IGV:: 
 
    cgatools evidence2sam \
    --evidence-dnbs=evidenceDnbs-chr9-GS000004829-ASM.tsv.bz2 \
    --beta \
    --reference=build37.crr | samtools view -uS - | \
    samtools sort -T gs4829_9.sorted -o chr9-GS000004829.sorted.bam && samtools index chr9-GS000004829.sorted.bam 

Here we used the evidence file from cgatools output, and used evidence2sam to convert it to sam then sorted bam. 


CGAtools tsv to annovar format
-------------------------------

Convert from cgatools .tsv to Annovar format to further annotate with Annovar:: 

    convert2annovar.pl -format cg -out patientX.annovar.input  var-GSPatientX-ASM.tsv

Now, we can use patientX.annovar.input in Annovar:: 

     table_annovar.pl patientX.annovar.input  humandb/ -buildver hg19 -out patientX -remove -protocol refGene,cytoBand,gnomad_exome,exac03,avsnp147,\
        dbnsfp30a,clinvar_20170130,mitimpact2,revel -operation g,f,f,f,f,f,f,f,f  -nastring . -csvout -polish -xref example/gene_xref.txt 

where example/gene_xref.txt is the xref file found in example folder of Annovar. 
