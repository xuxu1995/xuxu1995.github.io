#!/usr/bin/env sh
echo " sub_domain:  "
read sub
echo "$sub"
ip=$(curl http://icanhazip.com)
echo $ip
curl -X POST https://dnsapi.cn/Record.Create -d 'login_token=26008,d18555daecd42dcec4e65f82b8a94262&format=json&domain_id=54673886&sub_domain='$sub'&record_type=A&record_line=默认&value='$ip''

response=$(curl -X POST https://dnsapi.cn/Record.List -d 'login_token=26008,d18555daecd42dcec4e65f82b8a94262&format=json&domain_id=54673886')
rc_id=$(echo "$response" | egrep -o '{[^{]*"name":"'"ac3"'"' | cut -d , -f 1 | cut -d : -f 2 | tr -d \")

sudo sed '5 irecord_id='$rc_id'' -i /root/ip_update.sh
sudo sed '5 isub='$sub'' -i /root/ip_update.sh

echo $ip > /root/ip_list
sudo cp ip_update.sh /etc/init.d/
sudo bash ip_update.sh