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

