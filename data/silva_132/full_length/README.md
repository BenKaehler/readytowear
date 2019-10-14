# SILVA 132 full-length sequences
Sequences are too large to host on GitHub. To retrieve:

1. `wget https://www.arb-silva.de/fileadmin/silva_databases/qiime/Silva_132_release.zip`

2. `unzip Silva_132_release.zip`

3. `md5 SILVA_132_QIIME_release/rep_set/rep_set_all/99/silva132_99.fna`

4. MD5 checksum should equal `dadf7870059bdcabf29661d1aa41ef6f`

5. `qiime tools import --input-path SILVA_132_QIIME_release/rep_set/rep_set_all/99/silva132_99.fna --type FeatureData[Sequence] --output-path ref-seqs.qza`
