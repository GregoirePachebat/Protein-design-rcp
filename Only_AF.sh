#!/bin/bash

### NOTE: Adjusted to work without Slurm. No SBATCH settings needed.

export ALPHAFOLD_DIR=/home/cdarbell/alphafold
export ALPHAFOLD_DATADIR="/work/scitas-share/datasets/AlphaFold_Datasets/Databases"
export TMP=/tmp/af_run

# Make sure directories exist
mkdir -p $TMP
mkdir -p AF_current_job

### Run AlphaFold
output_dir=$TMP/output
mkdir -p $output_dir

# Get the fasta files
fasta_dir="AF_current_job"
fasta_paths=$(find "$fasta_dir" -name "*.fa" -type f -printf "%p," | sed 's/,$//')

echo "INFO: output_dir=$output_dir"

# Run AlphaFold
python3 ${ALPHAFOLD_DIR}/run_singularity.py \
    --use_gpu \
    --data_dir=${ALPHAFOLD_DATADIR} \
    --fasta_paths="${fasta_paths[@]}" \
    --output_dir=$output_dir \
    --max_template_date=2020-05-14 \
    --model_preset=monomer \
    --db_preset=reduced_dbs

echo "INFO: AlphaFold returned $?"

# Copy Alphafold output back to AF_current_job
mkdir Output-$TMP
cp -R $output_dir/* Output-$TMP/

# Clear the AF_current job directory
rm -rf $fasta_dir/*
