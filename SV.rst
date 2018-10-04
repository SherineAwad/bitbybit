===============================================
**Structural Variation**
===============================================


We will use CNVnator, and starting from BAM files::

  cnvnator -root p1.root -genome GRCh37 -tree p1.bam 

:: 

  cnvnator -genome GRCh37 -root p1.root -his 100 -d ${CHR} 
 
::

  cnvnator -root p1.root -stat 100

::

  cnvnator -root p1.root -partition 100 

:: 

  cnvnator -root p1.root -call 100 > p1.cnvcalls.txt

:: 

  cnvnator -root p1.root -view 100 




