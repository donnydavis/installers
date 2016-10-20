############################
#Do this on the NFS Server##
# cd to your export dir   ##
############################
mkdir -p /nfs/user/volumes
cd /nfs/user/volumes
for i in {1..200}; do
  mkdir s"$i"
done
chmod -R 777 /nfs/user/volumes
echo '/nfs/users/volumes *(rw,sync,root_squash,no_subtree_check)' >> /etc/exports
exportfs -arv
systemctl reload nfs-server

##################################
#Do this on the Openshift Master##
# cd to your export dir         ##
##################################
cd ~
mkdir uservol
cd uservol

for i in {1..200}; do
cat <<EOF >> pv-user-s$i.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: user-pv-s$i
spec:
  capacity:
    storage: 1Gi  
  accessModes:
  - ReadWriteOnce
  nfs:
    path: /nfs/user/volumes/s$i
    server: INSERTIPADDRESS
  persistentVolumeReclaimPolicy: Recycle
EOF
done

for i in {1..200}; do
oc create -f pv-user-s$i.yaml
done
