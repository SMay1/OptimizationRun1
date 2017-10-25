#rm(list = ls())


#getwd()

setwd("~/Ubuntu_Shared/OptimizationRun1")
#dir()



library('igraph')
library('network')
library('sna')
library('ndtv')


#load data, full dataset
#Large File
edgeData<-read.delim("Data/GATK_Pipeline_Out/2010AC20099_S2_L001_PE_short_names.sam.edges",header=TRUE)
nodeData<-read.delim("Data/GATK_Pipeline_Out/2010AC20099_S2_L001_PE_short_names.sam.nodes",header=TRUE)

#Medium File
edgeData<-read.delim("Data/GATK_Pipeline_Out/2010AC19057_S16_L001_PE.sam.edges.txt",header=TRUE)
nodeData<-read.delim("Data/GATK_Pipeline_Out/2010AC19057_S16_L001_PE.sam.nodes.txt",header=TRUE)

edgeData<-read.delim("Data/GATK_Pipeline_Out/2010AC19689_S6_L001_PE.sam.edges.txt",header=TRUE)
nodeData<-read.delim("Data/GATK_Pipeline_Out/2010AC19689_S6_L001_PE.sam.nodes.txt",header=TRUE)

#Small File:

#filter for 10+ misaligned mates using summary file for edge
filteredCounts<-nodeData[nodeData$Count>=10,]
filteredEdgeData<-edgeData[edgeData$Tag1 %in% filteredCounts$ID,]
filteredEdgeData<-filteredEdgeData[filteredEdgeData$Tag2 %in% filteredCounts$ID,]
summary(filteredEdgeData)
net_filtered<-graph.data.frame(filteredEdgeData,filteredCounts,directed=T)
E(net_filtered)$weight<-filteredEdgeData$Mismatches
net_filtered<-simplify(net_filtered,remove.multiple=T,remove.loops=F)
V(net_filtered)$size<-log2(V(net_filtered)$Counts)*0.9
net_filtered
plot(net_filtered,vertex.label.cex=0.9,edge.arrow.size=.2,edge.arrow.mode=0, edge.label=E(net_filtered)$weight,layout=layout.fruchterman.reingold)


#filter edges
net_filtered.sp<-delete_edges(net_filtered, E(net_filtered)[weight<10])
#plot(net_Oke2_filtered.sp,vertex.label.cex=0.2,edge.arrow.size=.2,edge.arrow.mode=0, edge.label=E(net_Oke2_filtered.sp)$weight,layout=layout.fruchterman.reingold)

#filter nodes with no edges
edgeList<-as_data_frame(net_filtered.sp,what="edges")
nodeList<-stack(edgeList[,1:2])
nodeList<-unique(nodeList$values)
net_filtered.sp2<-delete_vertices(net_filtered.sp, V(net_filtered.sp)[!V(net_filtered.sp)$name %in% nodeList])
plot(net_filtered.sp2,vertex.label.cex=.7,edge.arrow.size=.2,edge.arrow.mode=0, edge.label=E(net_filtered.sp)$weight,layout=layout.fruchterman.reingold)
plot(net_filtered.sp2,vertex.label.cex=.01,edge.arrow.size=.2,edge.arrow.mode=0, layout=layout.fruchterman.reingold)



#are.connected(net_Oke2_filtered.sp,"Oke_RAD4864","Oke_RDDFW4577")
#write_graph(net_Oke2_filtered.sp,"V:/WORK/PASCAL/CHUM/GTseq/Oke2analysis/primerInteractionTest/test.txt")


