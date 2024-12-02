#!/bin/bash -ue
mkdir -p ./test_output/quast/SRR31122808/
quast.py -o ./test_output/quast/SRR31122808 scaffolds.fasta
