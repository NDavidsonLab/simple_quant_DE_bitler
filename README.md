# Salmon transcriptome index preparation

This repository is intended to document how Salmon transcriptome indices are generated for RNA-seq and scRNA-seq training modules.
Currently, this corresponds to our 2019 Houston workshop.

We run all scripts in the Docker container for training (introduced here: [AlexsLemonade/RNA-Seq-Exercises](https://github.com/AlexsLemonade/RNA-Seq-Exercises/pull/22)).
_Note: `optparse` is not installed on that Docker image but is required to generate the tx2gene files._
