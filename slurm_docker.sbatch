#!/bin/bash
# script name: extract_gradients.sh
#SBATCH --container-image=loris3/cuda:latest  
#SBATCH --container-mount-home 
#SBATCH --mem=128G 
#SBATCH --cpus-per-task=24  
#SBATCH --gres=gpu:1
#SBATCH --time=0-1:00:00 
#SBATCH --container-workdir=/srv/home/users/kalinchukd23cs/gradient_dimensionality_reduction_dap
#SBATCH --nodelist=dgx-h100-em2

python3 --version


RANDOM_PROJ=""

if [ "$7" == "--random_projection" ]; then
    RANDOM_PROJ="--random_projection"
    # Check if 9th argument is provided for projection type
    if [ -n "$9" ]; then
        PROJ_TYPE_ARG="--proj_type=$9"
    fi
fi

python3 extract_gradients.py $1 $2 $3 --dataset_split=$4 --paradigm=$5 --mode=$6 $RANDOM_PROJ --proj_dim=$8 $PROJ_TYPE_ARG --gradients_per_file=1000