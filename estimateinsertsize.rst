Here, we estimate the insert size using bbmap by aligning 1 million reads to the reference genome, pretty enough for a good estimation. The output histogram will be written to histmap1mtxt::
 
   ./bbmap.sh -Xmx50g  in1=Sread1.fastq.gz in2=Sread2.fastq.gz ihist=histmap1m.txt reads=1000000 ref=human_genome.fa

