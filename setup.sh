#!/bin/bash

# Update pip and install Miniconda
pip install --upgrade pip

# Download and install Miniconda for the user
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
source $HOME/miniconda3/etc/profile.d/conda.sh
rm -f Miniconda3-latest-Linux-x86_64.sh

# Initialize conda and update
conda init
conda update -y conda

# Move into the pipeline_code directory
cd pipeline_code

# Create and activate the SE3 environment
conda env create -f SE3nv-cuda11.7.yml
source activate SE3nv2.0  # use 'source activate' for reliability in non-interactive scripts

# Clone and set up RFdiffusion
git clone https://github.com/RosettaCommons/RFdiffusion.git
cd RFdiffusion
mkdir models && cd models
wget -q http://files.ipd.uw.edu/pub/RFdiffusion/*_ckpt.pt
cd ..
pip install -e .
cd ..

# Clone and set up ProteinMPNN
git clone https://github.com/dauparas/ProteinMPNN.git

# AlphaFold Setup (excluding databases)
cd ..
git clone https://github.com/deepmind/alphafold.git
cd alphafold
pip install -r requirements.txt
# Note: Skipping the download of the AlphaFold databases as they are assumed to be available in the provided directory.

# Prepare output directories
cd $HOME/Protein-design-rcp
mkdir -p Results AF_current_job

# Final message
echo "Setup complete. Miniconda installed, environments created, and dependencies installed."
