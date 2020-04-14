#!usr/bin/perl
package conftp;
use Net::FTP;
use POSIX;
use conf;
use record;
use Data::Dumper;
use File::Basename;
########################
# 段宏伟
# 2020-04-10
########################

##################################################################
sub getFtp     #::::::FTP通用方法，创建一个通用FTP对象用于远程操作
##################################################################
{
	my ( $host,$user,$passwd,$remote_path)=@_;
	#创建ftp对象
	my $ftp;
	my %connStr=('host'=>$host,'user'=>$user,'passwd'=>$passwd);
	my $ftp=Net::FTP->new ($connStr{'host'},Passive=>0,Timeout=>30) or die("Can not connnect to ftp server ".$connStr{'host'}.$!);
	$ftp->login($user,$passwd		) or die "Can not login"; #$ftp->message;
	return $ftp;
}
###################################################################################
# 切换服务器及目录
###################################################################################
sub switch_server(){
		my %conStr=(
	   '122gen'=>'10.254.173.122,ftp862,ftp862#$!%@,/'
	   ,'122ftp000'=>'10.254.173.122,ftp862,ftp862#$!%@,/ftp000/'
	   ,'122hr_day'=>'10.254.173.122,ds_ftp_862,Nm&ZyC_19,/DayData/'
	   ,'122hr_month'=>'10.254.173.122,ds_ftp_862,Nm&ZyC_19,/MonthData/'
	   ,'122hr_iot862'=>'10.254.173.122,ds_ftp_862,Nm&ZyC_19,/iot862/'
	);
	
	
	
	while((my $key,my $value)=each%conStr)
	{
	     my ( $host,$user,$passwd,$remote_path)=split /,/,$value;
	     my $ftp=getFtp($host,$user,$passwd,$remote_path);
	     if ($ftp!=null){
	     	    $ftp->binary;
	     		$ftp->cwd($remote_path) or die ("Can not into remote dir".$!."\n");#进入远程路径
	     		my @list=$ftp->ls($remote_path);
	     		print "current_server:$host  dir:$remote_path\n";
	     		down_server_files($ftp,$remote_path,@list);
	     }
	     $ftp->quit;
	} 	
}

sub down_server_files(){
	my ($ftp,$remote_path,@list)=@_;
	my $localdir='/pardata/EDADATA/JT_SOURCE/TEMP/DATA/';
	my $count=0;
	my $current_month=strftime("%Y%m",localtime(time()));
	#my @txt_list=grep { /.TXT|.txt$/ } @list;
	my @cvd_list=grep { /.CHECK|.gz|.VAL$/ } @list;
    for(@cvd_list){
		 my($file, $dir, $ext) = fileparse($_, qr/\.[^.]*/);
		 my $filename=$file.$ext;
		 my @namestr=split /\./ ,$filename;
		 if($namestr[1]=~/$current_month/){
		 	my $isdown=record::read_record($filename);
		 	if(record::read_record($filename)==0){
		 		print $filename."---".$isdown."\n";
		 		my $localfile=$localdir.$filename;
		 		my $remotefile=$remote_path.$filename;
		 		print "$remotefile>>>>$localfile\n";
				$ftp->get($remotefile,$localfile) or die "Could not get remotefile:$remotefile.\n";
		 		record::write_record($filename);
		 	}
		 }
    }
}

1;