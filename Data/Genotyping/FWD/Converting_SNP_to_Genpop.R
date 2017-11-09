##Converting genotypes to genepop format

setwd("~/Ubuntu_Shared/OptimizationRun1/Data/Genotyping/FWD")

##From http://rstudio-pubs-static.s3.amazonaws.com/13694_ae246f28670c471c81c5fd68e01d837d.html
if ("devtools" %in% rownames(installed.packages()) == FALSE) {
  install.packages("devtools", repo = "http://cran.rstudio.com", dep = TRUE)
}
library("devtools")
install_github("diveRsity", "kkeenan02")


library("diveRsity")

SNPs<-read.delim("FWD_SNP1_Genotypes.txt")
?snp2gen
snp2gen(infile = "FWD_SNP1_Genotypes.txt",prefix_length = 0)


library(adegenet)
library(hierfstat)
library(graphics)
library(ggplot2)
library(tidyr)


# First, read in your data as a genepop file.The file
# can be delimited by tabs or spaces but there must abe a comma after each individual. 
# Specify how many characters code each allele with ncode. 
?read.genepop
my_data <-read.genepop("FWD_Genepop_Creek_vs_Beach.gen", ncode = 2)
my_data <- read.genepop("FWD_Genepop_A_vs_C.gen",ncode=2)
my_data <- read.genepop("FWD_Genepop_No_Pops.gen",ncode=2)
my_data <- read.genepop("FWD_Genepop_ALL4_Pops.gen",ncode=2)

#save the name of your columns as a vector you can use later so you don't have to look at the moronic genepop name
mypop_names <- c("A_Beach","C_Beach","A_Creek","C_Creek")
# To retreive useful data summaries
(summary(my_data))
my_data$pop
my_loci<- unique(my_data$loc.fac)

###########################################################
# Calculate allele frequencies for each locus in each population . Output saved as list
my_freq <- pop.freq(my_data)
my_freq

#write.csv(my_freq,file = "Beach_vs_Creek_AFs.csv")
#write.csv(my_freq,file = "A_vs_C_CREEKS_AFs.csv")
#write.csv(my_freq,file = "No_pops_AFs.csv")


#Syntax to retrieve a locus of interest:
my_freq$L_8468
my_freq$L_24029


##############################################################
# Calculate number of individuals in data
# Counts the number of individual genotyped per locus and population
my_ind <- ind.count(my_data)
my_stats <- basic.stats(my_data)

#Get Observed heterozygosities per locus and pop
my_stats$Ho

# Get Expected heterozygosities per locus and pop (well, a proxy for them called 'gene diversity". Fucking Goudet)
my_stats$Hs

#Get Fst
my_stats$Fst

# Count succesful genotypes per locus
basic.stats(my_data)$n.ind.samp

#################################################
# HISTOGRAM TIME!!!!!!!!!!
# Make histograms of Fis in each population
# Get Fis per locus and pop 

myFis <-as.data.frame(my_stats$Fis)
myFis$Locus <-my_loci
myFis <-setNames(object = myFis, mypop_names) #rename the column names so they match your population names and not some stupid genepop output


# use tidyr library to change the format of the dataframe from wide to long

keycolumn <- "population"
valuecolumn <- "Fis"
gathercolumns <- mypop_names[1:length(mypop_names)]

#Gather takes multiple columns and collapses into key-value pairs, duplicating all other columns as needed.
myFis_long <-gather_(myFis, keycolumn, valuecolumn, gathercolumns)

# Make sexy sexy transcluscent overlapping histograms of FIS distributions
theme_set(theme_classic())


pop1<-myFis_long[myFis_long$population==gathercolumns[1], ]
pop2<-myFis_long[myFis_long$population==gathercolumns[2], ]
pop3<-myFis_long[myFis_long$population==gathercolumns[3], ]
pop4<-myFis_long[myFis_long$population==gathercolumns[4], ]
#pop5<-myFis_long[myFis_long$population==gathercolumns[5], ]
#pop6<-myFis_long[myFis_long$population==gathercolumns[6], ]
#pop7<-myFis_long[myFis_long$population==gathercolumns[7], ]
#pop8<-myFis_long[myFis_long$population==gathercolumns[8], ]



ggplot(myFis_long,aes(x=Fis, fill = population)) + 
  geom_histogram(data = pop1, alpha = 0.2)  +
  geom_histogram(data = pop2, alpha = 0.2)  +
  geom_histogram(data = pop3, alpha = 0.2)  +
  geom_histogram(data = pop4, alpha = 0.2)  +
#  geom_histogram(data = pop5, alpha = 0.2)  +
#  geom_histogram(data = pop6, alpha = 0.2)  +
#  geom_histogram(data = pop7, alpha = 0.2)  +
#  geom_histogram(data = pop8, alpha = 0.2)  +
  labs(title = "All 24 Individuals 233 loci")


# Write any ofthese stats out to a text file so you can see what the fuck you are doing
write.table(my_stats$Hs, "my_Hs.txt", sep="\t")
write.table(my_stats$Hs, "my_Hs.txt", sep="\t")
write.table(my_stats$Fis, "my_Fis.txt", sep="\t")
write.table(basic.stats(my_data)$n.ind.samp, "Genotype_counts.txt", sep="\t")





