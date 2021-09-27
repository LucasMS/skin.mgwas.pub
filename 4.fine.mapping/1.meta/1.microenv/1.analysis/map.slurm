#!/usr/bin/env bash
#SBATCH -c 1
#SBATCH --mem=4gb
#SBATCH --output=/work_ifs/sukmb447/projects/skin.mgwas/results/4.fine.mapping/1.meta/1.microenv/1.analysis/log/%A_%a.out
#SBATCH --time=100:00:00

cd $SLURM_SUBMIT_DIR

#SLURM_ARRAY_TASK_ID=7
# Set paths
INDEX="/work_ifs/sukmb447/projects/skin.mgwas/results/4.fine.mapping/1.meta/1.microenv/1.analysis/paths.txt"
WORKDIR=$(head -${SLURM_ARRAY_TASK_ID} $INDEX | tail -1)
INPUTDIR=${WORKDIR}"/input"
TEMPDIR=${WORKDIR}"/temp"
OUTPUTDIR=${WORKDIR}"/results"
PLINK="/work_ifs/sukmb447/projects/skin.mgwas/kora.popgen.pca/PopGen_and_KORA.harmonized.all"
GENOME="/work_ifs/sukmb447/apps/locus.db/locuszoom_hg19.db"
# beta string to decide what to run
BETA='typebeta'
#use fnemapping onlylocus branch
FINEMAP='/work_ifs/sukmb447/apps/finemapping.onlylocus/finemapping/main.nf' 


# Get finemap files
cd $WORKDIR
mkdir $TEMPDIR


# Run pipeline
cd $TEMPDIR

module load nextflow singularity
# For beta results, do not perform finemapping but only plot the zoom plot
if [[ "$INPUTDIR" == *"$BETA"* ]]
then
#Only locus plot
nextflow run $FINEMAP -profile standard --locus ${INPUTDIR}/chunks.olap --snps ${INPUTDIR}/snps.sorted --reference ${PLINK} --sumstats ${INPUTDIR}/summary.tsv --nsum 597 --nsignal 1 --method sss --output ${TEMPDIR}/results  --locuszoomdb ${GENOME} --onlylocus
else
# Run finemapping and plot the zoom
nextflow run $FINEMAP -profile standard --locus ${INPUTDIR}/chunks.olap --snps ${INPUTDIR}/snps.sorted --reference ${PLINK} --sumstats ${INPUTDIR}/summary.tsv --nsum 597 --nsignal 1 --method sss --output ${TEMPDIR}/results  --locuszoomdb ${GENOME}
fi



# Cleaning
mv ${TEMPDIR}/results/PopGen_and_KORA.harmonized/*/ $OUTPUTDIR/ &&
rm -rf $TEMPDIR

# cp
cp $OUTPUTDIR/*_*_*/*.pdf $WORKDIR/
