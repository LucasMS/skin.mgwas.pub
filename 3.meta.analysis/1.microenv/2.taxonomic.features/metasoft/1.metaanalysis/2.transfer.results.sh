DIROUT='/home/lsilva/IKMB/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis'

mkdir -p $DIROUT

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis/prepare/meta.indices.rds $DIROUT &&

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis/prepare/prepare.data.html $DIROUT &&

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis/prepare/lambda.estimates.tsv $DIROUT
