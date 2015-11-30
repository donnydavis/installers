#!/bin/bash
subscription-manager repos --disable "*"
subscription-manager repos --enable rhel-7-server-rpms --enable rhel-7-server-satellite-6.1-rpms --enable rhel-server-rhscl-7-rpms
yum -y update 
yum -y install katello
