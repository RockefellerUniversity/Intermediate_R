params <-
list(isSlides = "no")

## ----setup, include=FALSE-----------------------------------------------------
suppressPackageStartupMessages(require(knitr))
knitr::opts_chunk$set(echo = TRUE, tidy = T)


## ----results='asis',include=TRUE,echo=FALSE-----------------------------------
if(params$isSlides != "yes"){
  cat("# Intermediate R (part 3)

---
"    
  )
  
}



## ----results='asis',include=TRUE,echo=FALSE-----------------------------------
if(params$isSlides == "yes"){
  cat("class: inverse, center, middle

# Making R faster with data.table

<html><div style='float:left'></div><hr color='#EB811B' size=1px width=720px></html> 

---
"    
  )
}else{
  cat("# Making R faster with data.table
---
"    
  )
  
}



## ----read---------------------------------------------------------------------
library(data.table)

expressed_norm <- fread("data/expressed_genes_output_norm.csv")

expressed_norm


## ----subset1------------------------------------------------------------------
expressed_norm[1,1]


## ----index--------------------------------------------------------------------
expressed_norm[1,]


## ----subset2------------------------------------------------------------------
expressed_norm[,1]


## ----subset3------------------------------------------------------------------
expressed_norm[1]



## ----subset4------------------------------------------------------------------
expressed_norm[[1]]
expressed_norm$ENTREZ



## -----------------------------------------------------------------------------
a <- class(expressed_norm)
write.table(a,"test.txt")
a <- names(expressed_norm)
write.table(a,"test2.txt")


## ----eval=T, echo=F, warning=F, message=F-------------------------------------
setDT(expressed_norm)


## ----subset5, eval=F----------------------------------------------------------
# 
# expressed_norm[, CellType]
# 


## ----subset6, eval=F----------------------------------------------------------
# expressed_norm[, list(CellType )]


## ----subset7, eval=F----------------------------------------------------------
# expressed_norm[, .(CellType)]
# 


## ----eval=F-------------------------------------------------------------------
# expressed_norm[, .(Sample, CellType)]
# 


## ----eval=F-------------------------------------------------------------------
# expressed_norm[order(counts)]


## ----eval=F-------------------------------------------------------------------
# expressed_norm[order(-counts)]


## ----eval=F-------------------------------------------------------------------
# expressed_norm[Sample == "CD34_1"]


## ----eval=F-------------------------------------------------------------------
# expressed_norm[, mean(TPM)]
# 


## ----eval=F-------------------------------------------------------------------
# expressed_norm[Sample == "CD34_1",
#                .(mean_counts = mean(counts),
#                mean_tpm = mean(TPM))]
# 


## ----eval=F-------------------------------------------------------------------
# expressed_norm[Sample == "CD34_1",
#                sum(TPM > 100)]
# 


## ----eval=F-------------------------------------------------------------------
# expressed_norm[,sum(counts), by = Sample]
# 


## ----eval=F-------------------------------------------------------------------
# 
# expressed_norm[,.(counts.sum=sum(counts),
#                   counts.median=median(counts)), by = Sample]
# 


## ----eval=F-------------------------------------------------------------------
# expressed_norm[, RPKM := CPM/(LENGTH/1000) ]
# expressed_norm


## ----eval=F-------------------------------------------------------------------
# expressed_norm[TPM > 10, flag := TRUE]
# expressed_norm


## ----eval=F-------------------------------------------------------------------
# expressed_norm[, flag := NULL]


## ----eval=F-------------------------------------------------------------------
# setkey(expressed_norm, ENTREZ)
# expressed_norm


## ----eval=F-------------------------------------------------------------------
# expressed_norm[ENTREZ == 483]
# 


## ----eval=F-------------------------------------------------------------------
# expressed_norm[.(483)]
# 


## ----eval=F-------------------------------------------------------------------
# setkey(expressed_norm, ENTREZ, CellType)
# expressed_norm[.(483,"CD34")]


## ----eval=F-------------------------------------------------------------------
# setindex(expressed_norm, CellType)
# expressed_norm[.("CD34"), on = "CellType"]
# 


