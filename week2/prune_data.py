import pandas as pd
import csv
rows = []

with open('/workspace/datasets/fasttext/labeled_products.txt') as f:
    for line in f:
        label, product = line.split(' ', 1)
        rows.append((label, product))

df = pd.DataFrame(rows, columns=['label', 'product_name'])
print(df.shape)

df_label_counts = df.groupby('label', as_index=False).count()
df_label_counts = df_label_counts.sort_values(['product_name'], ascending=False)
top_500_cats = df_label_counts[df_label_counts['product_name'] >= 500]

pruned_df = df.merge(top_500_cats[['label']])
print(pruned_df.shape)

pruned_df.to_csv('/workspace/datasets/fasttext/pruned_labeled_products.txt', sep=' ', quoting=csv.QUOTE_NONE, index=False, escapechar='\\')
