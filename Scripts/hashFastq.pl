#/usr/bin/perl -w
use strict;

my%hash;
while(my$line1=<>){
	chomp $line1;
	my$line2=<>;
	chomp $line2;
	my$line3=<>;
	chomp $line3;
	my$line4=<>;
	chomp $line4;
	$hash{$line2}++;
}
foreach my$key (sort {$hash{$b} <=> $hash{$a}} keys %hash){
	print "$key\t$hash{$key}\n";
}
