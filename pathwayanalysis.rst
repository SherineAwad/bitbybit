================================================
**Pathway Analysis for RNASeq and Microarrays**
================================================ 

Some ID conversion to entrezid needed by KEGG::

	data(kegg.sets.hs)
	data(sigmet.idx.hs)
	kegg.sets.hs = kegg.sets.hs[sigmet.idx.hs]
	head(kegg.sets.hs, 3)
	foldchanges = res$logFC
	names(foldchanges) = res$entrez
	write.csv((names(foldchanges)), "namefolds.csv")
	keggres = gage(foldchanges, gsets=kegg.sets.hs, same.dir=TRUE)
	lapply(keggres, head)

Get 10 upregulated pathways::

	keggrespathwaysup = data.frame(id=rownames(keggres$greater), keggres$greater) %>%
  	tbl_df() %>%
  	filter(row_number()<=10) %>%
  	.$id %>%
  	as.character()

And get the downregulated ::

	keggrespathwaysdn = data.frame(id=rownames(keggres$less), keggres$less) %>%
  	tbl_df() %>%
  	filter(row_number()<=10) %>%
  	.$id %>%
  	as.character()


	keggresidsup = substr(keggrespathwaysup, start=1, stop=8)
	keggresidsup
	keggresidsdn = substr(keggrespathwaysdn, start=1, stop=8)
	data(go.sets.hs)
	data(go.subs.hs)
	gobpsets = go.sets.hs[go.subs.hs$BP]
	gobpres = gage(foldchanges, gsets=gobpsets, same.dir=TRUE)
	lapply(gobpres, head)

Let's define plotting function for applying later::

	plot_pathway = function(pid) pathview(gene.data=foldchanges,gene.idtype="ENTREZID", pathway.id=pid, species="hsa", new.signature=FALSE)

Then finally, plot the pathways::

	tmpup = sapply(keggresidsup, function(pid) pathview(gene.data=foldchanges,gene.idtype="ENTREZID", pathway.id=pid, species="hsa"))
	tmpdn = sapply(keggresidsdn, function(pid) pathview(gene.data=foldchanges,gene.idtype="ENTREZID", pathway.id=pid, species="hsa"))
