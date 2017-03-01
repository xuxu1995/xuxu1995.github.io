#!/usr/bin/env sh
sudo service ocserv restart
sudo /etc/init.d/supervisor restart
sudo supervisorctl restart ssr

cd
read -r ip_old < /root/ip_list
ip=$(curl http://icanhazip.com)

if ["${ip}" != "${ip_old}"];then
	echo "ip地址变化，更新记录"
	curl -X POST https://dnsapi.cn/Record.Modify -d 'login_token=26008,d18555daecd42dcec4e65f82b8a94262&format=json&domain_id=54673886&record_id='$rc_id'&sub_domain='$sub'&value='$ip'&record_type=A&record_line=默认' 
	echo $ip > /root/ip_list;
	else 
	echo "ip NO change,quit"
fi
