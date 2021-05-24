================================
**Installation Guide**
================================


.. _set_rvtests: 

rvtests 
-----------------
Install rvtests from `<https://github.com/zhanxw/rvtests>`__ :: 

  git clone https://github.com/zhanxw/rvtests

.. _set_lncscore:

lncScore
------------------
Install lncScore `<https://www.nature.com/articles/srep34838>`__ ::

    wget https://github.com/WGLab/lncScore/archive/v1.0.2.tar.gz
    tar -xzvf v1.0.2.tar.gz



.. _set_trimgalore:

Trimgalore 
---------------------

Install Trimgalore `<https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/>`__ :: 

   conda install -c bioconda trim-galore 

.. _set_cutadapt: 

Cutadapt
--------------------

Install Cutadapt `<http://cutadapt.readthedocs.io/en/stable/installation.html>`__ :: 

    conda install -c bioconda cutadapt


.. _set_fastqc: 

FastQC 
-----------------

Install FastQC `<https://www.bioinformatics.babraham.ac.uk/projects/fastqc/>`__ :: 

   conda install -c bioconda fastqc 


.. _set_bbmap: 

BBMap
---------------

Lets downlowd BBMap source :: 
 
  wget https://sourceforge.net/projects/bbmap/files/BBMap_38.07.tar.gz

Then lets unzip the files :: 

  tar -xzvf BBMap_38.07.tar.gz 

    
BBMap scripts are ready to use in bbmap directory :: 

  cd bbmap 


.. _set_vcftools: 

vcftools
------------------

We will use conda :: 

  conda install vcftools

.. _set_plink: 

Plink
---------------

::

  conda install -c biobuilds plink 

.. _set_samtools:


Samtools
----------

:: 
  
  conda install -c bioconda samtools 


.. _set_salmon: 

Salmon 
-------------

::

  conda install salmon 


.. _set_tophat: 

Tophat 
------------

:: 
  
  conda install -c bioconda tophat 

