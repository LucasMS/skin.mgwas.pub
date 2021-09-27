#!/usr/bin/env bash
#SBATCH -c 9
#SBATCH --mem=20gb
#SBATCH --output=/work_ifs/sukmb447/projects/skin.mgwas/results/2.statistical.tests/2.taxonomic.features/log/%A_%a.out

cd $SLURM_SUBMIT_DIR
module load miniconda3
source activate /work_ifs/sukmb447/apps/conda3.envs/r.taxmgwas/

#print host name
hostname

# Get global parameters
outputfolder=${SLURM_SUBMIT_DIR}"/results"
# run R
Rscript test.R $SLURM_ARRAY_TASK_ID $outputfolder

# sbatch --array=1-4 run.analyse.slurm

