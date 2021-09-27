DIROUT="/work_ifs/sukmb447/projects/skin.mgwas/results/10.2d.rnaseq/1.nfrnaseq"

mkdir $DIROUT -p

cd $DIROUT


module load singularity
module load nextflow/21.03.0-edge
module load graphviz

nextflow run nf-core/rnaseq \
      --input /work_ifs/sukmb447/projects/skin.mgwas/results/10.2d.rnaseq/0.prepare.data/rna.sample.sheet.csv \
      --genome GRCh37 \
      -profile ccga_med \
      -resume
