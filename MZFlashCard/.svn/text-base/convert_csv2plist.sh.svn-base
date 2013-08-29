#!/bin/sh

#  convert_csv2plist.sh
#  MZFlashCard
#
#  Created by Zalan Mergl on 8/21/11.
#  Copyright 2011__MyCompanyName__. All rights reserved.


filename=$1;

cat $1 | awk '\
BEGIN \
{
	FS=";";
	
	print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">";
	print "<array>";
}
{	
	print "\t<array>";
		print "\t\t<string>"$1"</string>";
		print "\t\t<string>"$2"</string>";
	print "\t</array>";
}
END \
{
	print "</array>";
	print "</plist>";
}
' > ${filename%.*}.plist;
