#!/usr/bin/env bash
#SBATCH -c 2
#SBATCH --mem=8gb
#SBATCH --output=/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/1.beta.diversity/1.metaanalysis/log/%A_%a.out

cp /work_ifs/sukmb447/projects/skin.mgwas/scripts/3.meta.analysis/1.microenv/1.beta.diversity/1.metaanalysis/run.metal.sh /work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/1.beta.diversity/1.metaanalysis
cd /work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/1.beta.diversity/1.metaanalysis

if [ $SLURM_ARRAY_TASK_ID == 1 ]
then
bash run.metal.sh 12
else
echo $SLURM_ARRAY_TASK_ID
fi


if [ $SLURM_ARRAY_TASK_ID == 2 ]
then
bash run.metal.sh 36
else
echo $SLURM_ARRAY_TASK_ID
fi


if [ $SLURM_ARRAY_TASK_ID == 3 ]
then
bash run.metal.sh 45
else
echo $SLURM_ARRAY_TASK_ID
fi
