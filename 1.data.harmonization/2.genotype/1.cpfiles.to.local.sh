DIROUT="/home/lsilva/IKMB/projects/skin.mgwas/results/1.data.harmonization/2.genotype"

mkdir $DIROUT
mkdir $DIROUT/kora.popgen
mkdir $DIROUT/kora.popgen.pca
mkdir $DIROUT/kora.popgen.maf

#cp harmonized genotypes

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/1.data.harmonization/2.genotype/kora.popgen/PopGen_and_KORA.harmonized* ${DIROUT}/kora.popgen

#cp PCA

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/1.data.harmonization/2.genotype/kora.popgen.pca/*pca* ${DIROUT}/kora.popgen.pca

# cp MAF

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/1.data.harmonization/2.genotype/kora.popgen.maf/*MAF* ${DIROUT}/kora.popgen.maf
