#!/bin/bash -ue
mkdir -p ./test_output/abricate/
abricate --db resfinder SRR31122807.gbk > test_output/abricate/SRR31122807_abricate_results.txt
