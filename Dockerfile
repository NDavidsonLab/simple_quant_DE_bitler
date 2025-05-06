FROM rocker/tidyverse:4.5.0
MAINTAINER ccdl@alexslemonade.org
WORKDIR /rocker-build/

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install dialog apt-utils -y

RUN apt-get install -y curl ; curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | bash

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    build-essential \
    libxml2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libmariadb-dev-compat \
    libpq-dev \
    libssh2-1-dev \
    pandoc \
    libmagick++-dev \
    time

# scater and scran need updated rlang
RUN R -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/rlang/rlang_1.1.5.tar.gz')"

RUN apt update && apt install -y dirmngr curl bash
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    rjson \
    ggpubr \
    Rtsne \
    png

RUN R -e "BiocManager::install(c('ensembldb', 'DESeq2', 'qvalue', 'org.Hs.eg.db', 'org.Mm.eg.db', 'ComplexHeatmap', 'ConsensusClusterPlus', 'scran', 'scater', 'tximeta'), update = FALSE)" 

# Install R packages from github and urls
# Need most updated version of tximport so AlevinQC will install later
RUN R -e "devtools::install_github('mikelove/tximport', ref = 'b5b5fe11b0093b4b2784f982277b2aa66d2607f7')"
RUN R -e "devtools::install_github('const-ae/ggsignif', ref = 'aadd9d44a360fc35fc3aef4b0fcdfdb7e1768d27')"
RUN R -e "devtools::install_github('csoneson/alevinQC', ref = '6ca73b1744cbd969036f80b7c7dddbe7d1cf99ee', dependencies = TRUE)"

# colorblind friendly palettes
RUN R -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/colorspace/colorspace_2.1-0.tar.gz')"
RUN R -e "devtools::install_github('clauswilke/colorblindr', ref = '1ac3d4d62dad047b68bb66c06cee927a4517d678', dependencies = TRUE)"

# FastQC
RUN apt update && apt install -y fastqc

ENV PACKAGES="git gcc make g++ libboost-all-dev liblzma-dev libbz2-dev ca-certificates zlib1g-dev curl unzip autoconf"

ENV SALMON_VERSION=1.10.1

# salmon binary will be installed in /home/salmon/bin/salmon
# don't modify things below here for version updates etc.

WORKDIR /home

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean

# Apt doesn't have the latest version of cmake, so install it using their script.
# RUN apt remove cmake cmake-data -y

RUN apt-get install -y cmake cmake-data

# RUN wget --quiet https://github.com/Kitware/CMake/releases/download/v3.5.0/cmake-3.5.0-Linux-x86_64.sh && \
#     mkdir /opt/cmake && \
#     sh cmake-3.5.0-Linux-x86_64.sh --prefix=/opt/cmake --skip-license && \
#     sudo ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

# # salmon
# RUN curl -k -L https://github.com/COMBINE-lab/salmon/archive/refs/tags/v${SALMON_VERSION}.tar.gz -o salmon-v${SALMON_VERSION}.tar.gz && \
#     tar xzf salmon-v${SALMON_VERSION}.tar.gz && \
#     cd salmon-${SALMON_VERSION} && \
#     mkdir build && \
#     cd build && \
#     cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local && make && make install

# # fastp 
# RUN git clone https://github.com/OpenGene/fastp.git
# RUN cd fastp && \
#     make && \
#     sudo make install

RUN apt-get install -y salmon fastp


WORKDIR /home

# allow installing pip into the system b/c it's a docker image
RUN rm /usr/lib/python3.12/EXTERNALLY-MANAGED

# MultiQC
RUN apt update && apt install -y python3 python3-pip
RUN pip3 install multiqc
