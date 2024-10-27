#!/bin/bash

# Ensure a config.yaml is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <config.yaml>"
    exit 1
fi

CONFIG_FILE=$1

# Activate conda environment
source ~/Protein-design-rcp/miniconda3/etc/profile.d/conda.sh
conda activate SE3nv2.0

# Create job-specific output directories
JOB_ID=$(date +%s)  # Use timestamp as a job ID for uniqueness
RESULTS_DIR="Results/output_PID-$JOB_ID"
mkdir -p $RESULTS_DIR

# Navigate to the pipeline code directory
cd pipeline_code

# Run RFdiffusion and ProteinMPNN using the provided config file
echo "Running RFdiffusion and ProteinMPNN..."
python main.py "../$CONFIG_FILE"

# Run AlphaFold using Only_AF.sh
cd ..
chmod +x Only_AF.sh
./Only_AF.sh $RESULTS_DIR

# Move output files to the job-specific directory
mv pipeline_code/RFdiffusion_tmp_output $RESULTS_DIR/RFdiffusion_pdbs
mv pipeline_code/Sequences/seqs $RESULTS_DIR/sequences
mv Output-$JOB_ID/* $RESULTS_DIR/AF_output

# Clean up temporary files
rm -rf pipeline_code/Sequences
rm -rf Output-$JOB_ID

# Final message
echo "Pipeline complete. Results are stored in $RESULTS_DIR"
