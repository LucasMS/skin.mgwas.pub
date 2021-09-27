#!/usr/bin/env bash
#SBATCH -c 6
#SBATCH --mem=42gb
#SBATCH --output='/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/1.beta.diversity/2.gather.and.filter/log/%A_%a.out'

cd $SLURM_SUBMIT_DIR

module load miniconda3
source activate /work_ifs/sukmb447/apps/conda3.envs/r.taxmgwas/

FILENAME='gather.and.filter.meta'
DIROUT='/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/1.beta.diversity/2.gather.and.filter'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT" -p
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"
