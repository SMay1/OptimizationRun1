#Making Allele Ratio Histograms from .genos output files from Campbell's V3_Genotyper perl script



setwd("~/Ubuntu_Shared/OptimizationRun1/Data/Genotyping/FWD")

#Read in each individual, must set ncols=15
ID_2010AC19003<-as.data.frame(read.csv("2010AC19003_S9_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19006<-as.data.frame(read.csv("2010AC19006_S10_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19008<-as.data.frame(read.csv("2010AC19008_S11_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19015<-as.data.frame(read.csv("2010AC19015_S12_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19041<-as.data.frame(read.csv("2010AC19041_S17_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19047<-as.data.frame(read.csv("2010AC19047_S13_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19049<-as.data.frame(read.csv("2010AC19049_S14_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19050<-as.data.frame(read.csv("2010AC19050_S15_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19057<-as.data.frame(read.csv("2010AC19057_S16_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19091<-as.data.frame(read.csv("2010AC19091_S18_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19096<-as.data.frame(read.csv("2010AC19096_S21_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19098<-as.data.frame(read.csv("2010AC19098_S22_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19099<-as.data.frame(read.csv("2010AC19099_S19_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19101<-as.data.frame(read.csv("2010AC19101_S23_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19102<-as.data.frame(read.csv("2010AC19102_S20_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19105<-as.data.frame(read.csv("2010AC19105_S24_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19559<-as.data.frame(read.csv("2010AC19559_S3_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19565<-as.data.frame(read.csv("2010AC19565_S4_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19685<-as.data.frame(read.csv("2010AC19685_S5_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19689<-as.data.frame(read.csv("2010AC19689_S6_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19909<-as.data.frame(read.csv("2010AC19909_S1_L001_R1_001_V3_Genotyper_out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19938<-as.data.frame(read.csv("2010AC19938_S7_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC19940<-as.data.frame(read.csv("2010AC19940_S8_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE, col.names=seq(15)))
ID_2010AC20099<-as.data.frame(read.csv("2010AC20099_S2_L001_R1_001_V3_Genotyper_out.genos",header=FALSE, col.names=seq(15)))

#list of dfs
IDs<-c("ID_2010AC19003",
"ID_2010AC19006",
"ID_2010AC19008",
"ID_2010AC19015",
"ID_2010AC19041",
"ID_2010AC19047",
"ID_2010AC19049",
"ID_2010AC19050",
"ID_2010AC19057",
"ID_2010AC19091",
"ID_2010AC19096",
"ID_2010AC19098",
"ID_2010AC19099",
"ID_2010AC19101",
"ID_2010AC19102",
"ID_2010AC19105",
"ID_2010AC19559",
"ID_2010AC19565",
"ID_2010AC19685",
"ID_2010AC19689",
"ID_2010AC19909",
"ID_2010AC19938",
"ID_2010AC19940",
"ID_2010AC20099")


for (i in seq(1:233)){                               ##233 loci
  new_locus<-matrix(nrow = 24,ncol = 3)              ##create new matrix for each locus 
  ID_Count<<-1                                       ##Counter for each locus number in order  
  lapply(IDs, function(Individual_Data){             ##apply individual names to the following function
    ID<-get(Individual_Data)                         ##get external individual df from names of individuals
    Count<-get('ID_Count')                           ##get external counter number
    Allele_1<-ID[i+1,2]                              ##Value for allele 1 example: 'G=557'
    Allele_1<-substring(Allele_1,3)                  ##Take everything after the '=' sign
    Allele_1<-as.numeric(Allele_1)                   ##Set that value as a number
    #print(Allele_1)
    Read_Depth<-ID[i+1,9]                            ##Get the total reads from column 9
    #print(Read_Depth)
    Allele_Ratio<-Allele_1[1]/Read_Depth             ##Divide to get allele ratio
    #print(Allele_Ratio)
 
    new_locus[Count,1]<<-as.character(Individual_Data)  ##Save Individual name in column 1
    new_locus[Count,2]<<-as.numeric(Allele_Ratio)       ##Save Allele Ratio in column 2
    new_locus[Count,3]<<-as.numeric(Read_Depth)         ##Save Read depth in column 3
    #print(new_locus)
    ID_Count<<-ID_Count+1                            ##Add one to the counter so it goes to the next row
  
  #print(new_locus)
  })
  new_locus[,2:3]<-as.numeric(new_locus[,2:3])       ##ensures the data is numeric
  locus_name<-ID_2010AC19003[i+1,1]                  ##gets the locus name from a single individual (assumes all loci are present in all individuals)
  
  png(filename = paste(locus_name,".png",sep = ""))  ##save the image files as the locus name.png
                  
  plot(x=new_locus[,2],y=new_locus[,3],              ##Plot the allele ratio vs depth
       type='h',
       lwd=4,
       main=locus_name, 
       ylab="Frequency (Read Depth)",
       xlab="Allele_Ratio",
       xlim=c(0,1))  
  dev.off()                   
    
}

