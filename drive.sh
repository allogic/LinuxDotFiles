#!/bin/sh

# netmountro <remote-path> <local-path> <user> <password>
netmountro()
{
	mount -r -t cifs -o user=$3,password=$4 $1 $2
}

# netmountrw <remote-path> <local-path> <user> <password>
netmountrw()
{
	mount -t cifs -o user=$3,password=$4 $1 $2
}

# netumount <local-path>
netumount()
{
	umount -t cifs $1
}
