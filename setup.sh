#!/bin/bash

# Update pip
pip install --upgrade pip

# Change to the pipeline code directory
cd pipeline_code

# Miniconda3 Installation -----------------------------------------------------------------------------------
# Download and install Miniconda for the user in their home directory
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
echo "Installing Miniconda to ~/Protein-design-rcp/miniconda3"
bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/Protein-design-rcp/miniconda3

# Source the conda.sh to use conda commands
source ~/Protein-design-rcp/miniconda3/etc/profile.d/conda.sh

# Remove the install script
rm -rf Miniconda3-latest-Linux-x86_64.sh

# Initialize and update conda
conda init bash
eval "$(conda shell.bash hook)"
conda update -y conda

# Create and activate the SE3 environment for RFdiffusion
conda create -n SE3nv2.0 python=3.9 -y
conda activate SE3nv2.0

# Install dependencies required by RFdiffusion and AlphaFold
conda install -c conda-forge cudatoolkit=11.3 cudnn=8.2 -y
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
pip install -r https://raw.githubusercontent.com/deepmind/alphafold/main/requirements.txt

# Install other required Python packages
pip install spython yaml absl-py

# RFdiffusion Installation ---------------------------------------------------------------------------------
cd ~/Protein-design-rcp/pipeline_code
git clone https://github.com/RosettaCommons/RFdiffusion.git
cd RFdiffusion
mkdir models && cd models

# Download RFdiffusion model weights
wget http://files.ipd.uw.edu/pub/RFdiffusion/6f5902ac237024bdd0c176cb93063dc4/Base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/e29311f6f1bf1af907f9ef9f44b8328b/Complex_base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/60f09a193fb5e5ccdc4980417708dbab/Complex_Fold_base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/74f51cfb8b440f50d70878e05361d8f0/InpaintSeq_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/76d00716416567174cdb7ca96e208296/InpaintSeq_Fold_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/5532d2e1f3a4738decd58b19d633b3c3/ActiveSite_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/12fc204edeae5b57713c5ad7dcb97d39/Base_epoch8_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/f572d396fae9206628714fb2ce00f72e/Complex_beta_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/1befcb9b28e2f778f53d47f18b7597fa/RF_structure_prediction_weights.pt

# Install RFdiffusion
cd ..
pip install -e .

# Install SE(3)-Transformer for RFdiffusion ----------------------------------------------------------------
cd ~/Protein-design-rcp/pipeline_code
git clone https://github.com/FabianFuchsML/se3-transformer-public.git
cd se3-transformer-public
pip install -e .

# ProteinMPNN Installation ---------------------------------------------------------------------------------
cd ~/Protein-design-rcp/pipeline_code
git clone https://github.com/dauparas/ProteinMPNN.git

# Install ProteinMPNN requirements
cd ProteinMPNN
pip install -r requirements.txt

# AlphaFold Installation -----------------------------------------------------------------------------------
cd ~/Protein-design-rcp
git clone https://github.com/deepmind/alphafold.git
cd alphafold
pip install -r requirements.txt

# Prepare output directories in the project directory ------------------------------------------------------
mkdir -p ~/Protein-design-rcp/Results ~/Protein-design-rcp/AF_current_job

# Final message
echo "Setup complete. Miniconda installed, environments created, and dependencies installed."
