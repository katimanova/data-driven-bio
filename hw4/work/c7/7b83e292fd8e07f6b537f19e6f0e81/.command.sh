#!/bin/bash -ue
mkdir -p ./test_output/spades/SRR31122808/
spades.py -1 SRR31122808_1.fastq.gz -2 SRR31122808_2.fastq.gz -o test_output/spades/SRR31122808/
