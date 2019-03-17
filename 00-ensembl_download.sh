#!/bin/bash

# We'll use this shell script to obtain the cDNA FASTAs from Ensembl

# create a directory to hold the FASTA files
cdna_directory=data/cdna
mkdir -p ${cdna_directory}

# wget for the following organisms: human, mouse, zebrafish, dog
wget --directory-prefix=${cdna_directory} ftp://ftp.ensembl.org/pub/release-95/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz
wget --directory-prefix=${cdna_directory} ftp://ftp.ensembl.org/pub/release-95/fasta/mus_musculus/cdna/Mus_musculus.GRCm38.cdna.all.fa.gz
wget --directory-prefix=${cdna_directory} ftp://ftp.ensembl.org/pub/release-95/fasta/danio_rerio/cdna/Danio_rerio.GRCz11.cdna.all.fa.gz
wget --directory-prefix=${cdna_directory} ftp://ftp.ensembl.org/pub/release-95/fasta/canis_familiaris/cdna/Canis_familiaris.CanFam3.1.cdna.all.fa.gz

# now we'll do the GTF files -- we need these to generate the tx2gene mapping
# for use with tximport
gtf_directory=data/gtf
mkdir ${gtf_directory}

# wget for the following organisms: human, mouse, zebrafish, dog
wget --directory-prefix=${gtf_directory} ftp://ftp.ensembl.org/pub/release-95/gtf/homo_sapiens/Homo_sapiens.GRCh38.95.gtf.gz
wget --directory-prefix=${gtf_directory} ftp://ftp.ensembl.org/pub/release-95/gtf/mus_musculus/Mus_musculus.GRCm38.95.gtf.gz
wget --directory-prefix=${gtf_directory} ftp://ftp.ensembl.org/pub/release-95/gtf/danio_rerio/Danio_rerio.GRCz11.95.gtf.gz
wget --directory-prefix=${gtf_directory} ftp://ftp.ensembl.org/pub/release-95/gtf/canis_familiaris/Canis_familiaris.CanFam3.1.95.gtf.gz
gunzip ${gtf_directory}/*
