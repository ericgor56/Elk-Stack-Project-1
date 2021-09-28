#!bin/bash

if [ -d /home/sysadmin/research ] 
then 
echo ' the research file exists'
else 
mkdir /research
fi

if [-f /home/sysadmin/research/sys_info.txt ] 
then
echo 'the sys_info file exists
else
echo 'the sys_info file does not exist'
fi
