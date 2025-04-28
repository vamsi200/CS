#!/bin/bash

logfile="recon_output.txt"
rm "recon_output.txt"

echo "[INFO] Script Started..." | tee -a $logfile
echo -e "\n-----------------------------" | tee -a $logfile

echo "System Details" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile

whoami=$(whoami)
id=$(id | grep -F "$whoami")
hostname=$(hostname)
version=$(grep -i version /etc/os-release | cut -d= -f2 || grep -i pretty_name /etc/os-release | cut -d= -f2)
name=$(grep -oP '^NAME="[^"]+"' /etc/os-release | cut -d= -f2)

echo "User: $whoami" | tee -a $logfile
echo "Hostname: $hostname" | tee -a $logfile
echo "OS Version: $version" | tee -a $logfile
echo "OS Name: $name" | tee -a $logfile
echo "ID: $id" | tee -a $logfile
echo -e "\n-----------------------------" | tee -a $logfile

echo "User Environment Variables" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
env | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "Kernel Information" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
kernel_name=$(uname -a | awk '{print $1}')
kernel_version=$(uname -a | awk '{print $3}')
echo "Kernel: $kernel_name $kernel_version" | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "Architecture Information" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
arch=$(lscpu | grep "Architecture" | tr -d '[:space:]' | cut -d: -f2)
echo "Architecture: $arch" | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "Available Shells" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
while read -r shell; do
  echo "$shell" | grep -v '#' | column -t | tee -a $logfile
done </etc/shells

echo -e "\n-----------------------------" | tee -a $logfile

echo "Disk and Filesystem Information" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
lsblk | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "Filesystem Details" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
while read -r fs; do
  echo "$fs" | grep -v '#' | column -t | tee -a $logfile
done </etc/fstab

echo -e "\n-----------------------------" | tee -a $logfile

echo "Routing Table" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
route || netstat -rn | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "ARP Table" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
arp -a | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "Resolving /etc/resolv.conf" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
grep -v '#' /etc/resolv.conf | column -t | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "Home Directories" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
ls /home/ | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "Unmounted Filesystems" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
grep -v '#' /etc/fstab | column -t | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "Hidden Directories and Files" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
find / -type d -name '.*' -ls 2>/dev/null | tee -a $logfile
find / -type f -name '.*' -ls 2>/dev/null | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile

echo "Temporary Files" | tee -a $logfile
echo "-----------------------------" | tee -a $logfile
ls /tmp/ /dev/shm/ /var/tmp/ | tee -a $logfile

echo -e "\n-----------------------------" | tee -a $logfile
echo "[INFO] Script Completed." | tee -a $logfile
