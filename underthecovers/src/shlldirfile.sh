# What directory are we in?
#  - current/working directory
# print working directory
pwd

# What is in the current directory?
#  Another kind of expansion the shell does for us.
echo *

# change working directory
#
cd /
pwd
echo *
cd home
pwd
echo *
cd jovyan
cd /home/jovyan
pwd
cd /usr
pwd
echo /var/*
pwd
cd
