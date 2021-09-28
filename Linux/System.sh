#!/bin/bash


df -h > home/sysadmin/backups/freedisk/free_disk.txt


free -m -h > home/sysadmin/backups/freemem/free_mem.txt


du -h >  home/sysadmin/backups/diskuse/disk_usage.txt


lsof > home/sysadmin/backups/openlist/open_list.txt

