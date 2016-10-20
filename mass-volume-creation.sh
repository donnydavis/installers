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
