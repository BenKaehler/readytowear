# This script checks that a random subset of weights works
# with the corresponding reference data.

# move your current working directory to readytowear/ or alter this line
pdir=.
cdir=$pdir/data/

# download the ref-seqs.qzas that are too big to store in the repo
if [ ! -f $pdir/data/gg_13_8/full_length/ref-seqs.qza ]
then
  wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
  tar xzf gg_13_8_otus.tar.gz
  qiime tools import \
    --input-path $pdir/gg_13_8_otus/rep_set/99_otus.fasta \
    --type FeatureData[Sequence] \
    --output-path $pdir/data/gg_13_8/full_length/ref-seqs.qza
  rm -r $pdir/gg_13_8_otus/rep_set/99_otus.fasta
fi

if [ ! -f $pdir/data/silva_138/full_length/ref-seqs.qza ]
then
  wget https://data.qiime2.org/2020.11/common/silva-138-99-seqs.qza \
    -O $pdir/data/silva_138/full_length/ref-seqs.qza
fi

# run smoke tests on three representative sets of class weights
for ddir in gg_13_8 gtdb_r89 silva_138
do
  for dddir in 515f-806r full_length
  do
    pushd $pdir/data/$ddir/$dddir
    qiime feature-classifier fit-classifier-naive-bayes \
      --i-reference-reads ref-seqs.qza \
      --i-reference-taxonomy ref-tax.qza \
      --o-classifier delete-me-classifier.qza \
      --i-class-weight animal-distal-gut.qza
    if [ $? -eq 0 ]
      then
        echo "Successfully used data/"$ddir/$dddir"/animal-distal-gut.qza"
      else
        echo "Failed attempt to use data/"$ddir/$dddir"/animal-distal-gut.qza"
	exit 1
    fi
    qiime feature-classifier fit-classifier-naive-bayes \
      --i-reference-reads ref-seqs.qza \
      --i-reference-taxonomy ref-tax.qza \
      --o-classifier delete-me-classifier.qza \
      --i-class-weight human-stool.qza
    if [ $? -eq 0 ]
      then
        echo "Successfully used data/"$ddir/$dddir"/human-stool.qza"
      else
        echo "Failed attempt to use data/"$ddir/$dddir"/human-stool.qza"
        rm delete-me-classifier.qza
	exit 1
    fi
    qiime feature-classifier fit-classifier-naive-bayes \
      --i-reference-reads ref-seqs.qza \
      --i-reference-taxonomy ref-tax.qza \
      --o-classifier delete-me-classifier.qza \
      --i-class-weight average.qza
    if [ $? -eq 0 ]
      then
        echo "Successfully used data/"$ddir/$dddir"/average.qza"
      else
        echo "Failed attempt to use data/"$ddir/$dddir"/average.qza"
        rm delete-me-classifier.qza
	exit 1
    fi
    rm delete-me-classifier.qza
    popd
  done
done
