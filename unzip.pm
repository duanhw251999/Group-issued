#!usr/bin/perl
package unzip;
########################
# 段宏伟
# 2020-04-10
########################

sub apart_gz_file
{
	my $path='/pardata/EDADATA/JT_SOURCE/TEMP/DATA/zip/';
	`cd $path`;
	`gunzip  $path*.gz`;
	`mv  $path*.* /pardata/EDADATA/JT_SOURCE/TEMP/DATA/trans/`
}

1;
