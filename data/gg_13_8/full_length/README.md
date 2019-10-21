# Greengenes gg_13_8 full-length sequences
Sequences are too large to host on GitHub. To retrieve:

1. `wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz`

2. `tar xzf gg_13_8_otus.tar.gz`

3. `md5 gg_13_8_otus/rep_set/99_otus.fasta`

4. MD5 checksum should equal `e5b6dd84844118591f3d9e9b6a77a846`

5. `qiime tools import --input-path gg_13_8_otus/rep_set/99_otus.fasta --type FeatureData[Sequence] --output-path ref-seqs.qza`
