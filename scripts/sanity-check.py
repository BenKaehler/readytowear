# checks that the weights in the habitats for the cdir
# weren't accidentally built from the same samples


import sys
from pathlib import Path

from pandas import Series
from qiime2 import Artifact
from qiime2.plugins import feature_table, diversity

def main():
    cdir = Path("./data/silva_138_1")
    habitats = """
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
      average
    """
    habitats = habitats.split()

    v4 = {}
    fl = {}
    for habitat in habitats:
        for ddirs, collection in [("515f-806r", v4), ("full_length", fl)]:
            art = Artifact.load(cdir / ddirs / (habitat + ".qza"))
            alpha = diversity.actions.alpha(
                    metric="shannon", table=art)[0].view(Series)[0]
            collection[habitat] = alpha
    assert len(v4.values()) == len(set(v4.values())), \
            "WARNING: two sets of weights are the same"
    assert len(fl.values()) == len(set(fl.values())), \
            "WARNING: two sets of weights are the same"
    for alpha in v4.values():
        assert v4['average'] >= alpha, "WARNING: average weights are not the most diverse"
    for alpha in fl.values():
        assert fl['average'] >= alpha, "WARNING: average weights are not the most diverse"



if __name__ == '__main__':
    sys.exit(main())
