Random Operations to handle Complete Genomics/BGI
--------------------------------------------------

Convert to bam from cgatools, and then we can view the sorted bam in IGV:: 
 
    ${CGATOOLS}/cgatools evidence2sam \
    --evidence-dnbs=evidenceDnbs-chr9-GS000004829-ASM.tsv.bz2 \
    --beta \
    --reference=build37.crr | samtools view -uS - | \
    samtools sort -T gs4829_9.sorted -o chr9-GS000004829.sorted.bam && samtools index chr9-GS000004829.sorted.bam 

Here we used the evidence file from cgatools output, and used evidence2sam to convert it to sam then sorted bam. 
