===============================
**Alignments and Mapping** 
===============================


.. salmon_mapping: 

Mapping Using Salmon
=========================

First, install :ref:`set_salmon`

Building Index  first  
-----------------------

Using Quasi Mode for index:: 

  salmon index -t transcripts.fa -i quasi_index --type quasi -k 31

Using FMD mode for index :: 

  salmon index -t transcripts.fa -i fmd_index --type fmd


Mapping :: 
 
  salmon quant -i quasi-index --libType IU -1 readespair_1.fq.gz -2 readspair_2.fq.gz \
	-o mappingout --seqBias --gcBias --posBias -p 3 --writeUnmappedNames

Using gcBias improves results, and IU is for an unstranded paired-end library where the reads face each other.

 

 
Alignment using Tophat (Not preferred anymore) 
==============================================
  
:: 
 
   tophat -p 4 --no-mixed -G genes.gtf --library-type fr-firststrand -o output BowtieIndex \
      readspair_1.fq.gz readspair_2.fq.gz 

