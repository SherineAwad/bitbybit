====================================
Somatic Mutations from RNAseq
====================================

Here we will follow GATK pipeline for detecting somatic mutations from RNAseq data

Creating panel of normals::

first we need to create a `NORMALS.list` file that contains the name of the normal vcfs perceded by -V : 

::
	-V normal1.vcf
	-V normal2.vcf
	-V normal3.vcf
 

Then we create the panel of normals as follows:: 

  java -jar GenomeAnalysisTK.jar \
  -T CombineVariants \
  --arg_file NORMALS.list \
  -minN 2 \
  --setKey "null" \
  --filteredAreUncalled \
  --filteredrecordsmergetype KEEP_IF_ANY_UNFILTERED \
  -o pon.vcf.gz \
  -R hg38.fasta


Then we will create panel of normals only sites as follows::


   java -Dlog4j.configurationFile="log4j2.xml" -jar picard.jar MakeSitesOnlyVcf \
   I= pon.vcf.gz \
   O= pon_siteonly.vcf.gz 
