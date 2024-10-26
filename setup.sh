#!/bin/bash

# Update pip and install Miniconda
pip install --upgrade pip

# Download and install Miniconda for the user
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
rm -f Miniconda3-latest-Linux-x86_64.sh

# Set up the environment variables for Miniconda
export PATH="$HOME/miniconda3/bin:$PATH"
source $HOME/miniconda3/etc/profile.d/conda.sh

# Initialize conda and update
conda init bash
eval "$(conda shell.bash hook)"
conda update -y conda

# Move into the pipeline_code directory
cd pipeline_code

# Create and activate the SE3 environment
conda env create -f SE3nv-cuda11.7.yml
conda activate SE3nv2.0

# Clone and set up RFdiffusion
git clone https://github.com/RosettaCommons/RFdiffusion.git
cd RFdiffusion
mkdir models && cd models

# Download RFdiffusion models
wget http://files.ipd.uw.edu/pub/RFdiffusion/6f5902ac237024bdd0c176cb93063dc4/Base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/e29311f6f1bf1af907f9ef9f44b8328b/Complex_base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/60f09a193fb5e5ccdc4980417708dbab/Complex_Fold_base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/74f51cfb8b440f50d70878e05361d8f0/InpaintSeq_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/76d00716416567174cdb7ca96e208296/InpaintSeq_Fold_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/5532d2e1f3a4738decd58b19d633b3c3/ActiveSite_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/12fc204edeae5b57713c5ad7dcb97d39/Base_epoch8_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/f572d396fae9206628714fb2ce00f72e/Complex_beta_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/1befcb9b28e2f778f53d47f18b7597fa/RF_structure_prediction_weights.pt

# Return to RFdiffusion directory and install it
cd ..
pip install -e .

# Add other dependencies to the environment
pip install spython
pip install yaml
pip install absl-py

# Set up SE3 Transformer environment within RFdiffusion
cd env/SE3Transformer
pip install --no-cache-dir -r requirements.txt
python setup.py install
cd ../.. # back to RFdiffusion root

# Return to pipeline_code directory
cd ..

# Prepare output directories
mkdir -p $HOME/Protein-design-rcp/Results $HOME/Protein-design-rcp/AF_current_job

# Final message
echo "Setup complete. Miniconda installed, RFdiffusion dependencies installed, and environment configured."
