
# move your current working directory to readytowear/ or alter this line
pdir=.
# set this to available memory in GB / 20 (rounded down) (or 1 if you have < 20 GB)
njobs=4

cdir=$pdir/data/silva_138_1/
mkdir $cdir
mkdir $cdir/full_length/
mkdir $cdir/515f-806r/

tmp=$cdir/tmp/
mkdir $tmp

## Build Weights
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
  if [ ! -f $tmp/$habitat.qza ]; then
    echo $tmp/$habitat.qza" does not exist, skipping"
    continue
  fi
  for ddir in 515f-806r full_length
  do
    tdir=$cdir/$ddir
    if [ -f $tmp/sv.qza ]; then
    	rm $tmp/sv.qza
    fi
    if [ -f $tmp/sv.qza ]; then
      echo "rogue sv.qza file, exiting"
      exit 1
    fi
    if [ -f $tdir/$habitat.qza ]; then
      echo $tdir/$habitat.qza" exists, skipping"
      continue
    fi
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

