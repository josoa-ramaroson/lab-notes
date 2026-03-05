# There is some data on Nautilus App Server 1 in Stratos DC. Data needs to be altered in several of the files. On Nautilus App Server 1, alter the /home/BSD.txt file as per details given below:


# a. Delete all lines containing word following and save results in /home/BSD_DELETE.txt file. (Please be aware of case sensitivity)

sed '/following/d' /home/BSD.txt > /home/BSD_DELETE.txt
# b. Replace all occurrence of word and to them and save results in /home/BSD_REPLACE.txt file. 
sed 's/\band\b/them/g' /home/BSD.txt > /home/BSD_REPLACE.txt