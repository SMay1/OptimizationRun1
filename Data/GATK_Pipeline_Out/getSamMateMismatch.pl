#/usr/bin/perl -w
use strict;

my$file=$ARGV[0];
open(FILE,"<$file")||die "cannot open $file:$!";

my%initialColHash;
my%IDhash;
while(my$line=<FILE>){
	chomp $line;
	if($line=~/^@/){
		next;
	}
	my@columns=split "\t", $line;
	if($columns[2] ne "*"){
		#$colHash{$columns[2]}++;
		if($columns[6] ne "="){
			my$mismatch=$columns[2]."\t".$columns[6];
			$initialColHash{$mismatch}++;
			$IDhash{$columns[2]}++;
			$IDhash{$columns[6]}++;
			#print "$columns[2]\t$columns[6]\n";
		}
	}
	
}
close FILE;
#remove duplicate entries in reverse order
my%colHash;
foreach my$key (sort keys %initialColHash){
	my($tag1,$tag2)=split "\t", $key,2;
	my$flipped=$tag2."\t".$tag1;
	if(exists $colHash{$flipped}){
		next;
	}else{
		$colHash{$key}=$initialColHash{$key};
	}
}

#create summary file
#my$summaryFile=$file.".summary.txt";
#open(SUMMARY,">$summaryFile")||die "cannot open $summaryFile:$!";
#print SUMMARY "Tag1\tTag2\tMismatches\n";
#foreach my$key (sort keys %colHash){
#	print SUMMARY "$key\t$colHash{$key}\n";
#}
close SUMMARY;

#create edge file
my$edgeFile=$file.".edges.txt";
open(EDGES,">$edgeFile")||die "cannot open $edgeFile:$!";
print EDGES "Tag1\tTag2\tMismatches\n";
foreach my$key (sort keys %colHash){
	print EDGES "$key\t$colHash{$key}\n";
}
close EDGES;

#create node file
my$nodeFile=$file.".nodes.txt";
open(NODES,">$nodeFile")||die "cannot open $nodeFile:$!";
print NODES "ID\tCounts\n";
foreach my$key (sort keys %IDhash){
	my$count=$IDhash{$key}/2;
	print NODES "$key\t$count\n";
}
