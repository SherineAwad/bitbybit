=============================================
**Generate Fastq files from SRR** 
=============================================

First, lets download a sample from GEO::

    wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR15632726/SRR15632726


Then, we can extract the fastq file from this SRR15632726 as follows::

    fastq-dump --split-files SRR15632726



