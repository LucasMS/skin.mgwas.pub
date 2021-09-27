#!/usr/bin/env bash
#SBATCH -c 8
#SBATCH --mem=16gb
#SBATCH --output=/work_ifs/sukmb447/projects/skin.mgwas/results/2.statistical.tests/1.beta.diversity/log/%A_%a.out

cd $SLURM_SUBMIT_DIR
module load miniconda2/4.6.14
source activate /work_ifs/sukmb447/apps/conda.envs/r.betamgwas

# Get global parameters
outputfolder=${SLURM_SUBMIT_DIR}"/results"
# run R
Rscript test.R $SLURM_ARRAY_TASK_ID $outputfolder

# sbatch --array=1-4 run.analyse.slurm

