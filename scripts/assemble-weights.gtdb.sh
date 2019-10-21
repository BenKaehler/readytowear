# This workflow script contains all commands required to generate the
#     taxonomic weights found in readytowear/data/gtdb/*/
# Note that temporary files are removed at the end of this workflow.
#     Remove the last line of this script to save temporary files.

# move your current working directory to readytowear/ or alter this line
pdir=.

cdir=$pdir/data/gtdb/

mkdir tmp/

wget https://data.ace.uq.edu.au/public/gtdb/data/releases/release89/89.0/bac120_taxonomy_r89.tsv -O $pdir/tmp/bac120_taxonomy_r89.tsv
wget https://data.ace.uq.edu.au/public/gtdb/data/releases/release89/89.0/bac120_ssu_r89.fna -O $pdir/tmp/bac120_ssu_r89.fna
qiime tools import --input-path $pdir/tmp/bac120_ssu_r89.fna --type FeatureData[Sequence] --output-path $cdir/full_length/ref-seqs.qza
qiime tools import --input-path $pdir/tmp/bac120_taxonomy_r89.tsv --output-path $cdir/515f-806r/ref-tax.qza --type FeatureData[Taxonomy] --input-format HeaderlessTSVTaxonomyFormat
cp $cdir/515f-806r/ref-taxa.qza $cdir/full_length/ref-taxa.qza

qiime feature-classifier extract-reads --p-f-primer GTGCCAGCMGCCGCGGTAA --p-r-primer GGACTACHVGGGTWTCTAAT --i-sequences $pdir/full_length/ref-seqs.qza --o-reads $cdir/515f-806r/ref-seqs.qza

for ddir in 515f-806r full_length
do
  tdir=$cdir/$ddir
  qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads $cdir/ref-seqs.qza --i-reference-taxonomy $cdir/ref-tax.qza --o-classifier $pdir/tmp/uniform-classifier.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal distal gut' --p-metadata-value 'animal distal gut' --o-class-weight $tdir/animal-distal-gut.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal surface' --o-class-weight $tdir/animal-surface.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal secretion' --o-class-weight $tdir/animal-secretion.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Water (non-saline)' --p-metadata-value 'water (non-saline)' --o-class-weight $tdir/water-non-saline.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal proximal gut' --o-class-weight $tdir/animal-proximal-gut.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal corpus' --p-metadata-value 'animal corpus' --o-class-weight $tdir/animal-corpus.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Plant rhizosphere' --o-class-weight $tdir/plant-rhizosphere.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Water (saline)' --p-metadata-value 'water (saline)' --o-class-weight $tdir/water-saline.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Sediment (saline)' --p-metadata-value 'sediment (saline)' --o-class-weight $tdir/sediment-saline.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Sediment (non-saline)' --o-class-weight $tdir/sediment-non-saline.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Plant corpus' --o-class-weight $tdir/plant-corpus.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Plant surface' --o-class-weight $tdir/plant-surface.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Surface (saline)' --o-class-weight $tdir/surface-saline.qza
  qiime clawback assemble-weights-from-Qiita --i-classifier $tdir/uniform-classifier.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Soil (non-saline)' --o-class-weight $tdir/soil-non-saline.qza

  for type in stool oral
  do
    if [ $type == 'stool' ]
    then
      redbiom search metadata "where host_taxid==9606 and (sample_type=='stool' or sample_type=='Stool')" > $pdir/tmp/sample_ids
    else
      redbiom search metadata "where host_taxid==9606 and sample_type in ('Oral', 'oral', 'Mouth', 'mouth', 'Saliva', 'saliva')" > $pdir/tmp/sample_ids
    fi
    redbiom fetch samples \
      --from $pdir/tmp/sample_ids \
      --context Deblur-Illumina-16S-V4-150nt-780653\
      --output $pdir/tmp/samples.biom
    qiime tools import \
      --type FeatureTable[Frequency] \
      --input-path $pdir/tmp/samples.biom \
      --output-path $pdir/tmp/samples.qza
    qiime clawback sequence-variants-from-samples \
      --i-samples $pdir/tmp/samples.qza \
      --o-sequences $pdir/tmp/sv.qza
    qiime feature-classifier classify-sklearn \
      --i-classifier $pdir/tmp/uniform-classifier.qza \
      --i-reads $pdir/tmp/sv.qza \
      --p-confidence=-1 \
      --o-classification $pdir/tmp/classification.qza
    qiime clawback generate-class-weights \
      --i-reference-taxonomy $cdir/ref-tax.qza \
      --i-reference-sequences $cdir/ref-seqs.qza \
      --i-samples $pdir/tmp/samples.qza \
      --i-taxonomy-classification $pdir/tmp/classification.qza \
      --o-class-weight $cdir/human-$type.qza
  done

rm -r $pdir/tmp/
