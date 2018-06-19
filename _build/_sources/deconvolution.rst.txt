=============================================
**RNA Deconvolution** 
=============================================

      
In progress 
-------------


In theory, it is possible to infer the immune, tumor and stroma cell content of a  solid tumor from its bulk gene expression profile if reference gene expression profiles can be established for each tumor-associated cell type. 


Mathematically, this class of inverse problems is known as deconvolution. 

Deconvolution methods tend to work better with microarray data, it's one of the few areas where microarrays are still better. 

The reason is that signals from different cell-types/tissues will sum more linearly in microarrays than RNAseq, where the sum is highly non-linear. This allows for cleaner component separation  





We will use xCell from `<http://xcell.ucsf.edu/>`__ 


And take a look to this notebook `<https://github.com/SherineAwad/mynotebooks/blob/master/deconv.ipynb>`__  
