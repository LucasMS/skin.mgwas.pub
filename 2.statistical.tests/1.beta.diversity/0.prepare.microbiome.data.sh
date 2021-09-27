FILENAME='prepare.microbiome.data'
DIROUT='/home/lsilva/IKMB/projects/skin.mgwas/results/2.statistical.tests/1.beta.diversity/microbiome.data'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT" -p


for index in `seq 1 6`
do
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out='${DIROUT}', index='${index}'))"
done
