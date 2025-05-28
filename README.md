# Context
- These scripts are simplified versions of ones used for another ongoing project, the code is only partially tested
    - You can safely ignore everything that refers to `["mlm", "pre", "olmes", "llama", "RoBERTa", "alpaca","checkpoints"]`
- They are taylored to the slurm cluster's specs and probably won't run elswhere
- If you need any libraries not installed in the docker container, see below
# Setup
1. `git clone ...`
1. Copy (and complete) `.env_template` to  `.env`
1. Fill in various access tokens (hugginface (if using private or gated repos), wandb for logging (probably optional))
# Running
- Store full gradient
    - `sbatch slurm_docker.sbatch allenai/OLMo-2-1124-7B-SFT allenai/tulu-3-sft-mixture 0 train[0%:1%] sft store`

- Random Projection (TRAK)
    - `sbatch slurm_docker.sbatch allenai/OLMo-2-1124-7B-SFT allenai/tulu-3-sft-mixture 0 train[0%:1%] sft store --random_projection`


# Parellelizing
The hugginface dataset api allows slices in split names (e.g.:  `train[0%:10%]`, `train[123:1235]`).
And all scripts were designed with this in mind. So simply:
- run `[f"sbatch ... train[i%:i+1%] ..." for i in range(0,100)]`, in a notebook (then submit on shell or automate)

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