#!/bin/bash -ue
mkdir -p ./test_output/fastqc/SRR31122808/
fastqc SRR31122808_1.fastq.gz SRR31122808_2.fastq.gz -o test_output/fastqc/SRR31122808/
