#!/bin/bash

# Ensure a results directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <results_directory>"
    exit 1
fi

RESULTS_DIR=$1

# Set environment variables for AlphaFold
export ALPHAFOLD_DIR="/home/$USER/alphafold"
export ALPHAFOLD_DATADIR="/work/scitas-share/datasets/AlphaFold_Databases"  # Adjust this if necessary
export TMP=$(mktemp -d)

# Check environment variables
echo "INFO: ALPHAFOLD_DIR=$ALPHAFOLD_DIR"
echo "INFO: ALPHAFOLD_DATADIR=$ALPHAFOLD_DATADIR"
echo "INFO: TMP=$TMP"

# Define output directory for AlphaFold run
output_dir="$TMP/output"
mkdir -p $output_dir

# Get the fasta files from the provided results directory
fasta_dir="$RESULTS_DIR/AF_current_job"
fasta_paths=$(find "$fasta_dir" -name "*.fa" -type f -printf "%p," | sed 's/,$//')

echo "INFO: Output directory for AlphaFold: $output_dir"

# Run AlphaFold
python3 ${ALPHAFOLD_DIR}/run_singularity.py \
    --use_gpu \
    --data_dir=${ALPHAFOLD_DATADIR} \
    --fasta_paths="${fasta_paths}" \
    --output_dir=$output_dir \
    --max_template_date=2020-05-14 \
    --model_preset=monomer \
    --db_preset=reduced_dbs

# Check if AlphaFold returned successfully
echo "INFO: AlphaFold returned $?"

# Copy AlphaFold output to the results directory
mkdir -p $RESULTS_DIR/AF_output
cp -R $output_dir $RESULTS_DIR/AF_output

# Clean up temporary directory
rm -rf $TMP

# Final message
echo "AlphaFold run complete. Output saved to $RESULTS_DIR/AF_output"
