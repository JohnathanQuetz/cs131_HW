#!/usr/bin/env bash
set -euo pipefail

# HW05: sed pipelines and text cleaning (TSV)
 
# Starter TSV files
INPUT_TSV="/mnt/scratch/CS131_jelenag/amazon_reviews_full.tsv"
REVIEW_TSV="/mnt/scratch/CS131_jelenag/reviews.tsv"
 
echo "HW05: starting…"
 
echo "[0/4] Choose a product..."
# make file of review_ids from amazon_reviews_full.tsv that have 3+ reviews that have exclamation marks, parenthesis, brackets, braces
tail -n+2 "${INPUT_TSV}" | cut -f4,14| sed -En '/[!()\[\]]|\{|\}/p' | cut -f1 | sort | uniq -c| sort -n | sed -En 's/^[ ]*([3-9]|[1-9][0-9])[ ]*//p' | sort > reviews_full_ids.txt

# make a file with all the unique review_ids in reviews.tsv
tail -n+2 "${REVIEW_TSV}" | cut -f4 | sort | uniq > reviews_ids.txt

# find the intersection, use the first term as chosen product_id
comm -12 reviews_full_ids.txt reviews_ids.txt | head -n 1 > product_id.txt
rm reviews_full_ids.txt reviews_ids.txt
 
PRODUCT_ID=$(< product_id.txt)
 
echo "[1/4] Extract review_body for product_id=${PRODUCT_ID} …"
# Skip header, keep cols 4 and 14, match PRODUCT_ID in col1, keep only col2 => review_body_raw.txt
tail -n+2 "${REVIEW_TSV}" | cut -f4,14 | grep -P "^${PRODUCT_ID}\t" | cut -f2 > review_body_raw.txt
 
 
echo "[2/4] Clean review text with sed (HTML→punct→stopwords→whitespace)…"
# Strip HTML tags, including self-closing (e.g., <br />):
# Remove punctuation: eg. commas, dots, semicolons
# Remove whole-word stopwords (case-insensitive): and or if in it the a an
# Normalize whitespace: trim leading/trailing; collapse internal runs to a single space:
sed -E -e 's/<[^>]+>//g' \
-e 's/[.,;]//g' \
-e 's/\b(and|or|if|in|it|the|a|an)\b//Ig' \
-e 's/^[ ]+//' -e 's/[ ]+$//' -e 's/[ ]+/ /g' \
review_body_raw.txt > review_body_clean.txt
 
echo "[3/4] Tokenize and count → tokens_top.tsv…"
# Tokenize review_body_clean.txt to one token per line by splitting on non-alphanumerics
# Count and sort; Reformat uniq -c output to tsv (token<TAB>count) tokens_top.tsv
sed -E 's/[^A-Za-z0-9]+/\n/g' review_body_clean.txt | sed '/^$/d' | sort | uniq -c | sort -nr  | sed -E -e 's/^[ ]*//' -e 's/^([0-9]+)[ ]+([A-Za-z0-9]+)/\2\t\1/' >  tokens_top.tsv
 
 
echo "Done. Outputs:"
echo "  - product_id.txt"
echo "  - review_body_raw.txt"
echo "  - review_body_clean.txt"
echo "  - tokens_top.tsv"

