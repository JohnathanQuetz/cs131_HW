I used mostly the same commands for each of the steps, aside from the creation of the sample file of 10k lines.
For the first step, I used grep -Ei so that I could search for each keyword at onc4, and then I used shuf -n to get a random 10000 lines from this selection.
For steps 2-5, I followed a general pattern of tail -n+2 (to get all lines after the header) | cut -f (to select rows) | sort | uniq -c (to group items together and count frequency) | sort -nr (to order from highest to lowest frequency) | (sometimes) head -10 (to get the first 10).

Observations:
- An observation about the star rating is the order of frequency matches the order of the rating- The top reviewed product and the customer with the most reviews are outliers with a much higher frequency than the rest.
- The third most reviewed product category is books. 
