# Context
- These scripts are simplified versions of ones used for another ongoing project and were (for the most part) provided to me by `loris3`.
    - You can safely ignore everything that refers to `["mlm", "pre", "olmes", "llama", "RoBERTa", "alpaca","checkpoints"]`
- They are taylored to the slurm cluster's specs and probably won't run elswhere
- If you need any libraries not installed in the docker container, see below
# Setup
1. `git clone ...`
1. Complete the `.env` file info by filling in the HF token and WANDB key.
# Running (examples)
- Store full gradient
    - `sbatch slurm_docker.sbatch allenai/OLMo-2-1124-7B-SFT allenai/tulu-3-sft-mixture 0 train[0%:1%] sft store`

- Random Projection (TRAK)
    - `sbatch slurm_docker.sbatch allenai/OLMo-2-1124-7B-SFT daryna3325/sampled-tulu-1000 0 train sft store --random_projection 204800 normal`

The projection type is either `normal` or `rademacher`, the latter is default. 
The argument before the projection type is the dimension of the projection. Default is 16384.

You can view all the arguments (incl. the time limit for a job) in the slurm_docker.sbatch file. 
# Parellelizing
The hugginface dataset api allows slices in split names (e.g.:  `train[0%:10%]`, `train[123:1235]`).
And all scripts were designed with this in mind. So simply:
- run `[f"sbatch ... train[i%:i+1%] ..." for i in range(0,100)]`, in a notebook (then submit on shell or automate)

Or create a dataset sample and push it to HF so that you can use it directly.
(There are 12 suitable GPUs in the cluster)

# Docker Container Setup
    This is only needed if you need to install new packages not contined in requirements.txt!

 1. Edit `requirements.txt`
 1. Install Docker Desktop locally, and the Docker extension in VSCode
 1. Right-click on (the file) `Dockerfile` -> `Build Image`
 1. In the Docker tab: Right-click on the image you created -> `Push...`
    - You probably have to log in to the Docker hub (and create an account)
    - Expect about 7GB upload size
 1. Update the image url in `slurm_docker.sbatch`