## ----results='asis',include=TRUE,echo=FALSE-----------------------------------
if(params$isSlides == "yes"){
  cat("class: inverse, center, middle

# Coercion and Import/Export

<html><div style='float:left'></div><hr color='#EB811B' size=1px width=720px></html> 

---
"    
  )
}else{
  cat("# Coercion and Import/Export
---
"    
  )
  
}



## ----eval=F-------------------------------------------------------------------
# is(expressed_norm)


## ----eval=F-------------------------------------------------------------------
# df <- as.data.frame(expressed_norm)
# is(df)


## ----eval=F-------------------------------------------------------------------
# tibb <- as_tibble(expressed_norm)
# is(tibb)


## ----eval=F-------------------------------------------------------------------
# as.data.table(tibb)


## ----eval=F-------------------------------------------------------------------
# expressed_norm <- fread("data/expressed_genes_output_norm.csv")
# 


## ----eval=F-------------------------------------------------------------------
# expressed_norm <- fread("data/expressed_genes_output_norm.csv",
#                         nThread = 4)
# 


## ----eval=F-------------------------------------------------------------------
# expressed_norm_sub <- fread(cmd = "awk -F',' -v OFS=',' '$2==\"CD34_1\" {print $1, $2, $5}' data/expressed_genes_output_norm.csv",
#              nThread = 4)
# head(expressed_norm_sub)


## ----eval=F-------------------------------------------------------------------
# fwrite(expressed_norm_sub, file = "data/expressed_norm_sub.tsv.gz",
#        sep = "\t", nThread = 8, compress = "gzip")


## ----results='asis',include=TRUE,echo=FALSE-----------------------------------
if(params$isSlides == "yes"){
  cat("class: inverse, center, middle

# Speed and Memory Comparison

<html><div style='float:left'></div><hr color='#EB811B' size=1px width=720px></html> 

---
"    
  )
}else{
  cat("# Speed and Memory Comparison
---
"    
  )
  
}



## ----eval=F-------------------------------------------------------------------
# 
# GSE216319_TPM <- read.csv("data/GSE216319_TPM_PerSampleTable.csv")
# aggregate(counts ~ Sample, data = GSE216319_TPM, sum)
# 


## ----eval=F-------------------------------------------------------------------
# 
# GSE216319_TPM <- read_csv("data/GSE216319_TPM_PerSampleTable.csv")
# GSE216319_TPM %>%
#   group_by(Sample) %>%
#   summarise(counts = median(TPMs), .groups = "drop")
# 


## ----eval=F-------------------------------------------------------------------
# 
# GSE216319_TPM <- fread("data/GSE216319_TPM_PerSampleTable.csv")
# GSE216319_TPM[, median(TPMs), by = Sample]
# 


## ----echo=F, warning=F, message=F, eval=F-------------------------------------
# library(readr)
# library(dplyr)
# library(bench)
# 
# base <- function(){
# GSE216319_TPM <- read.csv("data/GSE216319_TPM_PerSampleTable.csv")
# aggregate(TPMs ~ Sample, data = GSE216319_TPM, median)}
# 
# tidy <- function(){
# GSE216319_TPM <- read_csv("data/GSE216319_TPM_PerSampleTable.csv")
# GSE216319_TPM %>%
#   group_by(Sample) %>%
#   summarise(counts = median(TPMs), .groups = "drop")
# }
# 
# data.tab <- function(){
# GSE216319_TPM <- fread("data/GSE216319_TPM_PerSampleTable.csv")
# GSE216319_TPM[, median(TPMs), by = Sample]
# }
# 
# 
# base_time <- bench::mark(
#   base()
# )
# 
# tidy_time <- bench::mark(
#   tidy()
# )
# 
# dt_time <- bench::mark(
#   data.tab()
# )
# 
# a <- object.size(read.csv("data/GSE216319_TPM_PerSampleTable.csv"))
# b <- object.size(read_csv("data/GSE216319_TPM_PerSampleTable.csv"))
# c <- object.size(fread("data/GSE216319_TPM_PerSampleTable.csv"))
# 
# 
# timings <- rbind(base_time, tidy_time, dt_time)
# timings <- as.data.frame(unlist(timings[,9]))
# timings <- cbind(timings, c(a,b,c))
# rownames(timings) <- c("baseR","tidyR","data.table")
# colnames(timings) <- c("Time/ms","Memory Used")
# timings

