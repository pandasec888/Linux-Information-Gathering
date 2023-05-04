#!/bin/bash

# 获取当前时间
current_time=$(date +"%Y-%m-%d_%H-%M-%S")

# 获取主机IP地址
host_ip=$(hostname -I | awk '{print $1}')

# 设置输出文件名
output_file="${host_ip}_info_$current_time.txt"

# 定义输出函数
output_info() {
  echo -e "\n$1" | tee -a $output_file
}

output_info "1. 系统信息："
output_info "  a. 发行版信息："
cat /etc/*-release | tee -a $output_file

output_info "  b. 内核信息："
uname -a | tee -a $output_file

output_info "  c. 系统架构："
arch | tee -a $output_file

output_info "  d. 系统启动时间："
uptime -s | tee -a $output_file

output_info "  e. 用户登录信息："
w | tee -a $output_file

output_info "2. 硬件信息："
output_info "  a. CPU信息："
lscpu | tee -a $output_file

output_info "  b. 硬盘信息："
lsblk | tee -a $output_file

output_info "  c. 分区信息："
df -h | tee -a $output_file

output_info "  d. USB设备信息："
lsusb | tee -a $output_file

output_info "  e. PCI设备信息："
lspci | tee -a $output_file

output_info "3. 内存信息："
output_info "  a. 总内存和可用内存："
free -h | tee -a $output_file

output_info "  b. 虚拟内存信息："
vmstat | tee -a $output_file

output_info "4. 网络信息："
output_info "  a. 本机IP信息："
hostname -I | tee -a $output_file

output_info "  b. 网络接口信息："
ip addr | tee -a $output_file

output_info "  c. 路由信息："
ip route | tee -a $output_file

output_info "  d. DNS服务器信息："
cat /etc/resolv.conf | tee -a $output_file

output_info "  e. 网络连接信息："
ss -tunapl | tee -a $output_file

output_info "5. 进程信息："
output_info "  a. 当前运行的进程："
ps -aux | tee -a $output_file

output_info "  b. 开机自启动服务："
systemctl list-unit-files --state=enabled | tee -a $output_file

output_info "  c. 系统资源使用情况："
top -b -n 1 | tee -a $output_file

output_info "6. 用户和组信息："
output_info "  a. 当前登录用户："
whoami | tee -a $output_file

output_info "  b. 系统上的所有用户："
cat /etc/passwd | tee -a $output_file

output_info "  c. 系统上的所有组："
cat /etc/group | tee -a $output_file

output_info "7. SSH服务信息："
output_info " a. SSH服务状态："
systemctl status ssh | tee -a $output_file

output_info " b. SSH配置文件："
cat /etc/ssh/sshd_config | grep -v "^#" | grep -v "^$" | tee -a $output_file

output_info "8. 计划任务信息："
output_info " a. 当前用户的计划任务："
crontab -l | tee -a $output_file

output_info " b. 系统计划任务："
ls /etc/cron* | xargs -I {} sh -c 'echo -e "\n{}:"; cat {}' | tee -a $output_file

output_info "9. 历史命令："
output_info " a. 当前用户的历史命令："
history | tee -a $output_file

echo -e "\n信息已收集完成，保存在文件：$output_file"
