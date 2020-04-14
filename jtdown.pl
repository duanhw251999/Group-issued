#!usr/bin/perl
use strict;
use Net::FTP;
use POSIX;
use Net::Cmd;
use File::Basename;
use File::Copy;
use Data::Dumper;
use conf;
use conftp;
use helperx;
use unzip;
use share;
use trans;


my @path=(
'/pardata/EDADATA/JT_SOURCE/TEMP/NEWDATA/'
,'/pardata/EDADATA/JT_SOURCE/TEMP/NEWDATA/share/'
,'/pardata/EDADATA/JT_SOURCE/DAY/'
,'/pardata/EDADATA/JT_SOURCE/TEMP/NEWDATA/zip/'
,'/pardata/EDADATA/JT_SOURCE/TEMP/NEWDATA/trans/'
,'/pardata/EDADATA/INTERFACE/BSS/DATA/');


sub scan_server
{ 
	helperx::msg('scan_server start...');
    conftp::switch_server();
    `mv $path[0]*.* $path[1]`;
    helperx::msg('scan_server end...');
}

sub share_unit
{
   helperx::msg('share_unit start...');
   share::share_unit($path[1]);	
   `cp $path[1]*.* $path[2]`;
   share::delete_name_null($path[1]);
   share::delete_interfase_null($path[1]);
   helperx::msg('share_unit end...');   
}

sub unzip_file
{
	helperx::msg('Unzip start...');   
	unzip::apart_gz_file($path[3]);
     helperx::msg('Unzip end...');   
}

sub trans_file
{
	helperx::msg('Trans start...');   
	trans::filter_check($path[4]);
	trans::trans_dat($path[4]);
	trans::trans_verf($path[4]);
	trans::clear_file($path[4]);
	trans::move_bss($path[4],$path[5]);
	helperx::msg('Trans end...');   
}



sub main(){
    while(1==1){
		helperx::msg("***********************************************************");
		helperx::msg("She prompt PID==>	$$  duanhw ");
		helperx::msg("***********************************************************");
		scan_server();
		sleep(600);
		share_unit();
		sleep(600);
		unzip_file();
		sleep(600);
		trans_file();
		sleep(600);
   }
}

main();
