#!usr/bin/perl
package conf;
########################
# 段宏伟
# 2020-04-10
########################

########################
# 读取配置文件
########################
sub read_conf{
	my @list;
  (my $path)=@_;
  
  open(FILE,"<",$path)||die"cannot open the file: $!\n";
  
  while(<FILE>){
     	push @list, $_;
  }
  close FILE;
  return @list;
}
########################
# 根据名称查询具体某一项配置
#0--name
#1--日/月文件
#2--共享厂家
#3--接口号
#4--增全量
#5--
########################
sub find_element{
   my ($name,$indx)=@_;
   my @list=read_conf('config');
   my $findstr='';
   for(@list){
   	        chomp $_;
		 	my @nodes=split /,/, $_;
            if($name eq $nodes[0]){
            	 $findstr= $nodes[$indx];
				 last;
            }
	 }
     chomp $findstr;
	 return $findstr;
}

sub find_element2{
   my $name=shift;
   my @list=read_conf('config');
   my $findstr='';
   for(@list){
   	        chomp $_;
		 	my @nodes=split /,/, $_;
            if($name eq $nodes[0]){
            	 $findstr= $_;
				 last;
            }
	 }
     chomp $findstr;
	 return $findstr;
}

1;