#/usr/bin/perl -w
use strict;

my$sampleFile=$ARGV[0];

my$bowtie2build_input="finalLoci_refGT_trimmed.fa";
my$bowtie2build_output="OtsRefTrim";

my($bowtie2build_inputFile,$bowtie2build_inputExt)=split '\.', $bowtie2build_input, 2;
#load sample names from file
open(SAMPLES,"<$sampleFile")||die "cannot open $sampleFile:$!";
my@samples;
while(my$line=<SAMPLES>){
	chomp $line;
	push@samples, $line;
}
close SAMPLES;

#build bowtie2 reference
my$bt2buildCommand="bowtie2-build ".$bowtie2build_input." ".$bowtie2build_output;
print"$bt2buildCommand\n";
`$bt2buildCommand`;

#index reference file
my$BWAcommand="bwa index -p ".$bowtie2build_output." ".$bowtie2build_input;
print "$BWAcommand\n";
`$BWAcommand`;
my$samtoolsCommand="samtools faidx ".$bowtie2build_input;
print "$samtoolsCommand\n";
`$samtoolsCommand`;
my$picardDictCommand="java -jar /mnt/hgfs/Ubuntu_Shared/Optimization_Run1/Programs/Picard/Picard-2.8.2/picard-2.8.2.jar CreateSequenceDictionary REFERENCE=".$bowtie2build_input." OUTPUT=".$bowtie2build_inputFile.".dict";
print "$picardDictCommand\n";
`$picardDictCommand`;

#run read counting pipeline
foreach my$i (0..$#samples){
	my($ID,$ext)=split '\.', $samples[$i], 2;
	#align sequences using bowtie2
	my$bt2Command="bowtie2 -x ".$bowtie2build_output." --local --rg-id S_".$ID." --rg SM:".$ID." --rg PL:ILLUMINA --rg DS:HiSeq4000 -U ".$samples[$i]." -S ".$ID.".sam 2> ".$ID.".txt";
	print "$bt2Command\n";
	`$bt2Command`;
	#sort sam file using picard tools
	my$picardCommand="java -jar /mnt/hgfs/Ubuntu_Shared/Optimization_Run1/Programs/Picard/Picard-2.8.2/picard-2.8.2.jar SortSam INPUT=".$ID.".sam OUTPUT=".$ID.".bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true";
	print "$picardCommand\n";
	`$picardCommand`;
	#GATK target creator
	my$GATKtargetCreatorCommand="java -jar /mnt/hgfs/Ubuntu_Shared/Optimization_Run1/Programs/GATK/GenomeAnalysisTK-3.7/GenomeAnalysisTK.jar -T RealignerTargetCreator -I ".$ID.".bam -R ".$bowtie2build_input." -o  ".$ID.".bam.list";
	print "$GATKtargetCreatorCommand\n";
	`$GATKtargetCreatorCommand`;
	#GATK Indel Realigner
	my$GATKindelRealignerCommand="java -jar /mnt/hgfs/Ubuntu_Shared/Optimization_Run1/Programs/GATK/GenomeAnalysisTK-3.7/GenomeAnalysisTK.jar -T IndelRealigner -R ".$bowtie2build_input." -I ".$ID.".bam -targetIntervals ".$ID.".bam.list -o ".$ID.".realigned.bam";
	print "$GATKindelRealignerCommand\n";
	`$GATKindelRealignerCommand`;
	##GATK Haplotype Caller
	#my$GATKhaplotypeCallerCommand="java -jar /mnt/hgfs/Ubuntu_Shared/Optimization_Run1/Programs/GATK/GenomeAnalysisTK-3.7/GenomeAnalysisTK.jar -T HaplotypeCaller  -R  ".$bowtie2build_input." -I ".$ID.".realigned.bam -variant_index_type LINEAR -variant_index_parameter 128000 --genotyping_mode DISCOVERY --emitRefConfidence GVCF -o ".$ID.".g.vcf";
	#print "$GATKhaplotypeCallerCommand\n";
	#`$GATKhaplotypeCallerCommand`;
}

##combine vcf files
##ask Carita about which options
#foreach my$i (0..$#samples){
#	my($ID,$ext)=split '\.', $samples[$i], 2;
#}