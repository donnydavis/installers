###Simple script to get HD Temps
#Change the grep parameter to get the correct line from fdisk
#!/bin/bash
for i in $( fdisk -l |grep TiB |awk '{ print $2}' |tr -d :); do 
hddtemp $i; 
done
### Or using smartctl
 for i in $( fdisk -l |grep TiB |awk '{ print $2}' |tr -d :); do 
 smartctl -a $i |grep 194 | awk '{ print $10 $11 $12}'; 
 done
