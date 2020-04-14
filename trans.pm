#!usr/bin/perl
package trans;
use conf;
use Data::Dumper;
use helperx;
use File::Copy qw(move);
########################
# 段宏伟
# 2020-04-10
########################
=pod
i_20200411_12144_00_001.dat
LDAPD_PERSON_ACCOUNT_NO_WITHDRAW_BAL
.20200413
.20200412
.00
.000
.000
.862
.CHECK
i_20200411_30148_00.verf    	
=cut
sub trans_dat
{
     my $path=shift;
	my $error_path='/pardata/EDADATA/JT_SOURCE/ERROR/';
	opendir  TEMPDIR,$path  or die "Can not open this dir";
	my @dat_list = grep {/\.DAT$/} readdir  TEMPDIR;
	for(@dat_list){
			my $new_name=$path.cover_file($_,$path);	
			move $path.$_,$new_name;
	 }
	close  TEMPDIR;
}

#通过dat 和check文件名成，转换为dat和verf文件
sub cover_file
{
	     my ($file_name,$path)=@_;
		my @datarr=split /\./,$file_name;
		my $interface_file="";
		my $configstr=conf::find_element2($datarr[0]);
		my $suffix=$datarr[-1];
		
		if($configstr ne ''){
			my @conf_arr=split /\,/,$configstr;
			my $datadate=(length($datarr[2])==6?helperx::lastdayofmonth($datarr[2]):$datarr[2]);
			if($suffix eq 'DAT'){
				$interface_file=lc($conf_arr[4])."_${datadate}_$conf_arr[3]_$datarr[3]_$datarr[5].dat";
			}
			if($suffix eq 'CHECK'){
				$interface_file=lc($conf_arr[4])."_${datadate}_$conf_arr[3]_$datarr[3].verf";
			}
			if($suffix eq 'VAL'){
				$interface_file=lc($conf_arr[4])."_${datadate}_$conf_arr[3]_$datarr[3].verf";
			}
		}
		#print "$file_name-->$interface_file\n";
		return $interface_file;
}

sub trans_verf
{
	my $path=shift;
	opendir  TEMPDIR,$path  or die "Can not open this dir";
	my @val_list = grep {/.VAL$/} readdir  TEMPDIR;
     for(@val_list){
     	my $val_file=$_;
     	my $val_to_verf=cover_file($_);
     	print "$val_file--$val_to_verf\n";
     	open VAL_FILE,"<".$path.$val_file or die "Can not open this dir";
     	my $val_context="";
     	while($val_context=<VAL_FILE>){
     		chomp $val_context;
     		my @context_arr=split //,$val_context;
     		my $jk=cover_file($context_arr[0]);
     		my ($dat_name,$size,$row,$datestr,$timestamp)=@context_arr;
     		my $input_str=sprintf  '%-40s%-20s%-20s%-20s%s' ,${jk},$size,$row,$datestr,$timestamp;
     		helperx::write_file($path.$val_to_verf,$input_str);
     	}
     	close VAL_FILE;
     }
	close  TEMPDIR;
}

sub trans_verf0
{
	#LDAPM_STAR_GRD_USER_INFO.20200413.20200412.00.001.002.862.VAL
	my $path=shift;
	opendir  TEMPDIR,$path  or die "Can not open this dir";
	my @check_list = grep {/.CHECK$/} readdir  TEMPDIR;
	for my $cfile(@check_list){
		my $verf_file=$path.cover_file($cfile,$path);
		`touch $verf_file`;
	}
	close  TEMPDIR;
}

sub trans_verf1
{
	my $path=shift;
	opendir  TEMPDIR,$path  or die "Can not open this dir";
	my @check_list = grep {/.VAL$/} readdir  TEMPDIR;
     
	close  TEMPDIR;
}

sub clear_file
{
	my $path=shift;
    `rm -rf  $path*.CHECK`;
    `rm -rf  $path*.VAL`;
}

sub move_bss
{
	my ($path,$topath)=@_;
    `mv  $path*.*  $topath`;
}



sub filter_check
{
	my $path=shift;
	my $error_path='/pardata/EDADATA/JT_SOURCE/ERROR/';
	opendir  TEMPDIR,$path  or die "Can not open this dir";
	my @check_list = grep {/.CHECK$/} readdir  TEMPDIR;
	for my $cfile(@check_list){
		print $path.$cfile."\n";
		open DAT_IN_CHECK,"<".$path.$cfile or die "Can not open this file$!";
		while(<DAT_IN_CHECK>){
			my $dat=$_;
			my $val=$_;
		     if(valid_dat_val($dat,$val,$path)==0){
		     	my @checkarr=split /\./,$cfile;
		     	my $deletestr=join(".",@checkarr[0..3])."*";
		     	print "## rm -rf $deletestr";
		     	`mv $path.$deletestr $error_path`;
		          last;	
		     }
		}
		close DAT_IN_CHECK;
	}
	close  TEMPDIR;
}

sub valid_dat_val{
   my $flag=0;
   my ($dat,$val,$path)=@_;
   $dat=~s/[\r\n]//g;
   $val=~s/[\r\n]//g;
   $val=~s/\.DAT/\.VAL/g;
   if(helperx::isExist($path.$dat)==1 and helperx::isExist($path.$val)==1){
   	  $flag=1;
   }
   return $flag;
}



sub main(){
	my $path='/pardata/EDADATA/JT_SOURCE/TEMP/DATA/trans/';
	my $path2='/pardata/EDADATA/INTERFACE/BSS/DATA/';
	move_bss($path,$path2);
}
main();