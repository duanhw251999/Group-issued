#!usr/bin/perl
package helperx;
use POSIX qw(strftime);
use Time::Local;
use POSIX qw(ceil floor);
use Time::HiRes qw(time);
########################
# 段宏伟
# 2020-04-10
########################
sub trim 
{ 
        my $string = shift; 
        $string =~ s/^\s+//; 
        $string =~ s/\s+$//; 
        return $string; 
}

sub msg{
	my ($message)=@_;
	my $timpstamp=strftime("%Y-%m-%d %H:%M:%S",localtime());
	$timpstamp=strftime("%Y-%m-%d %H:%M:%S",localtime());
	print "\n[${timpstamp}] $message...\n";
}

sub isExist
{
   my $flag=0;
   my $path=shift;
   if(-e $path){
   	  $flag=1;
   }
   return $flag;
}


sub lastdayofmonth
{
   my $datestr=shift;
   my $year= substr($datestr,0,4); 
   my $mon=substr($datestr,4,2); 
   my $lastday="00";
    if($mon=="01" or $mon=="03" or $mon=="05" or $mon=="07" or $mon=="08" or $mon=="10" or $mon=="12"){
   		$lastday="31";
   	}elsif($mon=="02"){
	    if(substr($year,2,2)=="00"){
	   	  if($year%400==0){
	   	   	$lastday="29";
	   	  }else{
	   	  	$lastday="28";
	   	  }
	   }else{
	   	   if($year%4==0){
	   	   	 $lastday="29";
	   	   }else{
	   	   	$lastday="28";
	   	   }
	   }
  }else{
  	$lastday="30";
  }
    return $datestr.$lastday;
}


sub write_file{
	my ($file,$str)=@_;
	print "$str^^^$file\n";
	open (FILE,">>".$file) ||die"cannot open the file: $!\n";
		print FILE "$str\n";
	close FILE;
}

1;