=============================================
**Long nonCoding RNA Prediction** 
=============================================

      
Here we will use lncScore, check :ref:`set_lncscore` for installation tips. 
 
We use MyTranscripts.fa which contains our transcript in fasta format ::

    python lncScore.py -f MyTranscripts.fa -g ${GTF}/genes.gtf \
    -o ourlncRNA.results -p 1 -x dat/Human_Hexamer.tsv \
    -t dat/Human_training.dat 

To convert your alignments to fasta format, one options is to use Cufflinks :: 

  cufflinks -p 8 -G genes.gtf -o MyTranscripts  hits.bam

 
