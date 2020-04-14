#!usr/bin/perl
package record;
use POSIX;
########################
# 段宏伟
# 2020-04-10
########################
sub read_record{
  my ($search_str)=@_;
  my $flag=0;
  my $current_month=strftime("%Y%m",localtime(time()));
  my $path="./record_$current_month.txt";
  open (FILE,"<",$path) ||die"cannot open the file: $!\n";
  while(<FILE>){
  	    chomp $_;
     	if($search_str eq $_){
     		$flag=1;
     		last;
     	 }
  }
  close FILE;
  return $flag;
}

sub write_record{
	my $appendstr=shift;
	my $current_month=strftime("%Y%m",localtime(time()));
	my $path="./record_$current_month.txt";
	open (FILE,">>".$path) ||die"cannot open the file: $!\n";
	print FILE "$appendstr\n";
	close FILE;
}


1;