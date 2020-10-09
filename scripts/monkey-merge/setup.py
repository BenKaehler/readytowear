from setuptools import setup, find_packages

setup(
    name="q2-monkey-merge",
    version='zero',
    packages=find_packages(),
    install_requires=['q2-feature-table'],
    author="Ben Kaehler",
    description="Merge monkey patcher",
    license='BSD-3-Clause',
    url="https://qiime2.org",
    entry_points={
        'qiime2.plugins':
        ['q2-monkey-merge=q2_monkey_merge.plugin_setup:plugin'],
    }
)
