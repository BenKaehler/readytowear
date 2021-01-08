# This workflow script contains all commands required to generate the
#     taxonomic weights found in readytowear/data/silva/*/
# Note that temporary files are removed at the end of this workflow.
#     Remove the last line of this script to save temporary files.

# move your current working directory to readytowear/ or alter this line
pdir=.
njobs=4

cdir=$pdir/data/silva_138/
mkdir $cdir
mkdir $cdir/full_length/
mkdir $cdir/515f-806r/

tmp=$cdir/tmp/
mkdir $tmp

wget https://data.qiime2.org/2020.11/common/silva-138-99-seqs.qza -O $cdir/full_length/ref-seqs.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-tax.qza -O $cdir/full_length/ref-tax.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-nb-classifier.qza -O $cdir/full_length/uniform-classifier.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-seqs-515-806.qza -O $cdir/515f-806r/ref-seqs.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-tax-515-806.qza -O $cdir/515f-806r/ref-tax.qza
wget https://data.qiime2.org/2020.11/common/silva-138-99-515-806-nb-classifier.qza -O $cdir/515f-806r/uniform-classifier.qza

for ddir in 515f-806r full_length
do
  tdir=$cdir/$ddir
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal distal gut' --p-metadata-value 'animal distal gut' --o-class-weight $tdir/animal-distal-gut.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal surface' --o-class-weight $tdir/animal-surface.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal secretion' --o-class-weight $tdir/animal-secretion.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Water (non-saline)' --p-metadata-value 'water (non-saline)' --o-class-weight $tdir/water-non-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal proximal gut' --o-class-weight $tdir/animal-proximal-gut.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal corpus' --p-metadata-value 'animal corpus' --o-class-weight $tdir/animal-corpus.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Plant rhizosphere' --o-class-weight $tdir/plant-rhizosphere.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Water (saline)' --p-metadata-value 'water (saline)' --o-class-weight $tdir/water-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Sediment (saline)' --p-metadata-value 'sediment (saline)' --o-class-weight $tdir/sediment-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Sediment (non-saline)' --o-class-weight $tdir/sediment-non-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Plant corpus' --o-class-weight $tdir/plant-corpus.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Plant surface' --o-class-weight $tdir/plant-surface.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Surface (saline)' --o-class-weight $tdir/surface-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Soil (non-saline)' --o-class-weight $tdir/soil-non-saline.qza

  for type in stool oral
  do
    if [ $type == 'stool' ]
    then
      redbiom search metadata "where host_taxid==9606 and (sample_type=='stool' or sample_type=='Stool')" > $tmp/sample_ids
    else
      redbiom search metadata "where host_taxid==9606 and sample_type in ('Oral', 'oral', 'Mouth', 'mouth', 'Saliva', 'saliva')" > $tmp/sample_ids
    fi
    redbiom fetch samples \
      --from $tmp/sample_ids \
      --context Deblur-Illumina-16S-V4-150nt-780653\
      --output $tmp/samples.biom
    qiime tools import \
      --type FeatureTable[Frequency] \
      --input-path $tmp/samples.biom \
      --output-path $tmp/samples.qza
    qiime clawback sequence-variants-from-samples \
      --i-samples $tmp/samples.qza \
      --o-sequences $tmp/sv.qza
    qiime feature-classifier classify-sklearn \
      --i-classifier $tdir/uniform-classifier.qza \
      --i-reads $tmp/sv.qza \
      --p-confidence=-1 \
      --o-classification $tmp/classification.qza
    qiime clawback generate-class-weights \
      --i-reference-taxonomy $cdir/ref-tax.qza \
      --i-reference-sequences $cdir/ref-seqs.qza \
      --i-samples $tmp/samples.qza \
      --i-taxonomy-classification $tmp/classification.qza \
      --o-class-weight $cdir/human-$type.qza
  done

#rm -r $tmp/
