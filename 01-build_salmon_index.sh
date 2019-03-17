#!/bin/bash

# Build Salmon transcriptome indices

# the directory that will hold the indices for every organism, we'll store
# each organism in its own directory
mkdir index

#### Homo sapiens --------------------------------------------------------------
mkdir index/Homo_sapiens

# short
salmon index \
  -t data/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz \
  -i index/Homo_sapiens/short_index \
  -k 23

# long
salmon index \
  -t data/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz \
  -i index/Homo_sapiens/long_index \
  -k 31

#### Mus musculus --------------------------------------------------------------
mkdir index/Mus_musculus

# short
salmon index \
  -t data/cdna/Mus_musculus.GRCm38.cdna.all.fa.gz \
  -i index/Mus_musculus/short_index \
  -k 23

# long
salmon index \
  -t data/cdna/Mus_musculus.GRCm38.cdna.all.fa.gz \
  -i index/Mus_musculus/long_index \
  -k 31

#### Danio rerio ---------------------------------------------------------------
mkdir index/Danio_rerio

# short
salmon index \
  -t data/cdna/Danio_rerio.GRCz11.cdna.all.fa.gz \
  -i index/Danio_rerio/short_index \
  -k 23

# long
salmon index \
  -t data/cdna/Danio_rerio.GRCz11.cdna.all.fa.gz \
  -i index/Danio_rerio/long_index \
  -k 31

#### Canis familiaris ---------------------------------------------------------
mkdir index/Canis_familiaris

# short
salmon index \
  -t data/cdna/Canis_familiaris.CanFam3.1.cdna.all.fa.gz \
  -i index/Canis_familiaris/short_index \
  -k 23

# long
salmon index \
  -t data/cdna/Canis_familiaris.CanFam3.1.cdna.all.fa.gz \
  -i index/Canis_familiaris/long_index \
  -k 31
