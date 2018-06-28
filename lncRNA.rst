=============================================
**Long nonCoding RNA Prediction** 
=============================================

Some Strategies to discriminate between ncRNA and mRNA
----------------------------------------------------

1. Short Putativs ORFs 
#######################

Short putative ORFs can be expected to occur by chance within lncRNA
A protein-coding mRNA can be defined by open reading frame (ORF) greater than 100 amino acids (aa) or 300 nucleotides (nt)
Cutoffs are used to discriminate between ncRNA and mRNA: (300 nt /100 codons)

However, lncRNA sometimes contain ORF that are long, hence protein with <100 are misclassified as ncRNA. Also, reducing the cutoff leads to underestimating ncRNA.  

2. Open reading frame conservation
######################################

Assessing putative ORF for similarity to known proteins or protein domain, such homology provides indirect evidence of function as mRNA. Many studies cite lack of ORF conservation to argue against function as mRNA
However, the vast majority of putative human ORFs without cross-species counterparts is likely to be random  occurrence
Detecting conservation relies a lot on the accuracy of current protein annotation. 
For example: 
Xist was annotated for 15 years in all public database as a protein  coding, discovered lately as ncRNA
In addition,  some ncRNA have evolved from protein-coding genes, and will retain some remnant  signatures of homologies to mRNA. 


3. Structural Approaches
##############################


Indirectly detect lncRNA from the absence of mRNA-like charaterstics 
and identify lncRNA from the presence of conserved predicted RNA secondary structures
However, this leads to high false postives since many conserved secondary structures existed also in mRNA


:ref:`set_lncscore` and other tools use combination of methods to predict lncRNA. 


Using lncScore to predict novel lncRNA 
------------------------------------------


Here we will use lncScore, check :ref:`set_lncscore` for installation tips.

We use MyTranscripts.fa which contains our transcript in fasta format ::

    python lncScore.py -f MyTranscripts.fa -g ${GTF}/genes.gtf \
    -o ourlncRNA.results -p 1 -x dat/Human_Hexamer.tsv \
    -t dat/Human_training.dat

To convert your alignments to fasta format, one options is to use Cufflinks ::

  cufflinks -p 8 -G genes.gtf -o MyTranscripts  hits.bam


