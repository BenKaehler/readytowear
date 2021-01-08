# This workflow script contains all commands required to generate the
#     taxonomic weights found in readytowear/data/silva/*/
# Note that temporary files are removed at the end of this workflow.
#     Remove the last line of this script to save temporary files.

# move your current working directory to readytowear/ or alter this line
pdir=.
njobs=4

cdir=$pdir/data/silva_132/
mkdir $cdir

tmp=$cdir/tmp/
mkdir $tmp

qiime rescript get-silva-data \
    --p-version '132' \
    --p-target 'SSURef_NR99' \
    --p-include-species-labels \
    --o-silva-sequences $tmp/silva-132-ssu-nr99-seqs.qza \
    --o-silva-taxonomy $tmp/silva-132-ssu-nr99-tax.qza

qiime rescript cull-seqs \
    --i-sequences $tmp/silva-132-ssu-nr99-seqs.qza \
    --o-clean-sequences $tmp/silva-132-ssu-nr99-seqs-cleaned.qza

qiime rescript filter-seqs-length-by-taxon \
    --i-sequences $tmp/silva-132-ssu-nr99-seqs-cleaned.qza \
    --i-taxonomy $tmp/silva-132-ssu-nr99-tax.qza \
    --p-labels Archaea Bacteria Eukaryota \
    --p-min-lens 900 1200 1400 \
    --o-filtered-seqs $tmp/silva-132-ssu-nr99-seqs-filt.qza \
    --o-discarded-seqs $tmp/silva-132-ssu-nr99-seqs-discard.qza

qiime rescript dereplicate \
    --i-sequences $tmp/silva-132-ssu-nr99-seqs-filt.qza  \
    --i-taxa $tmp/silva-132-ssu-nr99-tax.qza \
    --p-rank-handles 'silva' \
    --p-mode 'uniq' \
    --o-dereplicated-sequences $cdir/full_length/ref-seqs.qza \
    --o-dereplicated-taxa $cdir/full_length/ref-tax.qza


# wget https://www.arb-silva.de/fileadmin/silva_databases/qiime/Silva_132_release.zip
# unzip Silva_132_release.zip
# qiime tools import --input-path $pdir/SILVA_132_QIIME_release/rep_set/rep_set_all/99/silva132_99.fna --type 'FeatureData[Sequence]' --output-path $cdir/full_length/ref-seqs.qza
# qiime tools import --input-path $pdir/SILVA_132_QIIME_release/taxonomy/taxonomy_all/99/majority_taxonomy_7_levels.txt --output-path $cdir/full_length/ref-tax.qza --type 'FeatureData[Taxonomy]' --input-format HeaderlessTSVTaxonomyFormat
# #cp $cdir/full_length/ref-tax.qza $cdir/515f-806r/ref-tax.qza

qiime feature-classifier extract-reads --p-f-primer GTGCCAGCMGCCGCGGTAA --p-r-primer GGACTACHVGGGTWTCTAAT --i-sequences $cdir/full_length/ref-seqs.qza --p-n-jobs $njobs --o-reads $cdir/515f-806r/ref-seqs.qza
qiime rescript filter-taxa --i-taxonomy $cdir/full_length/ref-tax.qza --m-ids-to-keep-file $cdir/515f-806r/ref-seqs.qza --o-filtered-taxonomy $cdir/515f-806r/ref-tax.qza

for ddir in 515f-806r full_length
do
  tdir=$cdir/$ddir
  qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads $tdir/ref-seqs.qza --i-reference-taxonomy $tdir/ref-tax.qza --o-classifier $tmp/uniform-classifier-$ddir.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal distal gut' --p-metadata-value 'animal distal gut' --o-class-weight $tdir/animal-distal-gut.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal surface' --o-class-weight $tdir/animal-surface.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal secretion' --o-class-weight $tdir/animal-secretion.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Water (non-saline)' --p-metadata-value 'water (non-saline)' --o-class-weight $tdir/water-non-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal proximal gut' --o-class-weight $tdir/animal-proximal-gut.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Animal corpus' --p-metadata-value 'animal corpus' --o-class-weight $tdir/animal-corpus.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Plant rhizosphere' --o-class-weight $tdir/plant-rhizosphere.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Water (saline)' --p-metadata-value 'water (saline)' --o-class-weight $tdir/water-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Sediment (saline)' --p-metadata-value 'sediment (saline)' --o-class-weight $tdir/sediment-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Sediment (non-saline)' --o-class-weight $tdir/sediment-non-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Plant corpus' --o-class-weight $tdir/plant-corpus.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Plant surface' --o-class-weight $tdir/plant-surface.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Surface (saline)' --o-class-weight $tdir/surface-saline.qza
  qiime clawback assemble-weights-from-Qiita --p-n-jobs $njobs --i-classifier $tmp/uniform-classifier-$ddir.qza --i-reference-taxonomy $tdir/ref-tax.qza --i-reference-sequences $tdir/ref-seqs.qza --p-context Deblur-Illumina-16S-V4-150nt-780653 --p-metadata-key empo_3 --p-metadata-value 'Soil (non-saline)' --o-class-weight $tdir/soil-non-saline.qza

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
      --i-classifier $tmp/uniform-classifier-$ddir.qza \
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

# rm Silva_132_release.zip
# rm -r $tmp/

rm $tmp
