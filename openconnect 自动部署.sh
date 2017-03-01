#!/usr/bin/env sh
sudo apt-get update && apt-get upgrade -y
sudo apt-get install git
wget git.io/p9r8 --no-check-certificate -O ocservauto.sh&&bash ocservauto.sh

sed -i 's/#ca-cert/ca-cert/g' /etc/ocserv/ocserv.conf
sed -i 's/dh-params/#dh-params/g' /etc/ocserv/ocserv.conf

sudo curl  https://get.acme.sh | sh
sudo cd /root/.acme.sh
echo "输入SSL域名"
 read -p "domain:  " a_domain
export DP_Id="25357"
export DP_Key="ee3d377309d1cda02a3921a51cfaa519" 
sed '17 iDP_Id="25357"' -i /root/.acme.sh/dnsapi/dns_dp.sh
sed '18 iDP_Key="ee3d377309d1cda02a3921a51cfaa519"' -i /root/.acme.sh/dnsapi/dns_dp.sh
sudo /root/.acme.sh/acme.sh   --issue   --dns dns_dp   -d $a_domain

sudo /root/.acme.sh/acme.sh --installcert  -d $a_domain  \
--keypath   /etc/ocserv/server-key.pem \
--certpath /etc/ocserv/server-cert.pem \
--capath /etc/ocserv/ca-cert.pem

sudo /etc/init.d/ocserv restart

git clone https://github.com/FreeRADIUS/freeradius-client.git
cd freeradius-client
./configure --sysconfdir=/etc && make && make install
echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig

cat >>/etc/radiusclient/servers<<EOF
52.38.1.66  fxyaorui30
EOF

sed -i 's/localhost/52.38.1.66/g' /etc/radiusclient/radiusclient.conf
sed -i '41d' /etc/ocserv/ocserv.conf
sed '41 iauth = "radius[config=/etc/radiusclient/radiusclient.conf,groupconfig=true]"' -i /etc/ocserv/ocserv.conf

wget https://github.com/Cyan4973/lz4/archive/r127.tar.gz
tar zxvf r127.tar.gz
cd lz4-r127
make && make install

sudo /etc/init.d/ocserv restart
bash /root/ip.sh


