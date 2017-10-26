#/usr/bin/perl -w
use strict;

my$SNPpositionFile=$ARGV[0];
my$SNPsFile=$ARGV[1];
my$SequenceFile=$ARGV[2];

open(POSITIONS,"<$SNPpositionFile")||die "cannot open $SNPpositionFile:$!";
open(SNPs,"<$SNPsFile")||die "cannot open $SNPsFile:$!";
open(SEQUENCE,"<$SequenceFile")||die "cannot open $SequenceFile:$!";

my%SNPpositions;
while(my$line=<POSITIONS>){
	chomp $line;
	my@columns=split "\t", $line;
	my$ID=$columns[0];
	my@varSites;
	foreach my$i (4..$#columns){
		push@varSites,$columns[$i];
	}
	my@ordered=sort {$a <=> $b} @varSites;
	$SNPpositions{$ID}=\@ordered;
}
close POSITIONS;

my%SNPs;
my$SNPsheader=<SNPs>;
while(my$line=<SNPs>){
	chomp $line;
	my@columns=split "\t", $line;
	my$TagSNP=$columns[2]."_".$columns[3];
	my$alleles=$columns[6]."_".$columns[7]."_".$columns[8]."_".$columns[9];
	$SNPs{$TagSNP}=$alleles;
}
#foreach my$key (sort keys %SNPpositions){
#	print "$key";
#	foreach my$i (@{$SNPpositions{$key}}){
#		print "\t$i";
#	}
#	print "\n";
#}

my$tagID;
while(my$line=<SEQUENCE>){
	chomp $line;
	if($line=~/^>RAD/){
		$tagID=$line;
		#print "$tagID\n";
	}else{
		my$trimmedID=$tagID;
		$trimmedID=~s/>RAD//;
		if(exists $SNPpositions{$trimmedID}){
			print "$tagID";
			my%variantSites;
			foreach my$i (@{$SNPpositions{$trimmedID}}){
				$variantSites{$i}++;
			}
			#foreach my$SNP (sort keys %variantSites){
			#	print "\t$SNP";
			#}
			print "\n";
			my@bases=split "", $line;
			foreach my$i (0..$#bases){
				if(exists $variantSites{$i}){
					my$tagSNP=$trimmedID."_".$i;
					#print$tagSNP;
					#print$SNPs{$tagSNP};
					my@alleles=split "_",$SNPs{$tagSNP};
					#print@alleles;
					my$alleles;
					foreach my$j (@alleles){
						if($j eq "-"){
						}else{
							$alleles.=$j;
						}
					}
					#print$alleles;
					print "[";
					#print "$bases[$i]";
					print "$alleles";
					print "]";
					#print "Y";
				}else{
					print "$bases[$i]";
				}
			}
			print "\n";
			$tagID="";
		}else{
			#print "$tagID not present";
			#exit;
		}
	}
}
