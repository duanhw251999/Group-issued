#!usr/bin/perl
package share;
use conf;
use Data::Dumper;
use helperx;
########################
# 段宏伟
# 2020-04-10
########################



sub share_unit
{
	  my $path=shift;
	  my $share_path='/pardata/EDADATA/SHARE/';
	  opendir  TEMPDIR,$path  or die "Can not open this dir";
	  my @file_list = readdir  TEMPDIR;
	  for(@file_list){
	  	    my $full=$path.$_;
			if(-f $full){
				 my @namestr=split /\./ ,$_;
				 my $name=$namestr[0];
				 my $units= conf::find_element($name,2);
				 if($units ne 'NULL'){
				 	my @unit_arr=split /\|/ ,$units;
				 	for my $u(@unit_arr){
				 		my $toshare=$share_path.$u."/";
				 		`cp $full $toshare`;
				 		print "$full=>$toshare\n";
				 	}
				 }
			}
	  }
	   close  TEMPDIR;
}

sub delete_interfase_null
{
	  my $path=shift;
	  my $path_zip='/pardata/EDADATA/JT_SOURCE/TEMP/NEWDATA/zip/';
	  opendir  TEMPDIR,$path  or die "Can not open this dir";
	  my @file_list = readdir  TEMPDIR;
	  my $size=@file_list;
	 
	  for(@file_list){
	  	my $full=$path.$_;
	  	if(-f $full){
	  		my $filename=$_;
	  		my @namestr=split /\./ ,$_;
	  		my $name=$namestr[0];
	  		my $interface_value= conf::find_element($name,3);
	  		if($interface_value eq 'NULL'){
	  			`rm -rf $full`;
	  			print "$filename delete ...\n";
	  		}else{
	  			 `mv $full $path_zip`;
	  			 print "$filename mv zip ...\n";
	  		}
	  	}
	  }
	  close  TEMPDIR;
}


sub delete_name_null
{
	my $path=shift;
	opendir  TEMPDIR,$path  or die "Can not open this dir";
	my @file_list = readdir  TEMPDIR;
	for(@file_list){
		my $full=$path.$_;
		if(-f $full){
			my $filename=$_;
	  		my @namestr=split /\./ ,$_;
	  		my $name=$namestr[0];
	  		my $name_value= conf::find_element($name,0);
	  		if($name_value eq ''){
	  			print  "$full will drop ......\n";
	  			`rm -rf $full`;
	  		}
		}
	}
	
	close  TEMPDIR;
     	
}
1;
