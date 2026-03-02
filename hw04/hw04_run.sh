mkdir hw04
cd hw04

# Part A)
mkdir find_report.txt
# 1
touch notes.txt note1.txt noteA.md .bashrc fake.tsv
ls note?.txt
note1.txt
notes.txt

# 2
find ~/hw04 -type f -name *.tsv 
find ~ -type f -size +1M
find ~ -type f -mtime -1

# 3
mkdir logs
unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip | head -1000 > logs/a.log
unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip | head -1000 > logs/b.log
unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip | head -1000 > logs/c.log

find logs -name "*.log" -exec wc -l {} \;
find logs -name "*.log" | xargs wc -l


# Part B)
mkdir regex_report.txt
(unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip| head -n1 && unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip | tail -n +2 | shuf -n 1000) > amazon_reviews_10k_random_hw4.tsv

# Count lines that contain "great(est)?"
grep -Eic "great(est)?" amazon_reviews_10k_random_hw4.tsv

# Show lines that start with an uppercase letter in column 6
tail -n+2 amazon_reviews_10k_random_hw4.tsv | cut -f6 | grep "^[A-Z]" | head -5

# Count reviews whose title ends with a digit
tail -n+2 amazon_reviews_10k_random_hw4.tsv | cut -f6 | grep -ic "[0-9]$"

# Filter out lines that do not mention return
tail -n+2 amazon_reviews_10k_random_hw4.tsv | grep -vi "return" | head -n 5


# Part C)
mkdir pipelines_report.txt

# 1
mkdir out
tail -n+2 amazon_reviews_10k_random_hw4.tsv | cut -f8 | sort | uniq -c | sort -nr | tee out/hist_star_10k.txt

# 2
tail -n +2 amazon_reviews_10k_random_hw4.tsv | cut -f5 | sort | uniq -c | sort -nr | head | awk '{print $2 "\t" $1}' | sort -t $'\t' -k1,1 > top10_pid.tsv
tail -n +2 amazon_reviews_10k_random_hw4.tsv | cut -f5,6 | sort -t $'\t' -k1,1 | uniq > pid_title.tsv
join -t $'\t' top10_pid.tsv pid_title.tsv > top10_pid_title.tsv

# 3
tail -n +2 amazon_reviews_10k_random_hw4.tsv | head -n 500 | cut -f5 | sort | uniq > first500_pids.txt
tail -n +2 amazon_reviews_10k_random_hw4.tsv | head -n 500 | cut -f5 | sort | uniq > first500_pids.txt
# only first 500
comm -23 first500_pids.txt last500_pids.txt | wc -l
# only last 500
comm -13 first500_pids.txt last500_pids.txt | wc -l
# both
comm -12 first500_pids.txt last500_pids.txt | wc -l


# Part D)
mkdir -p ids/CUSTOMERS ids/PRODUCTS

# customers
tail -n+2 amazon_reviews_10k_random_hw4.tsv | cut -f2,8 | grep "10061158" | cut -f2 | tee ids/CUSTOMERS/10061158.txt
tail -n+2 amazon_reviews_10k_random_hw4.tsv | cut -f2,8 | grep "10279986" | cut -f2 | tee ids/CUSTOMERS/10279986.txt
tail -n+2 amazon_reviews_10k_random_hw4.tsv | cut -f2,8 | grep "9596183" | cut -f2 | tee ids/CUSTOMERS/9596183.txt

# products
tail -n+2 amazon_reviews_10k_random_hw4.tsv | cut -f5,8 | grep "105283912" | cut -f2 | tee ids/PRODUCTS/105283912.txt
tail -n+2 amazon_reviews_10k_random_hw4.tsv | cut -f5,8 | grep "992326428" | cut -f2 | tee ids/PRODUCTS/992326428.txt
tail -n+2 amazon_reviews_10k_random_hw4.tsv | cut -f5,8 | grep "993977887" | cut -f2 | tee ids/PRODUCTS/993977887.txt


# Part E)
mkdir perm_demo.txt
# 1
mkdir share
chmod 770 share
ls -ld share

# 2
cd share
touch perm1 perm2
mkdir dir3
cd ..
chmod -R 770 share

# 3
cd share
ln perm1 perm1_hard
ln -s perm1 perm1_sym
ls -li

# Part F)
echo "Hello world" > notes.txt
echo "Goodbye world" >> notes.txt
echo "track errors" 2> notes.txt
echo "track errors" &> notes.txt
tail -n+2 amazon_reviews_10k_random_hw4.tsv | grep -ic "Hunger Games" | tee notes.txt

