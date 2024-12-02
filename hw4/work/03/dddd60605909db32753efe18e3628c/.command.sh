#!/bin/bash -ue
mkdir -p ./test_output/abricate/
abricate --db resfinder SRR31122808.gbk > test_output/abricate/SRR31122808_abricate_results.txt
