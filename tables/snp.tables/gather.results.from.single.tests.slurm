#!/usr/bin/env bash
#SBATCH -c 6
#SBATCH --mem=30gb
#SBATCH --output='/work_ifs/sukmb447/projects/skin.mgwas/results/tables/snp.tables/log/%A_%a.out'

cd $SLURM_SUBMIT_DIR

module load miniconda3
source activate /work_ifs/sukmb447/apps/conda3.envs/r.taxmgwas/

FILENAME='gather.results.from.single.tests'
DIROUT='/work_ifs/sukmb447/projects/skin.mgwas/results/tables/snp.tables/'

###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'

R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"
