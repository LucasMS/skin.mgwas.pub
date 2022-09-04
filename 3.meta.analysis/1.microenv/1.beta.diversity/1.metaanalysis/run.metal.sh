# Variables
VAR=$1
f1=${VAR:0:1}
f2=${VAR:1:2}
DIROUT='./indexes'${VAR}

mkdir ${DIROUT}

cd ${DIROUT}



# Make new file

newfile="metal.instructions"
touch $newfile
echo 'MARKER snp.name' >> $newfile
echo 'ALLELE A B' >> $newfile
echo 'PVALUELABEL P' >> $newfile
echo 'EFFECT effect' >> $newfile
echo 'WEIGHTLABEL n' >> $newfile
echo 'SEPARATOR  WHITESPACE' >> $newfile
echo 'SCHEME SAMPLESIZE' >> $newfile
echo 'GENOMICCONTROL OFF' >> $newfile
echo 'VERBOSE ON' >> $newfile
echo 'PROCESS ../index'${f1}'.comb.betatests.txt' >> $newfile

echo 'MARKER snp.name' >> $newfile
echo 'ALLELE A B' >> $newfile
echo 'PVALUELABEL P' >> $newfile
echo 'EFFECT effect' >> $newfile
echo 'WEIGHTLABEL n' >> $newfile
echo 'SEPARATOR  WHITESPACE' >> $newfile
echo 'SCHEME SAMPLESIZE' >> $newfile
echo 'GENOMICCONTROL OFF' >> $newfile
echo 'VERBOSE ON' >> $newfile
echo 'PROCESS ../index'${f2}'.comb.betatests.txt' >> $newfile

## Add overlap for 36
if [ $VAR == 36 ]
then
echo 'OVERLAP ON' >> $newfile
fi

echo 'ANALYZE HETEROGENEITY' >> $newfile
echo 'QUIT' >> $newfile


/work_ifs/sukmb447/apps/generic-metal/metal metal.instructions
