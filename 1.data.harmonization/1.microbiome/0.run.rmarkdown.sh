DIROUT='/home/lsilva/IKMB/projects/skin.mgwas/results/1.data.harmonization/1.microbiome'
mkdir "$DIROUT" -p

###

for FILENAME in select.filter.kora select.filter.popgen merge.and.filter.microbiome
do
 INPUT=${FILENAME}'.Rmd'
 OUTPUT=${FILENAME}'.html'
 FIGPATH=${DIROUT}'/'${FILENAME}'/'
 R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"
done
