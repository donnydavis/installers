#!/bin/bash

cp /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.orig
curl -o /etc/libvirt/qemu.conf https://raw.githubusercontent.com/donnydavis/installers/master/midonet-qemu.conf
USER="Midonet User name"
PASS="Midonet Pasword"
COMPUTESIZE=compute-large

cat << EOF > midonet.repo
[mem]
name=MEM
baseurl=http://$USER:$PASS@yum.midokura.com/repo/v1.9/stable/RHEL/7/
enabled=1
gpgcheck=1
gpgkey=https://$USER:$PASS@yum.midokura.com/repo/RPM-GPG-KEY-midokura

[mem-openstack-integration]
name=MEM OpenStack Integration
baseurl=http://$USER:$PASS@yum.midokura.com/repo/openstack-liberty/stable/RHEL/7/
enabled=1
gpgcheck=1
gpgkey=https://$USER:$PASS@yum.midokura.com/repo/RPM-GPG-KEY-midokura
EOF

[mem-openstack-integration]
name=MEM OpenStack Integration
baseurl=http://$username:$passwordusername:password@yum.midokura.com/repo/openstack-liberty/stable/RHEL/7/
enabled=1
gpgcheck=1
gpgkey=https://$username:$password@yum.midokura.com/repo/RPM-GPG-KEY-midokura
EOF

cat << EOF > /etc/selinux/config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=permissive
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
EOF


yum -y remove openvswitch
yum -y install midolman openstack-nova-network
systemctl disable openstack-nova-network.service

cat << EOF > /etc/midolman/midolman.conf
[zookeeper]
zookeeper_hosts = 172.16.12.23:2181
root_key = /midonet/v1
EOF

mn-conf template-set -h local -t agent-$COMPUTESIZE
yes |cp  /etc/midolman/midolman-env.sh.$COMPUTESIZE /etc/midolman/midolman-env.sh
systemctl enable midolman
reboot



