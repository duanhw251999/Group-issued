#!usr/bin/perl
package unzip;
########################
# 段宏伟
# 2020-04-10
########################

sub apart_gz_file
{
	my $path=shift;
	`gunzip -f  $path*.gz`;
	`mv  $path*.* /pardata/EDADATA/JT_SOURCE/TEMP/NEWDATA/trans/`
}

1;
