# Mostly stolen from https://github.com/qiime2/q2-feature-table/blob/9ed6160adad45445ec054e5ce034a3b3ba25a9b4/q2_feature_table/plugin_setup.py # noqa: E501

from qiime2.plugin import Str, Choices, List

import q2_feature_table
from q2_feature_table import plugin_setup
from q2_types.feature_table import FeatureTable, Frequency, RelativeFrequency
from q2_feature_table.examples import (
    feature_table_merge_example, feature_table_merge_three_tables_example)

monkey_merge = q2_feature_table.merge
monkey_merge.__name__ = 'monkey_merge'
plugin = plugin_setup.plugin
plugin.methods.register_function(
    function=monkey_merge,
    inputs={'tables':
            List[FeatureTable[Frequency] | FeatureTable[RelativeFrequency]]},
    parameters={
        'overlap_method': Str % Choices(q2_feature_table.overlap_methods()),
    },
    outputs=[
        ('merged_table', FeatureTable[Frequency])],
    input_descriptions={
        'tables': 'The collection of feature tables to be merged.',
    },
    parameter_descriptions={
        'overlap_method': 'Method for handling overlapping ids.',
    },
    output_descriptions={
        'merged_table': ('The resulting merged feature table.'),
    },
    name="Combine multiple tables",
    description="Combines feature tables using the `overlap_method` provided.",
    examples={'basic': feature_table_merge_example,
              'three_tables': feature_table_merge_three_tables_example},
)
