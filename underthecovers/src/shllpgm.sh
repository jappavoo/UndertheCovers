# Comments
# a word that starts with # and everthing else till end end of the line is ignored

# echo - basic built in for outputting
echo hello

# shell variables and variable expansion has lots of subtly but lets start simple
i=hello

# remember shell expansions will happen to the line prior the "echo" built in being
# executed

echo $i  # $ -- triggers parameter/variable expansion

# quoting used to control expansion and splitting

x=goodbye and farewell

# single quotes supresses all expansion and splitting - literal value of each character
# single quotes cannot contain single quotes
x='goodbye and farewell'
echo $x

x='$i goodbye and farewell'
echo $x

# double quotes partially suppress expansions but allow some like $
x="$i goodbye and farewell"

# ; can be used to join commands as a list on the same line
x="$i goodbye and farewell"; echo $x

# ok we will look at more variable related syntax and expansions later
# lets try out some loops: for, until, while, break

# for name in word ; do commands; done
for color in red green black brown; do  echo "color=$color"; done

# or
for color in read green black brown
do
    echo "color=$color"
done


# the shell also has support for integers and arithmetic
for ((i=0; i<5; i++)); do echo "i=$i"; done

# actually (()) tells the shell to do arithmetic in general
(( j++ )); echo $j

# shell arithemetic supports comparisons as well
(( j<0 ))

# special parameter ? is exit code of last command/pipe
echo $?

(( j>0 )); echo $?

# shell convention is exit value of 0 is success and non-zero if failure
# becare oposite to what you might be used to 

if (( j == 0 )); then echo "j is zero"; elif ((j<10)); then echo "j is under 10"; else "j is something else $j"; fi

# beyond arithmetic expressions bash support a more general [[]] expression
# return code will still indicate success vs failure bue allow non-integer logic
[[ $i == "hello" ]]; echo $?

# special case of logical and and or to conditional commbine commands 
(( j<0 )) && echo "j is < 0"
(( j<0 )) || echo "j is >= 0"
# could have written using if

# conditions are  just tests of exit code of command eg.  success versus failure
# So any command (internal or external) written to correctly indicate success and failure with exit code
# can be used as condition

# shell also has case and select statements

