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

You can then use this script for gene expression `gexp <gexpr.R>`_



Gene Expression using EdgeR 
###############################


To install edgeR package, start R and enter::

        source("http://bioconductor.org/biocLite.R")
        biocLite("edgeR")


Let's write R script::

        group = factor(c(rep("baseline", 2), rep("agematched",2)) )
        files <- c("base1.counts.txt","base2.counts.txt","age1.counts.txt", "age2.counts.txt")
        dge  <- readDGE(files,header=FALSE, group =group)

        countsPerMillion <- cpm(dge)
        summary(countsPerMillion)
        countCheck <- countsPerMillion > 1 
        summary(countCheck)
        keep <- which(rowSums(countCheck) >= 2)
        dge <- dge[keep,]
        summary(cpm(dge))
        dge <- calcNormFactors(dge, method="TMM")
        dge <- estimateCommonDisp(dge)
        dge <- estimateTagwiseDisp(dge)
        dge <- estimateTrendedDisp(dge)
        et <- exactTest(dge, pair=c("baseline", "agematched")) 
        etp <- topTags(et, n= 100000, adjust.method="BH", sort.by="PValue", p.value = 1)

Let's save the cpm counts and the expressions::

        write.csv(countsPerMillion, "star_cpm_BL_Age.csv") 
        write.csv(etp$table, "star_dge_BL_Age.csv")

Let's do some plotting::

        labels=c("BL1", "BL2", "AGE1", "AGE2")
        pdf("star_MA_BL_Age.pdf")
        plot(
        etp$table$logCPM,
        etp$table$logFC,
        xlim=c(-3, 20), ylim=c(-12, 12), pch=20, cex=.3,
         col = ifelse( etp$table$FDR < .2, "black", "red" ) )
        dev.off()
        pdf("star_MDS_BL_Age.pdf")
        plotMDS(dge, labels=labels)
        dev.off()


