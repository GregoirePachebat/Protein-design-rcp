import yaml
from run_models import RunRFdiffusion, RunProteinMPNN
import os
import sys

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python main.py <config.yaml>")
        sys.exit(1)

    config_file = sys.argv[1]

    RunRFdiffusion(config_file)
    RunProteinMPNN(config_file)
