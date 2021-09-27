#!/usr/bin/env bash
#SBATCH -c 9
#SBATCH --mem=36gb
#SBATCH --output='/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis/prepare/log/%A_%a.out'

cd $SLURM_SUBMIT_DIR

module load miniconda3
source activate /work_ifs/sukmb447/apps/conda3.envs/r.taxmgwas/

FILENAME='prepare.data'
DIROUT='/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis/prepare'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT" -p
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"
