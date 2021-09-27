FILENAME='retrieve.snps.and.genes'
DIROUT='/home/lsilva/IKMB/projects/skin.mgwas/results/4.fine.mapping/1.meta/1.microenv/2.annotate.data/genes.snps'
###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT" -p

for INDEX in {1..31}
do
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}', index = '${INDEX}'))"
done

# Check if all run

cd $DIROUT

ls *.tsv | cut -f1 -d "."|sort|uniq -c
ls *.tsv | cut -f1 -d "."|sort|uniq -c | wc -l

