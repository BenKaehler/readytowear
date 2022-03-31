njobs=10

cd data/silva_138_1/tmp

# thanks https://github.com/caporaso-lab/pretrained-feature-classifiers/blob/master/get_silva.sh
qiime rescript get-silva-data --p-version 138.1 --p-target SSURef_NR99 --p-include-species-labels --o-silva-sequences silva-138-1-99-raw-seqs.qza --o-silva-taxonomy silva-138-1-99-tax-underep.qza
qiime rescript cull-seqs --i-sequences silva-138-1-99-raw-seqs.qza --o-clean-sequences silva-138-1-99-culled-seqs.qza --p-n-jobs $njobs
qiime rescript filter-seqs-length-by-taxon --i-sequences silva-138-1-99-culled-seqs.qza --i-taxonomy silva-138-1-99-tax-underep.qza --p-labels Archaea Bacteria Eukaryota --p-min-lens 900 1200 1400 --o-filtered-seqs silva-138-1-99-filtered-seqs.qza --o-discarded-seqs silva-138-1-99-length-discarded-seqs.qza
qiime rescript dereplicate --i-sequences silva-138-1-99-filtered-seqs.qza --i-taxa silva-138-1-99-tax-underep.qza --p-rank-handles "silva" --p-mode "uniq" --o-dereplicated-sequences ../full_length/ref-seqs.qza --o-dereplicated-taxa ../full_length/ref-tax.qza

# thanks https://github.com/caporaso-lab/pretrained-feature-classifiers/blob/master/train.sh
qiime feature-classifier extract-reads --i-sequences ../full_length/ref-seqs.qza --p-f-primer GTGCCAGCMGCCGCGGTAA --p-r-primer GGACTACHVGGGTWTCTAAT --o-reads silva-138-1-99-515f-806r-underep.qza --p-n-jobs $njobs
qiime rescript dereplicate --i-sequences silva-138-1-99-515f-806r-underep.qza --i-taxa ../full_length/ref-tax.qza --p-rank-handles "silva" --p-mode "uniq" --o-dereplicated-sequences ../515f-806r/ref-seqs.qza --o-dereplicated-taxa ../515f-806r/ref-tax.qza

qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads ../full_length/ref-seqs.qza --i-reference-taxonomy ../full_length/ref-tax.qza --o-classifier ../full_length/uniform-classifier.qza
qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads ../515f-806r/ref-seqs.qza --i-reference-taxonomy ../515f-806r/ref-tax.qza --o-classifier ../515f-806r/uniform-classifier.qza
