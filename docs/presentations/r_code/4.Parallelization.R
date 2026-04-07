params <-
list(isSlides = "yes")

## ----results='asis',include=TRUE,echo=FALSE-----------------------------------
if(params$isSlides == "yes"){
  cat("class: inverse, center, middle

# Parallelization
<html><div style='float:left'></div><hr color='#EB811B' size=1px width=720px></html> 
---
"    
  )
}else{
  cat("# Set Up

---
"    
  )
  
}



## ----include=FALSE------------------------------------------------------------
library(future)
library(future.apply)
library(furrr)
library(doFuture)


## ----results='asis',include=TRUE,echo=FALSE-----------------------------------
if(params$isSlides == "yes"){
  cat("class: inverse, center, middle

# Future function
<html><div style='float:left'></div><hr color='#EB811B' size=1px width=720px></html> 
---
"    
  )
}else{
  cat("# Future

---
"    
  )
  
}



## ----eval=FALSE---------------------------------------------------------------
# library(future)
# fut1 <- future(
#   myFunction(arg1,arg2)
# )
# 


## ----eval=FALSE---------------------------------------------------------------
# library(future)
# fut2 <- future(
#   {
#     myNumber <- 30+10
#     mySquare <- sqrt(10)
#     finalNumber <- myNumber+mySquare
#     finalNumber
#   }
# )
# 


## -----------------------------------------------------------------------------
myFirstFuture <- future(mean(10,20,30))


## -----------------------------------------------------------------------------
myFirstFuture


## -----------------------------------------------------------------------------
myResult <- value(myFirstFuture)
myResult


## ----error=TRUE---------------------------------------------------------------
try({
myfuture <- future(sum(1,2,"GoodDay"))
res <- value(myfuture)
res
})


## ----error=TRUE---------------------------------------------------------------
try({
x <- 10
y <- 20
myfuture <- future({
  x+y
})
myfuture
})


## -----------------------------------------------------------------------------
res <- value(myfuture)
res


## -----------------------------------------------------------------------------
x <- 10
y <- 20
myfuture <- future({
  x+y
},globals = list(x=20,y=30))

value(myfuture)


## -----------------------------------------------------------------------------
library(tibble)
myfuture <- future({
  as_tibble(1:10)
})
myfuture



## -----------------------------------------------------------------------------
myTibble <- value(myfuture)
myTibble


## -----------------------------------------------------------------------------
res <- list()
for(i in 1:10){
  res[[i]] <- future(i^2)
}
length(res)


## -----------------------------------------------------------------------------
value(res)


## -----------------------------------------------------------------------------
value(res,reduce="c")


## -----------------------------------------------------------------------------
value(res,reduce="+")


## -----------------------------------------------------------------------------
res <- future({Sys.sleep(2)})
res


## ----results='asis',include=TRUE,echo=FALSE-----------------------------------
if(params$isSlides == "yes"){
  cat("class: inverse, center, middle

# Plans
<html><div style='float:left'></div><hr color='#EB811B' size=1px width=720px></html> 
---
"    
  )
}else{
  cat("# Plans

---
"    
  )
  
}



## -----------------------------------------------------------------------------
plan()


## -----------------------------------------------------------------------------
plan(sequential)


## -----------------------------------------------------------------------------
plan(multisession)


## -----------------------------------------------------------------------------
plan(multicore)


## -----------------------------------------------------------------------------
plan(cluster)


## -----------------------------------------------------------------------------
availableWorkers()
availableCores()


## -----------------------------------------------------------------------------
plan(sequential)
nbrOfWorkers()
plan(multisession)
nbrOfWorkers()


## ----eval=FALSE---------------------------------------------------------------
# plan(multisession)
# res <- future({Sys.sleep(1)})
# res


## -----------------------------------------------------------------------------
nbrOfFreeWorkers()
res <- future({Sys.sleep(1)})
nbrOfFreeWorkers()


## -----------------------------------------------------------------------------
res


## -----------------------------------------------------------------------------
Sys.sleep(3)
res


## -----------------------------------------------------------------------------
res <- future({
  Sys.sleep(1)
  1+4
  })
value(res)


## -----------------------------------------------------------------------------
res <- future({
  Sys.sleep(1)
  1+4
  })
resolved(res)
Sys.sleep(2)
resolved(res)


## ----results='asis',include=TRUE,echo=FALSE-----------------------------------
if(params$isSlides == "yes"){
  cat("class: inverse, center, middle

# Futureverse
<html><div style='float:left'></div><hr color='#EB811B' size=1px width=720px></html> 
---
"    
  )
}else{
  cat("# Futureverse

---
"    
  )
  
}



## -----------------------------------------------------------------------------
library(future.apply)
myMat <- matrix(1:10,ncol=2)
plan(multisession)
future_apply(myMat,1,mean)


## -----------------------------------------------------------------------------
plan(multisession)
future_lapply(list(Tom=c(1,33,4),Matt=c(2,1,44),Jeny=c(32,12,10)),quantile )


## -----------------------------------------------------------------------------
plan(multisession)
future_sapply(list(Tom=c(1,33,4),Matt=c(2,1,44),Jeny=c(32,12,10)),quantile)


## -----------------------------------------------------------------------------
library(furrr)
res <- future_map(1:10,sqrt)
res


## -----------------------------------------------------------------------------
library(furrr)

datasets <- split(mtcars, mtcars$cyl)

models <- future_map(datasets, ~ lm(mpg ~ wt, data = .x))

models


## -----------------------------------------------------------------------------
library(doFuture)
registerDoFuture()
plan(multisession)

y <- foreach(x = 1:10) %dopar% {
  sqrt(x)
}



## ----eval=FALSE---------------------------------------------------------------
# library("doFuture")
# registerDoFuture()
# plan(multisession)
# library("BiocParallel")
# register(DoparParam(), default = TRUE)
# myRes <- bplapply(1:10,sqrt)


## ----eval=FALSE---------------------------------------------------------------
# library(future.batchtools)
# plan(batchtools_slurm)


## ----eval=FALSE---------------------------------------------------------------
# library(future.batchtools)
# plan(batchtools_slurm,template="path/to/slurm_template.tmpl")


## ----results='asis',include=TRUE,echo=FALSE-----------------------------------
if(params$isSlides == "yes"){
  cat("class: inverse, center, middle

# Futurize
<html><div style='float:left'></div><hr color='#EB811B' size=1px width=720px></html> 
---
"    
  )
}else{
  cat("# Futurize

---
"    
  )
  
}



## -----------------------------------------------------------------------------
library(futurize)
plan(multisession)
lapply(1:10,sqrt) |> futurize() 



## -----------------------------------------------------------------------------
sapply(list(Tom=c(1,33,4),
            Matt=c(2,1,44),
            eny=c(32,12,10)),quantile) |> futurize() 



## ----eval=FALSE---------------------------------------------------------------
# library(DESeq2)
# library(futurize)
# plan(multisession)
# cnts <- matrix(rnbinom(n=1000, mu=100, size=1/0.5), ncol=10)
# cond <- factor(rep(1:2, each=5))
# dds <- DESeqDataSetFromMatrix(cnts, DataFrame(cond), ~ cond)
# dds <- DESeq(dds) |> futurize()
# 

