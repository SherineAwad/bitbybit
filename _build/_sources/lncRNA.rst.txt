=============================================
Prediction of Long nonCoding RNA Prediction 
=============================================

Install lncScore:: 

    wget https://github.com/WGLab/lncScore/archive/v1.0.2.tar.gz 
    tar -xzvf v1.0.2.tar.gz 
       
We use MyTranscripts.fa which contains our transcript in fasta format ::

    python lncScore.py -f MyTranscripts.fa -g ${GTF}/genes.gtf \
    -o ourlncRNA.results -p 1 -x ${LNCSCORE}/dat/Human_Hexamer.tsv \
    -t ${LNCSCORE}/dat/Human_training.dat 

