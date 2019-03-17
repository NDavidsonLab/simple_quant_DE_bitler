#!/bin/bash

# If we want to use tximport (and we do!), we need a mapping between transcripts
# and genes

# make a directory to hold these tsv files
mkdir tx2gene

# all gtf files are in the same directory
gtf_directory=data/gtf

# Homo sapiens
Rscript scripts/get_tx2gene.R \
  --gtf_file ${gtf_directory}/Homo_sapiens.GRCh38.95.gtf \
  --output_file tx2gene/Homo_sapiens.GRCh38.95_tx2gene.tsv

# Mus musculus
Rscript scripts/get_tx2gene.R \
  --gtf_file ${gtf_directory}/Mus_musculus.GRCm38.95.gtf \
  --output_file tx2gene/Mus_musculus.GRCm38.95_tx2gene.tsv

# Danio rerio
Rscript scripts/get_tx2gene.R \
  --gtf_file ${gtf_directory}/Danio_rerio.GRCz11.95.gtf \
  --output_file tx2gene/Danio_rerio.GRCz11.95_tx2gene.tsv

# Canis familiaris
Rscript scripts/get_tx2gene.R \
  --gtf_file ${gtf_directory}/Canis_familiaris.CanFam3.1.95.gtf \
  --output_file tx2gene/Canis_familiaris.CanFam3.1.95_tx2gene.tsv
