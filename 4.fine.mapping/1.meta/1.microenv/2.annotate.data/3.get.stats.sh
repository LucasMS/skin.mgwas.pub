FILENAME='statistics.on.snps'
DIROUT='/home/lsilva/IKMB/projects/skin.mgwas/results/4.fine.mapping/1.meta/1.microenv/2.annotate.data/combined'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT"
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"
