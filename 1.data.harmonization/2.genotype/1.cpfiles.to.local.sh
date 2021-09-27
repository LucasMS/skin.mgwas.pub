DIROUT="/home/lsilva/IKMB/projects/skin.mgwas/results/1.data.harmonization/2.genotype"

mkdir $DIROUT

#cp harmonized genotypes

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/kora.popgen/PopGen_and_KORA.harmonized* ${DIROUT}/

#cp PCA

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/kora.popgen.pca/*pca* ${DIROUT}/

# cp MAF

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/kora.popgen.maf/*MAF* ${DIROUT}/
