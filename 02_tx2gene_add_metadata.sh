#!/bin/bash

## this script converts transcript to gene abundance
## and adds metadata information
## 2 files are written
## 1) gene abundance (RDs)
## 2) transcript abundance (RDS)

ROOT_DIR=$1
RNASEQ_DIRNAME=$2

# ROOT_DIR="/app/"
# RNASEQ_DIRNAME="GEO_Submission_Bitler"


##################
## set up directories
##################

QUANT_DIR=${ROOT_DIR}/${RNASEQ_DIRNAME}/salmon_quant/
OUT_DIR=${ROOT_DIR}/${RNASEQ_DIRNAME}/salmon_quant_processed/

mkdir -p ${OUT_DIR}

##################
## process and write out files
##################
process_script=${ROOT_DIR}/scripts/tximeta_process.R
Rscript ${process_script} ${QUANT_DIR} ${OUT_DIR}