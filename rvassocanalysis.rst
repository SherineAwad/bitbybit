**Rare Variants Association Analysis** 

Instead of testing whether a single variant is associated with a specific phenotype, we can study the cummulative effect of a group of variants in a gene or region on a specific phenotype. 
Rare variants association analysis has lots of categories, we will summarize here a few categories:



1. **Burden test:** is prefered when we have variants in the same direction and the same effect, i.e. variants are risk increasing or risk decreasing. Many methods fall under this category including **CMC**, **CMAT**, etc. Below is an example of using rvtest for burden test using CMC method.


.. ::

    rvtest --inVcf samples.vcf.gz --pheno samples.ped --freqUpper 0.01 --out cmc --geneFile refFlat_hg19.txt.gz --burden cmc

In the above example, we grouped the variants with MAF less than 0.01 per gene,so variants with MAF < 0.01 in each gene are grouped together for the analysis.

If you are interested in specific set of genes instead of all genes, you can specify using --gene parameter as follows:

.. ::

    rvtest --inVcf samples.vcf.gz --pheno samples.ped --freqUpper 0.01 --out cmc --gene GPR98,USH2A --geneFile refFlat_hg19.txt.gz --burden cmc




