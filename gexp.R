library("edgeR")



files <- c("a1.counts.txt","a2.counts.txt","b1.counts.txt", "b2.counts.txt")

group = factor(c(rep("A", 2), rep("B",2)) )
dge  <- readDGE(files,header=FALSE, group =group)

dge

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
et <- exactTest(dge, pair=c("A","B"))
etp <- topTags(et, n= 100000, adjust.method="BH", sort.by="PValue", p.value = 1)

write.csv(countsPerMillion, "cpm_A_Bcsv")
 
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


write.csv(etp$table, "dge_A_B.csv")




#-----
pdf("volcano_A_B.pdf")
res <- etp$table
with(res, plot(logFC, -log10(PValue), pch=20, main="A vs B", xlim=c(-12,12)))

# Add colored points: red if FDR<0.05, orange of log2FC>1, green if both)
with(subset(res, FDR<.05 ), points(logFC, -log10(PValue), pch=20, col="red"))
with(subset(res, abs(logFC)>1), points(logFC, -log10(PValue), pch=20, col="orange"))
with(subset(res, FDR<.05 & abs(logFC)>1), points(logFC, -log10(PValue), pch=20, col="green"))
dev.off()
#------


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






























