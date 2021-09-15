# io redirection
echo "Hello" > out
for ((i=0; i<10; i++)); do echo "Your number is $i" > out; done
# cat
cat out

for ((i=0; i<10; i++)); do echo "Your number is $i"; done  > out
cat out

echo "lets add a line to the end of the file" >> out
cat out

cat out > out2
cat out >> out2
cat out out2 > out3

cat > out4


# wc

# grep

# sort

# uniq

# cut

# tr

# join

# split

# head

# tail

# less

# pipeline

# channel/stream model
# standard in, standard out, standard error
# <
# >
# 2>
# >out 2>&1

# when bash runs a program default is to inherit the same source and desitions as the bash has
# So if bash in connected to a terminal then cat will be connected to terminal
# most program are written so that if no files are specified as arguments then input, output and errors
# will come and go to the standard streams
cat
cat > out
cat < out

# idiom
ls -l | while read a b c rest
do
 echo a=$a b=$b c=$c rest=$rest
done
