Making Allele Ratio Histograms


setwd("~/Ubuntu_Shared/OptimizationRun1/Data/Genotyping/FWD")

compiled_data<-read.csv("FWD_SNP1_Compile_Out.csv",header=FALSE)


loci_names<-as.matrix(compiled_data[1,7:239])
loci_names

length(loci_names)


ID_2010AC19003<-as.data.frame(read.csv("2010AC19003_S9_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19006<-as.data.frame(read.csv("2010AC19006_S10_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19008<-as.data.frame(read.csv("2010AC19008_S11_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19015<-as.data.frame(read.csv("2010AC19015_S12_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19041<-as.data.frame(read.csv("2010AC19041_S17_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19047<-as.data.frame(read.csv("2010AC19047_S13_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19049<-as.data.frame(read.csv("2010AC19049_S14_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19050<-as.data.frame(read.csv("2010AC19050_S15_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19057<-as.data.frame(read.csv("2010AC19057_S16_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19091<-as.data.frame(read.csv("2010AC19091_S18_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19096<-as.data.frame(read.csv("2010AC19096_S21_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19098<-as.data.frame(read.csv("2010AC19098_S22_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19099<-as.data.frame(read.csv("2010AC19099_S19_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19101<-as.data.frame(read.csv("2010AC19101_S23_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19102<-as.data.frame(read.csv("2010AC19102_S20_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19105<-as.data.frame(read.csv("2010AC19105_S24_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19559<-as.data.frame(read.csv("2010AC19559_S3_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19565<-as.data.frame(read.csv("2010AC19565_S4_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19685<-as.data.frame(read.csv("2010AC19685_S5_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19689<-as.data.frame(read.csv("2010AC19689_S6_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19909<-as.data.frame(read.csv("2010AC19909_S1_L001_R1_001_V3_Genotyper_out.genos",header=FALSE))
ID_2010AC19938<-as.data.frame(read.csv("2010AC19938_S7_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC19940<-as.data.frame(read.csv("2010AC19940_S8_L001_R1_001_V3_Genotyper_Out.genos",header=FALSE))
ID_2010AC20099<-as.data.frame(read.csv("2010AC20099_S2_L001_R1_001_V3_Genotyper_out.genos",header=FALSE))


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

IDs<-c(ID_2010AC19003,
       ID_2010AC19006,
       ID_2010AC19008,
       ID_2010AC19015,
       ID_2010AC19041,
       ID_2010AC19047,
       ID_2010AC19049,
       ID_2010AC19050,
       ID_2010AC19057,
       ID_2010AC19091,
       ID_2010AC19096,
       ID_2010AC19098,
       ID_2010AC19099,
       ID_2010AC19101,
       ID_2010AC19102,
       ID_2010AC19105,
       ID_2010AC19559,
       ID_2010AC19565,
       ID_2010AC19685,
       ID_2010AC19689,
       ID_2010AC19909,
       ID_2010AC19938,
       ID_2010AC19940,
       ID_2010AC20099)




for (i in seq(1:223)){
  new_locus<-matrix(nrow = 24,ncol = 3)
  ID_Count<<-1
  lapply(IDs, function(Individual_Data){
    ID<-get(Individual_Data)
    Count<-get('ID_Count')
    Allele_1<-ID[i+1,2]
    Allele_1<-substring(Allele_1,3)
    Allele_1<-as.numeric(Allele_1)
    #print(Allele_1)
    Read_Depth<-ID[i+1,9]
    #print(Read_Depth)
    Allele_Ratio<-Allele_1[1]/Read_Depth
    #print(Allele_Ratio)
 
    new_locus[Count,1]<<-as.character(Individual_Data)
    new_locus[Count,2]<<-as.numeric(Allele_Ratio)
    new_locus[Count,3]<<-as.numeric(Read_Depth)
    print(new_locus)
    ID_Count<<-ID_Count+1
  
  #print(new_locus)
  })
  new_locus[,2:3]<-as.numeric(new_locus[,2:3])
  plot(x=new_locus[,2],y=new_locus[,3],type='h',main=ID_2010AC19003[i,1])  

    
}
?lapply
