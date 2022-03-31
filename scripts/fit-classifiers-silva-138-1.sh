
# move your current working directory to readytowear/ or alter this line
pdir=.

cdir=$pdir/data/silva_138_1/

## Fit classifiers
habitats=(
  animal-distal-gut
  animal-surface
  animal-secretion
  soil-non-saline
  animal-corpus
  human-stool
  human-oral
  average
)
for habitat in "${habitats[@]}"
do
  for ddir in 515f-806r full_length
  do
    tdir=$cdir/$ddir
    if [ ! -f $tdir/$habitat.qza ]; then
      echo $tdir/$habitat.qza" does not exist, skipping"
      continue
    fi
    if [ -f $tdir/$habitat-classifier.qza ]; then
        echo $tdir/$habitat-classifier.qza" exists, skipping"
	continue
    fi
    qiime feature-classifier fit-classifier-naive-bayes \
      --i-reference-reads $tdir/ref-seqs.qza \
      --i-reference-taxonomy $tdir/ref-tax.qza \
      --i-class-weight $tdir/$habitat.qza \
      --o-classifier $tdir/$habitat-classifier.qza
  done
done

