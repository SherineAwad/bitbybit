====================================
**SNP Array Toolkit** 
====================================

In Progress
-------------

Here, we will assume we start the analysis with a data.ped and data.map files. 

Create a Bed file
-------------------

::

  plink --file data --maf 0.05 --make-bed --out data 



SNP Prunning 
---------------

:: 

  plink --file SNP --homozyg  --homozyg-snp 100 --homozyg-kb 500 --homozyg-density 50 -homozyg-gap 100 --homozyg-window-snp 50    

Convert ped to VCF 
------------------------

:: 

  plink --file data --recode vcf --out data


Remove Duplicate Variants 
----------------------------

:: 

   plink --bfile data --list-duplicate-vars ids-only suppress-first
   plink --bfile data -exclude plink.dupvar --make-bed --out data.DuplicatesRemoved


Association Analysis
------------------------

:: 
 
   plink --file data --assoc --out data.assoc


Linkage Disequilibrium
------------------------

::

  plink --file SNP --r2 --ld-window-kb 1000 --ld-window-r2 0.0 
