#!/bin/sh

shuf /workspace/datasets/fasttext/labeled_products.txt > /workspace/datasets/fasttext/shuffled_labeled_products.txt
head -n 10000 /workspace/datasets/fasttext/shuffled_labeled_products.txt > training_lite.txt
tail -n 15000 /workspace/datasets/fasttext/shuffled_labeled_products.txt > testing_lite.txt

shuf /workspace/datasets/fasttext/pruned_labeled_products.txt > /workspace/datasets/fasttext/shuffled_pruned_labeled_products.txt
head -n 10000 /workspace/datasets/fasttext/shuffled_pruned_labeled_products.txt > /workspace/datasets/fasttext/pruned_training_lite.txt
tail -n 15000 /workspace/datasets/fasttext/shuffled_pruned_labeled_products.txt > /workspace/datasets/fasttext/pruned_testing_lite.txt

~/fastText-0.9.2/fasttext supervised -input /workspace/datasets/fasttext/training_lite.txt -output product_classifier -lr 1.0 -epoch 25 -wordNgrams 2
~/fastText-0.9.2/fasttext test product_classifier.bin /workspace/datasets/fasttext/testing_lite.txt

cat /workspace/datasets/fasttext/pruned_training_lite.txt | sed -e "s/\([.\!?,'/()]\)/ \1 /g" | tr "[:upper:]" "[:lower:]" | sed "s/[^[:alnum:]_]/ /g" | tr -s ' ' > /workspace/datasets/fasttext/normalized_training_data.txt
cat /workspace/datasets/fasttext/pruned_testing_lite.txt | sed -e "s/\([.\!?,'/()]\)/ \1 /g" | tr "[:upper:]" "[:lower:]" | sed "s/[^[:alnum:]_]/ /g" | tr -s ' ' > /workspace/datasets/fasttext/normalized_testing_data.txt


~/fastText-0.9.2/fasttext supervised -input /workspace/datasets/fasttext/normalized_training_data.txt -output product_classifier -lr 1.0 -epoch 25 -wordNgrams 2
~/fastText-0.9.2/fasttext test product_classifier.bin /workspace/datasets/fasttext/normalized_testing_data.txt

cut -d' ' -f2- /workspace/datasets/fasttext/shuffled_labeled_products.txt > /workspace/datasets/fasttext/titles.txt
cat /workspace/datasets/fasttext/titles.txt | sed -e "s/\([.\!?,'/()]\)/ \1 /g" | tr "[:upper:]" "[:lower:]" | sed "s/[^[:alnum:]]/ /g" | tr -s ' ' > /workspace/datasets/fasttext/normalized_titles.txt
~/fastText-0.9.2/fasttext skipgram -input /workspace/datasets/fasttext/normalized_titles.txt -output /workspace/datasets/fasttext/title_model

