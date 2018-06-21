========================================
**Transcripts to Genes**
========================================

.. _txtogene:

How to convert from transcripts to Genes ids
----------------------------------------------


1. Download your annotated GFF file, here, we download Refseq annotated GRCh37::

	wget ftp://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.gff.gz	


2. Install Libraries :: 

  source("https://bioconductor.org/biocLite.R")
  biocLite("TxDb.Mmusculus.UCSC.mm10.knownGene")

or 
  biocLite("TxDb.Mmusculus.UCSC.mm10.ensGene")

Then we can use this script for conversion :: 

  library(TxDb.Mmusculus.UCSC.mm10.ensGene)
  txdb <- TxDb.Mmusculus.UCSC.mm10.ensGene
  k <- keys(txdb, keytype = "GENEID")
  df <- select(txdb, keys = k,  columns = "TXNAME", keytype = "GENEID")
  tx2gene <- df[, 2:1]
  head(tx2gene)
  write.csv(tx2gene, 'tx2gene.csv')
 

4. Use txdb to create tx2gene for Human Genome :: 

	txdb <-makeTxDbFromGFF("GRCh37_latest_genomic.gff.gz")
	k <- keys(txdb, keytype = "GENEID")
	df <- select(txdb, keys = k,  columns = "TXNAME", keytype = "GENEID")
	tx2gene <- df[, 2:1]
	head(tx2gene)
	write.csv(tx2gene, 'tx2gene.csv')
