#!/bin/bash

## this script sets up everything for salmon quantification
## 1) downloads and validates the raw fastq files
## 2) runs fastp for Qc and trimming
## 3) downloads HG38 reference files
## 3) builds salmon index
## it also assumes you will be running this on an lsf cluster

ROOT_DIR=$1
LOG_DIR=$2
RNASEQ_DIRNAME=$3

# ROOT_DIR="/app/"
# LOG_DIR="/app/logs/"
# RNASEQ_DIRNAME="GEO_Submission_Bitler"


##################
## set up directories
##################

IN_DIR=${ROOT_DIR}/${RNASEQ_DIRNAME}/fastq_files/
TRIM_DIR=${ROOT_DIR}/${RNASEQ_DIRNAME}/fastq_trimmed/
QC_DIR=${ROOT_DIR}/${RNASEQ_DIRNAME}/fastp_out/

##################
## run fastp on all raw files
##################

fastp_script=${ROOT_DIR}/scripts/pre_quant_qc.sh
for fastq_file in ${IN_DIR}/*R1.fastq.gz
do
    sample_id=$(basename ${fastq_file})
    sample_id=${sample_id:0:${#sample_id}-12}

    # only run it if we haven't done it before
    JSON_OUT=${QC_DIR}/${SAMPLE_ID}_fastp.json
    if [ ! -s ${JSON_OUT} ]; then
        echo running: $sample_id

        sh ${fastp_script} ${IN_DIR} ${TRIM_DIR} ${QC_DIR} ${sample_id}
    fi

done

cd ${QC_DIR}
multiqc .
cd -

##################
# download references to make index
# download scripts heavily inspired by
# https://github.com/AlexsLemonade/training-txome-prep
##################

## download reference data if not available
# first fasta
cdna_dir=${ROOT_DIR}/data/cdna
mkdir -p ${cdna_dir}

if [ ! -s ${cdna_dir}/Homo_sapiens.GRCh38.cdna.all.fa.gz ]; then
    wget --directory-prefix=${cdna_dir} ftp://ftp.ensembl.org/pub/release-95/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz
fi

# now get gtfs
gtf_dir=${ROOT_DIR}/data/gtf
mkdir -p ${gtf_dir}
if [ ! -s ${gtf_dir}/Homo_sapiens.GRCh38.95.gtf ]; then
    wget --directory-prefix=${gtf_dir} ftp://ftp.ensembl.org/pub/release-95/gtf/homo_sapiens/Homo_sapiens.GRCh38.95.gtf.gz
    gunzip ${gtf_dir}/*
fi

## now if both succeeded build the index

index_dir=${ROOT_DIR}/index/Homo_sapiens
mkdir -p ${index_dir}

if [ ! -s ${index_dir}/long_index/ref_k31_fixed.fa ] && [ -s ${cdna_dir}/Homo_sapiens.GRCh38.cdna.all.fa.gz ] ; then
    # use long kmers
    salmon index \
        -t ${cdna_dir}/Homo_sapiens.GRCh38.cdna.all.fa.gz \
        -i ${index_dir}/long_index \
        -k 31
fi

## now run the tx2gene
tx2gene_dir=${ROOT_DIR}/tx2gene
mkdir -p ${tx2gene_dir}

Rscript ${ROOT_DIR}/scripts/get_tx2gene.R \
  --gtf_file ${gtf_dir}/Homo_sapiens.GRCh38.95.gtf \
  --output_file ${tx2gene_dir}/Homo_sapiens.GRCh38.95_tx2gene.tsv