#!/bin/bash

## this script quantifies transcript expression using salmon
## it assumes 00_setup_download_preprocess.sh has already been run successfully
## is also assumes you will be running this on an lsf cluster
ROOT_DIR=$1
LOG_DIR=$2
RNASEQ_DIRNAME=$3

# ROOT_DIR="/app/"
# LOG_DIR="/app/logs/"
# RNASEQ_DIRNAME="GEO_Submission_Bitler"


##################
## set up directories
##################

IN_DIR=${ROOT_DIR}/${RNASEQ_DIRNAME}/fastq_trimmed/
INDEX_DIR=${ROOT_DIR}/index/Homo_sapiens/long_index/
OUT_DIR=${ROOT_DIR}/${RNASEQ_DIRNAME}/salmon_quant/

mkdir -p $OUT_DIR


##################
## run salmon on all trimmed fastq files
##################

quant_script=${ROOT_DIR}/scripts/quant.sh
for fastq_file in ${IN_DIR}/*R1*.fastq.gz
do
    sample_id=$(basename ${fastq_file})
    sample_id=${sample_id:0:${#sample_id}-20}

    echo running: ${sample_id}

    CURR_OUT_DIR=${OUT_DIR}/${sample_id}
    if [ ! -d ${CURR_OUT_DIR} ]; then
        mkdir -p ${CURR_OUT_DIR}
    fi


    ${quant_script} ${IN_DIR} ${INDEX_DIR} ${CURR_OUT_DIR} ${sample_id}

done
