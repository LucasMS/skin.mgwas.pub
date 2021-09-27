FILENAME='prepare.sample.sheet'
DIROUT='/home/lsilva/IKMB/projects/skin.mgwas/results/10.2d.rnaseq/0.prepare.data/'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT" -p
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"


cd $DIROUT

rsync -avh ./ sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/10.2d.rnaseq/0.prepare.data/
