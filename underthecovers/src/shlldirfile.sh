# Current working directory
pwd

# What is in the current directory?
#  Another expansion - Filename expansion the shell does for us.
echo *
echo /*


# ls is a powerfull external command for list contents of directories
ls
man ls
ls -l
ls -lrt
ls -lhrt
ls -1

# change working directory
#
cd /
pwd
ls
cd home
pwd
ls
cd jovyan
cd /home/jovyan
pwd
cd /usr
pwd
ls -l /var/*
pwd
cd

# . and ..
ls .
ls ..

# full path
ls /bin/ls
ls /var/log

# combining
cd /var/log/../g*

# short cut to name home
# ~ expansion
echo ~
ls ~
echo ~*

# . prefix name to hide
ls -a



# creating directoreies
# man mkdir
mkdir ~/bin
mkdir $HOME/tmp
cd ~
mkdir Classes
mkdir Classes/CS
mkdir Classes/CS/400
MYDIR=Classes/CS/400
for ((i=0; i<10; i++)); do echo mkdir $MYDIR/$i; done

# create an empty file
# man touch
touch foo
ls
rm foo
#for ((i=0; i<10; i++)); do echo touch $MYDIR/$i; done
for d in $(ls $MYDIR); do rm  $MYDIR/$d/README.md; done
rm -rf Classes

# find is also a powerfull command


