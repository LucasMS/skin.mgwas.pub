#!/usr/bin/env bash
#SBATCH -c 2
#SBATCH --mem=4gb
#SBATCH --output='/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis/meta/log/%A_%a.out'

cd $SLURM_SUBMIT_DIR

# Set variables
DIROUT='/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis/meta'
DIRIN='/work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis/prepare'
FILE=$(ls ${DIRIN}/meta${SLURM_ARRAY_TASK_ID}.test*.txt)

# Make scratch dir

export ScratchDir=/tmp/sukmb447/job${SLURM_ARRAY_TASK_ID}
mkdir -p $ScratchDir


# Run command
bash run.metasoft.sh $FILE $ScratchDir

echo "calculations done!"

# Copy back to isilon
cd $ScratchDir
cp -r ./* $DIROUT/

echo "Files transfered!"

#rm scrath

rm -r $ScratchDir/

echo "Scratch cleaned!"

