#!/bin/bash
# filename: ssh-key.sh
# 此脚本仅用于RPM系Linux发行版批量传递公钥
#
HELP(){
	echo "Usage: $(basename $0) <host-inventory>"
	echo "host-inventory是记录着主机及密码的文件"
	echo "此脚本用于将公钥批量传递到host-inventory中记录的所有在线的主机中"
}

[[ "$1" == "-h" || "$1" == "--help" ]] && HELP && exit
[ ! -f "$1" ] && echo "错误, 请查看帮助信息并检查host-inventory文件!" && exit 1

echo -e "请确认\e[32m${1}\e[0m中的格式为\e[31mIP(hostname)  Password\e[0m,否则请修改脚本!"
read -p "确认格式没问题,请输入(Y/y): " cho
[[ ! "$cho" =~ ^[Yy]$ ]] && echo "已取消" && exit

# 如果没有安装expect命令,则先安装,请确保执行者有安装权限且已安装好yum源
if ! [ -x /usr/bin/expect ];then
	yum install -y expect &> /dev/null
	! [ -x /usr/bin/expect ] && echo "安装 expect 失败" && exit 1
fi

# 如果没有密钥对,则新生成;如果已经有了,则使用已有的密钥对
expect << eof
	spawn ssh-keygen
	expect ".ssh/id_rsa):"
	send "\n"
	expect {
		"(empty for no passphrase):" {
			send "\n"
			expect "same passphrase again:"	
			send "\n"
		}
		"Overwrite (y/n)?" { send "n\n" }
	}
	expect eof
eof

#往资产文件中每台在线的机器上传递公钥
file=$1               # 资产文件的格式: IP(hostname)  password
user=root

while read line;do
	host=$(awk '{print $1}' <<< $line)    # 如果资产文件格式不同,注意修改此处
	ping -c1 $host &> /dev/null || continue
	pass=$(awk '{print $2}' <<< $line)    # 如果资产文件格式不同,注意修改此处
	expect <<- eof
		spawn ssh-copy-id $user@$host
		expect {
			"continue connecting (yes/no)?" { send "yes\n"; exp_continue }
			"password:" { send "$pass\n" }
		}
		expect eof
	eof
done < $file
