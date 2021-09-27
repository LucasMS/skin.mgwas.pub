#!/usr/bin/env bash
#SBATCH -c 4
#SBATCH --mem=16gb
#SBATCH --output='/work_ifs/sukmb447/projects/skin.mgwas/results/2.statistical.tests/1.beta.diversity/log/%A_%a.out'

cd $SLURM_SUBMIT_DIR

module load miniconda3
source activate /work_ifs/sukmb447/apps/conda3.envs/r.taxmgwas/

FILENAME='gather.results'
DIROUT='/work_ifs/sukmb447/projects/skin.mgwas/results/2.statistical.tests/1.beta.diversity/'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT" -p
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"
