#!/usr/bin/env bash
#SBATCH -c 6
#SBATCH --mem=30gb
#SBATCH --output='/work_ifs/sukmb447/projects/skin.mgwas/results/5.plot.all.ps/log/%A_%a.out'

cd $SLURM_SUBMIT_DIR

module load miniconda3
source activate /work_ifs/sukmb447/apps/conda3.envs/r.taxmgwas/

FILENAME='get.min.ps'
DIROUT='/work_ifs/sukmb447/projects/skin.mgwas/results/5.plot.all.ps/'

###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'

R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"

