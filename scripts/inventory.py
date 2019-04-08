import os
from glob import glob

rootDir = 'data'
inventory_fp = 'inventory.tsv'

# glob all QZA files
weights = glob(os.path.join(rootDir, '*', '*', '*.qza'))

# remove seqs/taxonomies
weights = [w for w in weights if 'ref-' not in w]

# compile weights information
inventory = [['path', 'database', 'primer pair', 'description']]
inventory = inventory + [[w] + w.split('/')[1:] for w in weights]

with open(inventory_fp, "w") as inventory_fh:
    inventory_fh.write('\n'.join('\t'.join(v) for v in inventory))
