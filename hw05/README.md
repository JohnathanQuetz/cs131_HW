# Homework 5: sed

## A
* I chose to find reviews that contain any of exclamation marks, parenthesis, brackets, or braces. I had to use proper special character escaping and regex in my sed command to do this. I found the specific product ids from amazon_reviews_full that had 3+ valid reviews, the unique product ids in reviews.tsv, and used comm to find the intersection of the two tsv files and select a product id
* I then extracted the rows from reviews.tsv that matched this product id using grep, and only kept the column of reviews.  

## B
* This step required multiple sed commands, each needing to be precise in order for them to work as expected. I used the -e flag of sed to have multiple instructions in a one-line sed command.

## C
* For this step, I split by non-alphanumerics by replacing them with a new line and then removed the empty lines. I then used the familiar uniq -c pipeline to form a frequency table of the token counts, and used sed to make this table into a tsv of the form token<TAB\>count.

## D
* I provided a word cloud image to help visualize the result of the token counts table.

## Insights
* Some insights from the token counts table is that 'Books' was mentioned the most of any word, and over half the words were only mentioned once, meaning there are a lot of unique words.

## Script
* I used variables and comments to produce a clean shell script from my commands that does the same actions I did and works end-to-end.
