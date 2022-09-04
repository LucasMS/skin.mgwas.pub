FILENAME='make.data.for.pleiotropy.table'
DIROUT='/home/lsilva/IKMB/projects/skin.mgwas/results/9.MR'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT"
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"
