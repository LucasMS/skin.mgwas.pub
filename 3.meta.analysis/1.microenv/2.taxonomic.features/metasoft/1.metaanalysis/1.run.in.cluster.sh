mkdir -p /work_ifs/sukmb447/projects/skin.mgwas/results/3.meta.analysis/1.microenv/2.taxonomic.features/metasoft/1.metaanalysis/meta/log/
sbatch --array=1-183%20 metasoft.slurm
#sbatch --array=1-3 sel.eval.slurm
