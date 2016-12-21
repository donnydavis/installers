#######################################################################################
#This script is a smiple loop to prepare ceph osds,                                   #
#the assumption is your hosts follow a naming convention. IE storage1                 #
#This is also designed for systems with lots of disks that are exactly the same size. #
#The size variable dictates which disks are used                                      #
#######################################################################################
export host=storage
export size=5860533168
for a in {1..3}; do 
(for i in $(ssh $host$a sudo fdisk -l |grep $size | awk '{print $2}' | cut -d ':' -f1); do ceph-deploy disk zap $host$a:$i ; done);
done

for a in {1..3}; do 
  (for i in $(ssh $host$a sudo fdisk -l |grep $size | awk '{print $2}' | cut -d ':' -f1); 
  do ceph-deploy osd prepare --fs-type xfs $host$a:$i ; done);
done
