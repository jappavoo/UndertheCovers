echo "Hello World foo bar" foo

# this is a comment

echo "Hello World"  # we can use echo to print to the screen

myVar="Hello"

echo $myVar

i=0; j=10

echo "The value of i is $i and the value of j is $j and myVar is '$myVar'"

set

echo 'Hello'

echo $?

[[ $myVar == "Hello" ]]; echo $?

[[ $myVar == "Goodbye" ]]; echo $?

(( $i == 100)); echo $?

j=10 
(( $j <= 10 ))
echo $?

fruit="pear"
if [[ $fruit == "banana" ]]
then
  echo "Monkeys love bananas"
elif [[ $fruit == "apple" ]]
then
   echo "Horses love apples"
else
   echo "I don't know who likes ${fruit}s"
fi

i=0
while ((i<5))
do
  echo $i
  ((i=$i+1))
done

for ((i=0;i<3; i++))
do
   echo $i
done

function myInfo() {
  local type=$1
  echo "Name: Bob Blah-Blah"
  echo "Age: 64"
  if [[ $type == "full" ]]; then
   echo "Occupation: Space Explorer"
   echo "Favorite Food: Bits and Bytes"
   echo "OS of choice: UNIX"
  fi
}

myInfo
echo -e "\nLets try the full info\n"
myInfo "full"







ls

ls -l

ls -a

ls .

ls ..

ls /

ls /home

ls /home/jappavoo

echo "\$ date"; date
