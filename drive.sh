#!/bin/sh

# netmount <remote-path> <local-path> <user> <password>
netmount()
{
	mount -r -t cifs -o user=$3,password=$4 $1 $2
}

# netumount <local-path>
netumount()
{
	umount -t cifs $1
}