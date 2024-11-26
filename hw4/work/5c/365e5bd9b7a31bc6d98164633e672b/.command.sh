#!/bin/bash -ue
mkdir -p ./test_output/quast/SRR31122807/
quast.py -o ./test_output/quast/SRR31122807 scaffolds.fasta
