# readytowear
Ready-made Taxonomic Weights Repository

Ready-made taxonomic weights generated by [q2-clawback](https://github.com/BenKaehler/q2-clawback) for use with the [q2-feature-classifier](https://github.com/qiime2/q2-feature-classifier/) taxonomy classifier.

[Searchable Inventory](./inventory.tsv) of readytowear taxonomic weights.

If you use any materials in readytowear, please cite:

Kaehler BD, Bokulich NA, McDonald D, Knight R, Caporaso JG, Huttley GA. 2019. Species-level microbial sequence classification is improved by source-environment information. Nature Communications 10: 4643. https://doi.org/10.1038/s41467-019-12669-6

Please also cite (as this classifier was used to provide taxonomic labels for the class weights):

Bokulich NA, Kaehler BD, Rideout JR, Dillon M, Bolyen E, Knight R, Huttley GA, Caporaso JG. 2018. Optimizing taxonomic classification of marker gene sequences. Microbiome 6(1): 90. doi: https://doi.org/10.1186/s40168-018-0470-z.

And finally do not forget to cite the reference database used (citations for individual reference databases are located in the appropriate `data` subdirectories).

## Shortcut!

If you just want a classifier for animal-distal-gut, animal-surface, animal-secretion, soil-non-saline, or animal-corpus EMPO 3 habitat types, or human-oral or human-stool, pretrained classifiers are available for download from [Zenodo](https://zenodo.org/record/6395539). They were all trained using Silva 138.1 using both full-length and 515f-806r trimmed reads. There is also an "average" classifier there that averages weights across 14 EMPO 3 habitat types if you are in doubt about which classifier to use. There are also uniform classifiers there, for comparison.

## How to use the readytowear collection

**NOTE:** *The readytowear collection currently only includes taxonomic weights generated for 16S rRNA gene sequence data. Hence, the collection currently does not include weights for other marker genes. We may accommodate these others needs in future releases, and encourage community contributions (contribution instructions coming soon). In the mean time, if you use non-16S rRNA gene data and wish to use bespoke classifiers, assemble your own custom taxonomic weights with q2-clawback as described [here](https://forum.qiime2.org/t/using-q2-clawback-to-assemble-taxonomic-weights/5859)*

q2-feature-classifier is a plugin for [QIIME 2](https://qiime2.org/), and hence QIIME 2 must be installed to use. Before beginning this tutorial, install and activate your QIIME 2 environment.

Clone readytowear to get started:
```
git clone https://github.com/BenKaehler/readytowear.git
```

Train a non-saline soil naive Bayes taxonomy classifier using the latest readytowear fashions:
```
qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads readytowear/data/gg_13_8/515f-806r/ref-seqs.qza \
  --i-reference-taxonomy readytowear/data/gg_13_8/515f-806r/ref-tax.qza \
  --i-class-weight readytowear/data/gg_13_8/515f-806r/soil-non-saline.qza \
  --o-classifier gg138_v4_soil-non-saline_classifier.qza
```

Now this classifier is ready to use! Classify a set of query sequences contained in a FASTA format file as follows:
```
qiime tools import \
  --input-path sequences.fna \
  --output-path sequences.qza \
  --type 'FeatureData[Sequence]'

qiime feature-classifier classify-sklearn \
  --i-reads sequences.qza \
  --i-classifier gg138_v4_soil-non-saline_classifier.qza \
  --o-classification bespoke-classifier-results.qza

qiime metadata tabulate \
  --m-input-file bespoke-classifier-results.qza \
  --m-input-file sequences.qza \
  --o-visualization bespoke-classifier-results.qzv
```

### Obtaining reference sequences for full-length Greengenes or SILVA

We couldn't save the full-length reference sequences for Greengenes or SILVA in this repository because they were too big. Note that if you are using GTDB or only using V4, the referece sequences are saved in the repo and you don't have to worry about this step. If you are using full-length reference sequences, you need to download them before you can train any classifier.

To obtain the full-length SILVA reference sequences for SILVA 138.1 you can run
```
wget https://zenodo.org/record/6395539/files/ref-seqs.qza \
  -O readytowear/data/silva_138_1/full_length/ref-seqs.qza
```

To obtain the full-length SILVA reference sequences for SILVA 138 you can run
```
wget https://data.qiime2.org/2020.11/common/silva-138-99-seqs.qza \
  -O readytowear/data/silva_138/full_length/ref-seqs.qza
```

To obtain the full-length Greengenes reference sequences you can run
```
wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
tar xzf gg_13_8_otus.tar.gz
qiime tools import \
  --input-path gg_13_8_otus/rep_set/99_otus.fasta \
  --type FeatureData[Sequence] \
  --output-path readytowear/data/gg_13_8/full_length/ref-seqs.qza
rm -r gg_13_8_otus
```
