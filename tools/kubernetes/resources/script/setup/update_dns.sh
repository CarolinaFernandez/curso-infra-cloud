#!/usr/bin/env bash

#
# Taken fromi https://github.com/kodekloudhub/certified-kubernetes-administrator-course
# File: https://github.com/kodekloudhub/certified-kubernetes-administrator-course/blob/master/ubuntu/update-dns.sh
#

sed -i -e 's/#DNS=/DNS=8.8.8.8/' /etc/systemd/resolved.conf

service systemd-resolved restart
