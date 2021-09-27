FILENAME='make.id.for.cluster'
DIROUT='/home/lsilva/IKMB/projects/skin.mgwas/results/2.statistical.tests/2.taxonomic.features/'
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
# Transfer rarefied to microbiome data folder
rsync -ahv /home/lsilva/IKMB/projects/skin.mgwas/results/1.data.harmonization/3.microbiome.harmonized/phyloseq.rarefied.rds $DIROUT/microbiome.data

cd $DIROUT

mkdir log


rsync -avh ./ sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/2.statistical.tests/2.taxonomic.features/
