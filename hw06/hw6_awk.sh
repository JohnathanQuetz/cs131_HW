#!/usr/bin/env bash
set -euo pipefail

# HW06: awk commands

# Data file
DATA="/mnt/scratch/CS131_jelenag/amazon_reviews_full.tsv"

echo "HW06: starting..."
mkdir -p out
echo "Tasks:"

# Task 1
echo "1) Column selection and header handling"
awk -F'\t' '
{
	print $3, $4, $7, $8, $9, $10
}' OFS='\t' "${DATA}" | head -1000 > out/task1.tsv || true


# Task 2
# Note: output ends up being very large, therefore only saving first 1000 lines
echo "2) Basic filtering - verified-only, non-empty text"
awk -F'\t' '
NR==1 {print $3, $4, $7, $8, $9, $10}
NR>1 && $12=="Y" {
	s = $14
	gsub(/^ +| +$/,"", s)
	if (length(s)>=30)
		print $3, $4, $7, $8, $9, $10
}' OFS='\t' "${DATA}" | head -1000 > out/task2.tsv || true



# Task 3
echo "3) Helpfulness ratio bands"
awk -F'\t' '
NR>1 {
if ($10 == 0){
	band["NA"]++
} else {
	ratio = $9/$10
	if (ratio >= 0.1 && ratio <= 0.49)
		band["LO"]++
	else if (ratio >= 0.5 && ratio <= 0.79)
		band["MID"]++
	else if (ratio==0)
		band["ZERO"]++
	else if (ratio >= 0.8)
		band["HI"]++
}
}
END {
for (p in band)
	print p, band[p]
}' OFS='\t' "${DATA}" | sort -nr -k2,2 | awk 'BEGIN {print "band\tcount"} {print}' > out/task3.tsv

# Task 4
echo "4) Per-product rating summary (min volume)"
awk -F'\t' '
NR>1 {
sum_rating[$4] += $8
cnt[$4]++
}
END {
for (p in cnt)
	if (cnt[p] >= 50)
		printf "%s\t%d\t%.2f\n", p, cnt[p], sum_rating[p]/cnt[p]
}' "${DATA}" | sort -k3,3nr -k2,2nr | awk 'BEGIN {print "product_id\tcount\tavg_star_rating"} {print}' > out/task4.tsv



# Task 5
echo "5) Category × star distribution"
awk -F'\t' '
NR>1 && $12=="Y" {
cnt[$7]++
if ($8 == 1)
	one[$7]++
else if ($8 == 2)
	two[$7]++
else if ($8 == 3)
	three[$7]++
else if ($8 == 4)
	four[$7]++
else
	five[$7]++
}
END {
for (p in cnt)
	print p, one[p], two[p], three[p], four[p], five[p], cnt[p]
}' OFS='\t' "${DATA}" | sort -nr -k7,7 | awk 'BEGIN {print "product_category\tstar_1\tstar_2\tstar_3\tstar_4\tstar_5\ttotal"} {print}' > out/task5.tsv



# Task 6
echo "6) Monthly review volume and average rating"
awk -F'\t' '
NR>1 {
ym = substr($15, 1, 7)
sum[ym] += $8
cnt[ym]++
}
END {
for (p in cnt)
	printf "%s\t%d\t%.2f\n", p, cnt[p], sum[p]/cnt[p]
}' "${DATA}" | sort -n -k1.6,1.7 | awk 'BEGIN {print "month\tcount\tavg_star_rating"} {print}' >out/task6.tsv



# Task 7
echo "7) Keyword signal"
awk -F'\t' '
NR>1 && $12=="Y" {
tl = tolower($14)
	if (tl ~ /broken/)
		key["broken"]++
	else if (tl ~ /defect/)
		key["defect"]++
	else if (tl ~ /return/)
		key["return"]++
	else if (tl ~ /refund/)
		key["refund"]++
}
END {
for (p in key)
	print p, key[p]
}' OFS='\t' "${DATA}" | sort -nr -k2,2 | awk 'BEGIN {print "keyword\tcount"} {print}' > out/task7.tsv



# Task 8
echo "8) Power users: reviewers with many reviews per day"
awk -F'\t' '
NR>1 {
id_date = $2 "\t" $15
cnt[id_date]++
}
END {
for (p in cnt)
	if (cnt[p] >= 5)
		print p, cnt[p]
}' OFS='\t' "${DATA}" | sort -k3,3nr -k2,2 | awk 'BEGIN {print "customer_id\tdate\tcount"} {print}' > out/task8.tsv



# Task 9
echo "9) Category verified-purchase share"
awk -F'\t' '
NR>1 {
all[$7]++
if ($12=="Y")
	ver[$7]++
}
END {
for (p in all)
	printf "%s\t%d\t%.1f\n", p, all[p], (ver[p]/all[p])*100
}' "${DATA}" | sort -nr -k3,3 -k2,2 | awk 'BEGIN {print "product_category\tcount_all\tpct_verified"} {print}' > out/task9.tsv



# Task 10
echo "10) Top-N products by \"helpfulness lift\""
awk -F'\t' '
NR>1 {
cnt[$4]++
if ($10 > 0) {
	cnt_votes[$4]++
	ratio[$4] += $9/$10
}
}
END {
for (p in cnt)
	if (cnt[p] >= 100 && cnt_votes[p] > 0)
		printf "%s\t%d\t%.2f\n", p, cnt[p], ratio[p]/cnt_votes[p]
}' "${DATA}" | sort -nr -k3,3 -k2,2 | awk 'BEGIN {print "product_id\tcount_all\tavg_helpfulness_ratio"} {print}' > out/task10.tsv



# Deliverable statement
echo "Done! All outputs in out/ directory."

