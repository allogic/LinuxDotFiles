#!/bin/sh

# svnlog
svnlog()
{
	svn log -g $1 | perl -l40pe "s/^-+/\n/" | vim --cmd "set nowrap" -R -
}