import fasttext
import csv


model_location = "/workspace/datasets/fasttext/title_model.bin"
words_location = "/workspace/datasets/fasttext/top_words.txt"
synonyms_output_location = "/workspace/datasets/fasttext/synonyms.csv"

synonyms_model = fasttext.load_model(model_location)

with open(words_location, 'r') as f:
    words = [line.rstrip() for line in f]
    synonyms = []
    for word in words:
        result = [word]
        nn = synonyms_model.get_nearest_neighbors(word, k=50)
        result.extend([a[1] for a in nn if a[0] >= 0.75])
        if len(result) > 1:
            synonyms.append(result)

with open(synonyms_output_location, "w") as f:
    writer = csv.writer(f)
    writer.writerows(synonyms)