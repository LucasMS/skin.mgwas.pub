FILENAME='make.id.for.cluster'
DIROUT='/home/lsilva/IKMB/projects/skin.mgwas/results/2.statistical.tests/1.beta.diversity/'
FUNCTION='/home/lsilva/IKMB/projects/skin.mgwas/scripts/functions/DBF_test-master/DBF_test.R'

###
INPUT=${FILENAME}'.Rmd'
OUTPUT=${FILENAME}'.html'
FIGPATH=${DIROUT}'/'${FILENAME}'/'
mkdir "$DIROUT" -p
R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc');rmarkdown::render('${INPUT}', output_file='${DIROUT}/${OUTPUT}', params = list(FIGPATH='${FIGPATH}', d.out = '${DIROUT}'))"

# Transfer files

rsync -avh ./*.slurm $DIROUT
rsync -avh ./*.sh $DIROUT
rsync -avh ./*.R $DIROUT
rsync -avh ${FUNCTION} $DIROUT

cd $DIROUT

mkdir log


rsync -avh ./ sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/2.statistical.tests/1.beta.diversity
