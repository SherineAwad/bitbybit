===================================
**RNASeq Tutorial**
===================================


Download Data
##################

Prepare a directory:: 

       mkdir rnaseq  
       cd rnaseq 

A yeast RNASeq sample can be fully downloaded here:: 

        curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR594/008/SRR5945808/SRR5945808.fastq.gz

As a short cut, we can use a sample of this data for a quick download/running time which is a 40000 subset of the SRR5945808.fastq.gz (Recommended)::
        
        

And let's download the yeast reference genome::

        wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Saccharomyces_cerevisiae/Ensembl/R64-1-1/Saccharomyces_cerevisiae_Ensembl_R64-1-1.tar.gz
        gunzip Saccharomyces_cerevisiae_Ensembl_R64-1-1.tar.gz 


Trimming Adapters and Quality Filtering
##########################################

We can use trim_glore to trim adapters and quality filter reads. First for simplicity, lets create two folders for galore and fastq::

    mkdir galore
    mkdir fastqc

Then, we can use trim_galore from trimming adapters and quality filtering::

        trim_galore --gzip --retain_unpaired --trim1  --fastqc --fastqc_args "--outdir fastqc" -o galore  sample.fastq 


Alignment to Reference
###########################

We will need to use a splice aware aligner like STAR, or BBMap. Lets use BBMap::

        bbmap.sh in=galore/rna_trimmed.fq.gz   ref=yeast.fa  path= yeastBBMapIndex out=sample.bbmap.bam 



Feature Counts
###################

Here we use featureCounts to get the counts::

        featureCounts -t exon -g gene_id -a  Saccharomyces_cerevisiae_Ensembl_R64-1-1/genes.gtf -o sample.tmp.txt sample.bbmap.bam -s 2;)
        tail -n +3 sample.tmp.txt |cut -f1,7- >sample.counts.txt


Gene Expression using EdgeR 
###############################


To install edgeR package, start R and enter::

        source("http://bioconductor.org/biocLite.R")
        biocLite("edgeR")


## The full script can be found here [this script](https://raw.githubusercontent.com/SherineAwad/BitByBit/master/gexpr.R):

```
        curl -L -O https://raw.githubusercontent.com/SherineAwad/BitByBit/master/gexpr.R
        Rscript --no-save gexpr.R
```

        
Now, lets read the counts::

        files <- c("a1.counts.txt","a2.counts.txt","b1.counts.txt", "b2.counts.txt")

        group = factor(c(rep("A", 2), rep("B",2)) )
        dge  <- readDGE(files,header=FALSE, group =group)
        dge

Lets calculate CPM::

        countsPerMillion <- cpm(dge)
        summary(countsPerMillion)
        countCheck <- countsPerMillion > 1
        summary(countCheck)
        write.csv(countsPerMillion, "cpm_A_B.csv")
Lets do some filtering::

        keep <- which(rowSums(countCheck) >= 2)

Now, we can calculate the dge::

        dge <- dge[keep,]
        summary(cpm(dge))
        dge <- calcNormFactors(dge, method="TMM")
        dge <- estimateCommonDisp(dge)
        dge <- estimateTagwiseDisp(dge)
        dge <- estimateTrendedDisp(dge)
        et <- exactTest(dge, pair=c("A","B"))
        etp <- topTags(et, n= 100000, adjust.method="BH", sort.by="PValue", p.value = 1)
        write.csv(etp$table, "dge_A_B.csv")

Now, we can do some plotting::

        labels=c("A1", "A2", "B1", "B2")
        pdf("MA_A_B.pdf")
        plot(
                etp$table$logCPM,
                etp$table$logFC,
                xlim=c(-3, 20), ylim=c(-12, 12), pch=20, cex=.3,
                col = ifelse( etp$table$FDR < 0.2, "black", "red" ) )
        dev.off()

        pdf("MDS_A_B.pdf")
        plotMDS(dge, labels=labels)
        dev.off()


        pdf("volcano_A_B.pdf")
        res <- etp$table
        with(res, plot(logFC, -log10(PValue), pch=20, main="A vs B", xlim=c(-12,12)))

        # Add colored points: red if FDR<0.05, orange of log2FC>1, green if both)
        with(subset(res, FDR<.05 ), points(logFC, -log10(PValue), pch=20, col="red"))
        with(subset(res, abs(logFC)>1), points(logFC, -log10(PValue), pch=20, col="orange"))
        with(subset(res, FDR<.05 & abs(logFC)>1), points(logFC, -log10(PValue), pch=20, col="green"))
        dev.off()


        pdf("A_B_heatmap.pdf")
        logCPM = countsPerMillion
        o = rownames(etp$table[abs(etp$table$logFC)>1 & etp$table$PValue<0.05, ])
        logCPM <- logCPM[o[1:25],]
        colnames(logCPM) = labels
        logCPM <- t(scale(t(logCPM)))
        require("RColorBrewer")
        require("gplots")
        myCol <- colorRampPalette(c("dodgerblue", "black", "yellow"))(25)
        myBreaks <- seq(-3, 3, length.out=26)
        heatmap.2(logCPM, col=myCol, breaks=myBreaks,symkey=F, Rowv=TRUE,Colv=TRUE, main="A vs B", key=T, keysize=0.7,scale="none",trace="none", dendrogram="both", cexRow=0.7, cexCol=0.9, density.info="none",margin=c(10,9), lhei=c(2,10), lwid=c(2,6),reorderfun=function(d,w) reorder(d, w, agglo.FUN=mean),  distfun=function(x) as.dist(1-cor(t(x))), hclustfun=function(x) hclust(x, method="ward.D2"))
        dev.off()


