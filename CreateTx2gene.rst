========================================
**Transcripts to Genes**
========================================

.. _txtogene:

How to convert from transcripts to Genes ids
----------------------------------------------


Mouse Genome Example using TxDb.Mmusculus.UCSC
################################################# 

Let install TxDb.Mmusculus.UCSC.mm10.knownGene, to use knowngene conventions :: 

  source("https://bioconductor.org/biocLite.R")
  biocLite("TxDb.Mmusculus.UCSC.mm10.knownGene")


or to use ensemble conventions :: 

  source("https://bioconductor.org/biocLite.R") 
  biocLite("TxDb.Mmusculus.UCSC.mm10.ensGene")

Then in our R script we need to include tximport library :: 

  library(tximport)


Then we can use this script for conversion :: 

  library(TxDb.Mmusculus.UCSC.mm10.ensGene)
  txdb <- TxDb.Mmusculus.UCSC.mm10.ensGene
  k <- keys(txdb, keytype = "GENEID")
  df <- select(txdb, keys = k,  columns = "TXNAME", keytype = "GENEID")
  tx2gene <- df[, 2:1]
  head(tx2gene)
  write.csv(tx2gene, 'tx2gene.csv')


A Human Genome Example using makeTxDbFromGFF  
################################################


Let download your annotated GFF file, here, we download Refseq annotated GRCh37::

        wget ftp://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.gff.gz


Then use txdb to create tx2gene for Human Genome :: 

	txdb <-makeTxDbFromGFF("GRCh37_latest_genomic.gff.gz")
	k <- keys(txdb, keytype = "GENEID")
	df <- select(txdb, keys = k,  columns = "TXNAME", keytype = "GENEID")
	tx2gene <- df[, 2:1]
	head(tx2gene)
	write.csv(tx2gene, 'tx2gene.csv')
