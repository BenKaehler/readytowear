# This workflow script contains all commands required to generate the
# taxonomic weights found in readytowear/data/silva_138/*/
# Uncomment the last line of this script to delete temporary files.

# move your current working directory to readytowear/ or alter this line
pdir=.
# set this to available memory in GB / 20 (rounded down) (or 1 if you have < 20 GB)
njobs=3

cdir=$pdir/data/silva_138/
mkdir $cdir
mkdir $cdir/full_length/
mkdir $cdir/515f-806r/

tmp=$cdir/tmp/
mkdir $tmp

## Download Reference Data
wget https://data.qiime2.org/2020.11/common/silva-138-99-seqs.qza -O $cdir/full_length/ref-seqs.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-tax.qza -O $cdir/full_length/ref-tax.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-nb-classifier.qza -O $cdir/full_length/uniform-classifier.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-seqs-515-806.qza -O $cdir/515f-806r/ref-seqs.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-tax-515-806.qza -O $cdir/515f-806r/ref-tax.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-515-806-nb-classifier.qza -O $cdir/515f-806r/uniform-classifier.qza

## Download Sample Data
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Animal distal gut' \
  --p-metadata-value 'animal distal gut' \
  --o-samples $tmp/animal-distal-gut.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Animal surface' \
  --o-samples $tmp/animal-surface.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-value 'Animal secretion' \
  --p-metadata-key empo_3 \
  --o-samples $tmp/animal-secretion.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Water (non-saline)' \
  --p-metadata-value 'water (non-saline)' \
  --o-samples $tmp/water-non-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Animal proximal gut' \
  --o-samples $tmp/animal-proximal-gut.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Animal corpus' \
  --p-metadata-value 'animal corpus' \
  --o-samples $tmp/animal-corpus.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Plant rhizosphere' \
  --o-samples $tmp/plant-rhizosphere.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Water (saline)' \
  --p-metadata-value 'water (saline)' \
  --o-samples $tmp/water-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Sediment (saline)' \
  --p-metadata-value 'sediment (saline)' \
  --o-samples $tmp/sediment-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Sediment (non-saline)' \
  --o-samples $tmp/sediment-non-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Plant corpus' \
  --o-samples $tmp/plant-corpus.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Plant surface' \
  --o-samples $tmp/plant-surface.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
  --p-metadata-key empo_3 \
  --p-metadata-value 'Surface (saline)' \
  --o-samples $tmp/surface-saline.qza &
qiime clawback fetch-Qiita-samples \
  --p-context Deblur-Illumina-16S-V4-150nt-780653 \
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
    --context Deblur-Illumina-16S-V4-150nt-780653\
    --output $tmp/${type}_samples.biom
  qiime tools import \
    --type FeatureTable[Frequency] \
    --input-path $tmp/${type}_samples.biom \
    --output-path $tmp/human-$type.qza
 } &
done

## wait for the downloads to finish
wait

## Build Weights
for ddir in 515f-806r full_length
do
  tdir=$cdir/$ddir
  habitats=(
    animal-distal-gut
    animal-surface
    animal-secretion
    water-non-saline
    animal-proximal-gut
    animal-corpus
    plant-rhizosphere
    water-saline
    sediment-saline
    sediment-non-saline
    plant-corpus
    plant-surface
    surface-saline
    soil-non-saline
    human-stool
    human-oral
  )
  for habitat in "${habitats[@]}"
  do
    qiime clawback sequence-variants-from-samples \
      --i-samples $tmp/$habitat.qza \
      --o-sequences $tmp/sv.qza
    qiime feature-classifier classify-sklearn \
      --i-classifier $tdir/uniform-classifier.qza \
      --i-reads $tmp/sv.qza \
      --p-confidence disable \
      --p-n-jobs $njobs \
      --o-classification $tmp/classification.qza
    qiime clawback generate-class-weights \
      --i-reference-taxonomy $tdir/ref-tax.qza \
      --i-reference-sequences $tdir/ref-seqs.qza \
      --i-samples $tmp/$habitat.qza \
      --i-taxonomy-classification $tmp/classification.qza \
      --o-class-weight $tdir/$habitat.qza
  done
done

#rm -r $tmp/
