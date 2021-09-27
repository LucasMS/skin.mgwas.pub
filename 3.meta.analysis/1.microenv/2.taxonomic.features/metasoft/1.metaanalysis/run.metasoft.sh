#!/bin/bash


module load miniconda3
source activate /work_ifs/sukmb447/apps/conda3.envs/r.taxmgwas/

# Variables
VAR=$1
DIROUT=$2
INDEX=$(echo $VAR | awk -F/ '{print $NF}' | cut -d'.' -f 4,5)
OUTFILE=$(echo $VAR | awk -F/ '{print $NF}' | cut -d'.' -f 1-5)
METASOFTDIR='/work_ifs/sukmb447/apps/Metasoft'

pwd -P | echo
cd $METASOFTDIR

java -Xms2g -Xmx4g -jar $METASOFTDIR/Metasoft.jar -input $VAR -output ${DIROUT}/${OUTFILE}.txt -pvalue_table $METASOFTDIR/HanEskinPvalueTable.txt -mvalue -log ${DIROUT}/${OUTFILE}.log


