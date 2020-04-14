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


my @path=('/pardata/EDADATA/JT_SOURCE/TEMP/DATA/'
,'/pardata/EDADATA/JT_SOURCE/TEMP/DATA/share/'
,'/pardata/EDADATA/JT_SOURCE/DAY/'
,'/pardata/EDADATA/JT_SOURCE/TEMP/DATA/zip/'
,'/pardata/EDADATA/JT_SOURCE/TEMP/DATA/trans/'
,'/pardata/EDADATA/INTERFACE/BSS/DATA/');

=pod
1.下载后挪入共享目录
2.进入共享目录
		2.1 将所有可以共享的源文件共享给厂家
		2.2 将所有文件备份到day目录
		2.3 剔除所有接口为空的源文件
		2.4 将有接口的源文件挪入zip目录
3.zip目录
		3.1 对所有gz文件进行解压		
		3.2 将解压文件挪入trans目录
4.进入trans目录
         4.1修改为接口文件
         4.2将所有文件挪入97	BSS/DATA/目录	
=cut
sub scan_server
{ 
	msg('scan_server start...');
    conftp::switch_server();
    `mv $path[0]*.* $path[1]`;
    msg('scan_server end...');
}

sub share_unit
{
   msg('share_unit start...');
   share::share_unit($path[1]);	
   `cp $path[1]*.* $path[2]`;
   share::delete_name_null($path[1]);
   share::delete_interfase_null($path[1]);
   msg('share_unit end...');   
}

sub unzip_file
{
	msg('Unzip start...');   
	unzip::apart_gz_file();
     msg('Unzip end...');   
}

sub trans_file
{
	msg('Trans start...');   
	trans::filter_check($path[4]);
	trans::trans_dat($path[4]);
	trans::trans_verf($path[4]);
	trans::clear_file($path[4]);
	trans::move_bss($path[4],$path[5]);
	msg('Trans end...');   
}




sub main(){
   while(1==1){
		msg("***********************************************************");
		msg("She prompt PID==>	$$  duanhw ");
		msg("***********************************************************");
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
