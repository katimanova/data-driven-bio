#!/bin/bash -ue
mkdir -p ./test_output/prokka/SRR31122808/
prokka --force -o ./test_output/prokka/SRR31122808 --prefix SRR31122808 scaffolds.fasta --genus 'Escherichia'
