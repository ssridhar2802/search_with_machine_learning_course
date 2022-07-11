#!/bin/bash


shuf /workspace/datasets/labeled_query_data.txt > /workspace/datasets/fasttext/shuffled_labeled_queries.txt
head -n 50000 /workspace/datasets/fasttext/shuffled_labeled_queries.txt > /workspace/datasets/fasttext/training_queries_lite.txt
tail -n 10000 /workspace/datasets/fasttext/shuffled_labeled_queries.txt > /workspace/datasets/fasttext/testing_queries_lite.txt

~/fastText-0.9.2/fasttext supervised -input /workspace/datasets/fasttext/training_queries_lite.txt -output query_classifier -lr 0.5 -epoch 40 -wordNgrams 2
~/fastText-0.9.2/fasttext test query_classifier.bin /workspace/datasets/fasttext/testing_queries_lite.txt