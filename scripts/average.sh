# This workflow script contains all commands required to generate 
# the average weights in gg_13_8 gtdb_r89 silva_132

# move your current working directory to readytowear/ or alter this line
pdir=.

cdir=$pdir/data/

for ddir in gg_13_8 gtdb_r89 silva_138 silva_138_1
do
  for dddir in 515f-806r full_length
  do
    pushd $pdir/data/$ddir/$dddir
    qiime feature-table merge \
      --p-overlap-method average \
      --i-tables animal-corpus.qza \
      --i-tables animal-distal-gut.qza \
      --i-tables animal-proximal-gut.qza \
      --i-tables animal-secretion.qza \
      --i-tables animal-surface.qza \
      --i-tables plant-corpus.qza \
      --i-tables plant-rhizosphere.qza \
      --i-tables plant-surface.qza \
      --i-tables sediment-non-saline.qza \
      --i-tables sediment-saline.qza \
      --i-tables soil-non-saline.qza \
      --i-tables surface-saline.qza \
      --i-tables water-non-saline.qza \
      --i-tables water-saline.qza \
      --o-merged-table average.qza
    popd
  done
done
