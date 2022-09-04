DIROUT="/home/lsilva/IKMB/projects/skin.mgwas/results/10.2d.rnaseq/1.nfrnaseq/results"
#Fix path

mkdir -p $DIROUT

rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/10.2d.rnaseq/1.nfrnaseq/results/star_salmon/salmon.merged.* $DIROUT/star_salmon
rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/10.2d.rnaseq/1.nfrnaseq/results/star_salmon/deseq2_qc $DIROUT/star_salmon
rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/10.2d.rnaseq/1.nfrnaseq/results/multiqc $DIROUT
rsync -avh sukmb447@medcluster.medfdm.uni-kiel.de:/work_ifs/sukmb447/projects/skin.mgwas/results/10.2d.rnaseq/1.nfrnaseq/results/pipeline_info $DIROUT

