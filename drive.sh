#!/bin/sh

# netmount <remote-path> <local-path> <user> <password>
netmount()
{
	mount -r -t cifs -o user=$4,password=$3 $1 $2
}

# netumount <local-path>
netumount()
{
	umount -t cifs $1
}

# netmounttest
netmounttest()
{
	netmount user password //192.168.0.1/test /mnt/test
}