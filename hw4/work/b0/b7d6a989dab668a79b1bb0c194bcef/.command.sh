#!/bin/bash -ue
mkdir -p ./test_output/prokka/SRR31122807/
prokka --force -o ./test_output/prokka/SRR31122807 --prefix SRR31122807 scaffolds.fasta --genus 'Escherichia'
