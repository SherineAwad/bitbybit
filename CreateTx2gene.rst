========================================
**Annotation using tx2gene and txdb **
========================================


1. Download your annotated GFF file, here, we download Refseq annotated GRCh37::

	wget ftp://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.gff.gz	

2. Use txdb to create tx2gene:: 

	txdb <-makeTxDbFromGFF("GRCh37_latest_genomic.gff.gz")
	k <- keys(txdb, keytype = "GENEID")
	df <- select(txdb, keys = k,  columns = "TXNAME", keytype = "GENEID")
	tx2gene <- df[, 2:1]
	head(tx2gene)
	write.csv(tx2gene, 'tx2gene.csv')
