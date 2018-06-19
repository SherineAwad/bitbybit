==============================
**RNASeq Gene Expressions** 
==============================

See Salmon quantifications section

In Progress 
---------------

We need to write R script. 
Lets first declare our libraries ::

  library(tximport)
  library(rjson)
  library(readr)
  library("edgeR")
  library(biomaRt)
  library(dplyr)
  library("AnnotationDbi")
  library("org.Hs.eg.db")
  library(magrittr)
  library(pathview)
  library(gage)
  library(gageData)
  library(data.table) 

Now, lets read salmon quantifications files ::
 
  samples <- read.table(file.path("/home/sherine/work/rnaseq/kaz", "samples.txt"), header = FALSE)
  files <- file.path("/home/sherine/work/rnaseq", "kaz", samples$V1, "quant.sf")
  print ('Files are :')
  print (files)
  names(files) <- paste0("sample", 1:20) 

Lets convert salmon transcripts to gene names using NCBItx2gene.csv. See :ref:`txtogene` for how to generate this file :: 

  tx2gene <- read.csv(file.path("/home/sherine/work/rnaseq/kaz", "NCBItx2gene.csv"))
  txi <- tximport(files, type = "salmon", tx2gene = tx2gene,ignoreTxVersion = TRUE, lengthCol=length)
  cts <- txi$counts
  write.csv(cts, "counts.csv")
 
We define our groups and create our DGEList :: 
 
  group = factor(c(rep("Control", 10), rep("Tumor",10)) )
  dge = DGEList(counts=cts, genes= rownames(data), group=group)
  countsPerMillion <- cpm(dge)
  summary(countsPerMillion)
  countCheck <- countsPerMillion > 1
  summary(countCheck) 

Filtering :: 
  
  keep <- which(rowSums(countCheck) >= 2)
  dge <- dge[keep,]
  summary(cpm(dge))

Calculate expressions, see this interesting post about the CPM, RPKM , and FPKM differences `<https://www.rna-seqblog.com/rpkm-fpkm-and-tpm-clearly-explained/>`__ ::
 
  dge <- calcNormFactors(dge, method="TMM")
  summary(dge)
  dge <- estimateCommonDisp(dge)
  dge <- estimateTagwiseDisp(dge)
  dge <- estimateTrendedDisp(dge)
  et <- exactTest(dge, pair=c("Control", "Tumor")) 

Note that here we can filter using pvalues, but if you plan to use Gage for pathways, Gage takes all the data with no filter as a background otherwise you will get lots of nulls:: 
 
  etp <- topTags(et, n= 100000, adjust.method="BH", sort.by="PValue", p.value = 1)

If you plan to use xcells for RNAseq deconvolution, xcell requires RPKM instead of CPM, so use :: 

  length = txi$length
  dge = DGEList(counts=cts, genes= rownames(data), group=group)
  dge <- calcNormFactors(dge, method="TMM")
  summary(dge)
  rpkm = rpkm(dge, length)
  write.csv(rpkm, "rpkm.csv")
