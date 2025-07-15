#!/bin/bash
crc start --log-level debug > crc-output.log 2>&1
var1=$(tail -2 crc-output.log|head -1|cut -c5-)
eval "$var1"
var2=$(tail -1 crc-output.log|cut -c5-|awk '{print $1,$2,$3,$4}')
var3=$(tail -1 crc-output.log|cut -c5-|awk '{print $5}')
var4="-p developer"
var5="$var2 $var4 $var3"
$var5 > /dev/null
echo -e "You have loggin to the cluster $var3 from user $(oc whoami)"
rm -rf crc-output.log
oc whoami

