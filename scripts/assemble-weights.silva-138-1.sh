# This workflow script contains all commands required to generate the
# taxonomic weights found in readytowear/data/silva_138/*/
# Uncomment the last line of this script to delete temporary files.

# move your current working directory to readytowear/ or alter this line
pdir=.
# set this to available memory in GB / 20 (rounded down) (or 1 if you have < 20 GB)
njobs=12

# I'm going with this as of 20220302. Check it each time you run it using
# qiime clawback summarize-Qiita-metadata-category-and-contexts --p-category empo_3 --o-visualization qiita-contexts.qzv
context=Deblur_2021.09-Illumina-16S-V4-150nt-ac8c0b

cdir=$pdir/data/silva_138_1/
mkdir $cdir
mkdir $cdir/full_length/
mkdir $cdir/515f-806r/

tmp=$cdir/tmp/
mkdir $tmp

## Create Reference Data
$pdir/scripts/get-silva.sh


## Download Sample Data
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Animal distal gut' \
  --p-metadata-value 'animal distal gut' \
  --o-samples $tmp/animal-distal-gut.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Animal surface' \
  --o-samples $tmp/animal-surface.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-value 'Animal secretion' \
  --p-metadata-key empo_3 \
  --o-samples $tmp/animal-secretion.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Water (non-saline)' \
  --p-metadata-value 'water (non-saline)' \
  --o-samples $tmp/water-non-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Animal proximal gut' \
  --o-samples $tmp/animal-proximal-gut.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Animal corpus' \
  --p-metadata-value 'animal corpus' \
  --o-samples $tmp/animal-corpus.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Plant rhizosphere' \
  --o-samples $tmp/plant-rhizosphere.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Water (saline)' \
  --p-metadata-value 'water (saline)' \
  --o-samples $tmp/water-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Sediment (saline)' \
  --p-metadata-value 'sediment (saline)' \
  --o-samples $tmp/sediment-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Sediment (non-saline)' \
  --o-samples $tmp/sediment-non-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Plant corpus' \
  --o-samples $tmp/plant-corpus.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Plant surface' \
  --o-samples $tmp/plant-surface.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Surface (saline)' \
  --o-samples $tmp/surface-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context $context \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Soil (non-saline)' \
  --o-samples $tmp/soil-non-saline.qza &
for type in stool oral
do
  {
  if [ $type == 'stool' ]
  then
    redbiom search metadata "where host_taxid==9606 and (sample_type=='stool' or sample_type=='Stool')" > $tmp/${type}_sample_ids
  else
    redbiom search metadata "where host_taxid==9606 and sample_type in ('Oral', 'oral', 'Mouth', 'mouth', 'Saliva', 'saliva')" > $tmp/${type}_sample_ids
  fi
  redbiom fetch samples \
    --from $tmp/${type}_sample_ids \
    --context $context \
    --output $tmp/${type}_samples.biom
  qiime tools import \
    --type FeatureTable[Frequency] \
    --input-path $tmp/${type}_samples.biom \
    --output-path $tmp/human-$type.qza
 } &
done

# dirty secret:
# this script is currently failing for human-oral and animal-secretion
# because of https://github.com/biocore/redbiom/issues/117
# the workaroud is to do the above step by hand and to grep out
# any sample ids that end with '.raw'.

## wait for the downloads to finish
wait

## Build Weights
$pdir/scripts/build-weights-silva-138-1.sh

#rm -r $tmp/
