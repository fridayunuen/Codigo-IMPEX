library(nlme)
is64bit <- .Machine$sizeof.pointer == 8

options(digits = 10)# <- see more, as we have *no* *.Rout.save file here
## https://stat.ethz.ch/pipermail/r-help/2014-September/422123.html
nfm <- nlme(circumference ~ SSlogis(age, Asym, xmid, scal),
            data = Orange,
            fixed = Asym + xmid + scal ~ 1)
(sO <- summary(nfm))
vc <- VarCorr(nfm, rdig = 5)# def. 3
storage.mode(vc) <- "double" # -> (correct) NA warning
cfO <- sO$tTable
if(FALSE)
    dput(signif(cfO[,c("Std.Error", "t-value")], 8))
if(FALSE)
    dput(signif(as.numeric(vc[,"StdDev"]), 8))

cfO.Ts <- list(
    stdE.T = cbind(
        b64nx = ## R-devel 2016-01-11, 2017-09-18; [lynne]:
            c(14.052671, 34.587947, 30.497593,  13.669776, 21.036087, 11.692943)
      , b32nx = ## R-devel 2016-01-11, 2017-09-18 [florence, Fedora 24 Linux]:
            c(14.053663, 34.589821, 30.49412,   13.668653, 21.034544, 11.693889)
      , b32Win1 = ## R-devel 2017-09-17, i386-w64-mingw32/i386,
            ## Windows Server 2008 R2 x64 (build 7601) Service Pack 1
            c(14.053047, 34.588589, 30.4963,    13.669349, 21.035542, 11.693282)
      , b32Win = ## R-devel 2017-09-18, Tomas K (Win.10)
            c(14.051902, 34.579819, 30.499807,  13.670797, 21.041722, 11.692694)
    ),
    stdDev = cbind(
        b64nx = ## R-devel 2016-01-11; [lynne]:
            c(27.051312, 24.258159, 36.597078, 7.321525)
      , b32nx = ## R-devel 2017-09-18; [florence, Fedora 24 Linux]:
            c(27.053964, 24.275286, 36.58682,  7.3213653)
      , b32Win = ## R-devel 2017-09-17, i386-w64-mingw32/i386, W.Server 2008 R2..
            c(27.05234,  24.264936, 36.593554, 7.3214448)
        ## for now
    )
)
## Average number of decimal digits agreement :
lapply(cfO.Ts, function(cc) round(-log10(apply(cc - rowMeans(cc), 1, sd)), 2))
## $ stdE.T: num [1:6] 3.13 2.34 2.62 3.05 2.49 3.29
## $ stdDev: num [1:4] 2.87 2.06 2.28 4.1
## Pairwise distances (formatted, easier to read off):
round(dist(1000 * t(cfO.Ts[["stdE.T"]])), 1)
##         b64nx b32nx b32Win1
## b32nx     4.6
## b32Win1   1.7   2.9
## b32Win   10.2  13.9    11.5
round(dist(1000 * t(cfO.Ts[["stdDev"]])), 1)
##        b64nx b32nx
## b32nx   20.1
## b32Win   7.7  12.5

cName <- (if(is64bit) "b64nx"
          else if(.Platform$OS.type == "Windows") {
              if(grepl("Server 2008 R2", win.version(), fixed=TRUE))
                  "b32Win1"
              else
                  "b32Win"
          }
          else "b32nx" ## 32-bit, non-Windows
)

cfO.T <- array(cfO.Ts[["stdE.T"]][, cName], dim = 3:2,
               dimnames = list(c("Asym", "xmid", "scal"),
                               c("Std.Error", "t-value")))
vcSD <- setNames(cfO.Ts[["stdDev"]][, switch(cName, b64nx=, b32nx=, b32Win=cName,
                                             b32Win1 = "b32Win")],
		 c("Asym", "xmid", "scal", "Residual"))
stopifnot(
    identical(cfO[,"Value"], fixef(nfm)),
    all.equal(cfO[,c("Std.Error", "t-value")], cfO.T, tol = 3e-4)
   ,
    cfO[,"DF"] == 28,
    all.equal(vc[,"Variance"], vc[,"StdDev"]^2, tol= 5e-7)
   ,
    all.equal(vc[,"StdDev"], vcSD, tol = 6e-4) # 3.5e-4 (R 3.0.3, 32b)
   ,
    all.equal(unname(vc[2:3, 3:4]), # "Corr"
              rbind(c(-0.3273, NA),
		    c(-0.9920, 0.4430)), tol = 2e-3)# ~ 2e-4 / 8e-4
)

## Confirm  predict(*, newdata=.)  works
(n <- nrow(Orange)) # 35
set.seed(17)
newOr <- within(Orange[sample(n, 64, replace=TRUE), ],
		age <- round(jitter(age, amount = 50)))
fit.v <- predict(nfm, newdata = newOr)
resiv <- newOr$circumference - fit.v
res.T <- c(48, 115, 74, 15, 44, -94, 47, -51, 20, -52, -16, 12, -135,
           -85, 136, 100, 24, 181, -88, -102, -26, 52, -148, 8, -83, 73,
           -27, -34, 91, 42, 34, -8, 0, 83, 84, -90, -123, 94, -157, -11,
           56, -164, -28, 72, 15, 148, 95, -122, 169, 84, -19, -124, 45,
           -66, -10, 119, -110, -43, 12, 94, -108, 45, 48, 46)
if(!all((res10 <- round(10 * as.vector(resiv))) == res.T)) {
    iD <- which(res10 != res.T)
    cat("Differing rounded residuals, at indices", paste(iD, collapse=", "),
        "; with values:\n")
    print(cbind(resiv, res10, res.T)[iD,])
}
## -> indices  14 [64-bit]  or  27 [32-bit], respectively


## [Bug 16715] New: nlme: unable to use predict and augPredict ..
## Date: 17 Feb 2016 -- part 2 -- predict():
##
## Comment 4 daveauty@gmail.com 2016-03-08 -- modified by MM --

## simulate density data then fit Michaelis-Menten equation of density as
## function of ring age. TreeIDs grouped by SP (spacing)
set.seed(1)
df <- data.frame(SP = rep(LETTERS[1:5], 60),
		 expand.grid(TreeID = factor(1:12),
                             age = seq(2, 50, 2)),
                 stringsAsFactors = TRUE)
df[,"dens"] <- with(df, (runif(1,10,20)*age)/(runif(1,9,10)+age)) + rnorm(25, 0, 1)
str(df)
## 'data.frame':	300 obs. of  4 variables:
##  $ SP    : Factor w/ 5 levels "A","B","C","D",..: 1 2 3 4 5 1 2 3 4 5 ...
##  $ TreeID: Factor w/ 12 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ age   : num  2 2 2 2 2 2 2 2 2 2 ...
##  $ dens  : num  2.41 1.39 3.82 2.56 1.41 ...

## mixed-effects model
fit1 <- nlme(dens ~ a*age/(b+age),
	     fixed = a+b ~ 1, random= a ~ 1|TreeID,
	     start = c(a=15, b=5), data=df)
summary(fit1)
fit1R <- update(fit1, method = "REML")
## allow fixed effects parameters to vary by 'SP':
fit2 <- update(fit1, fixed = list(a ~ SP, b ~ SP),
               start = c(a = rep(14, 5), b = rep(4, 5)))
summary(fit2)

## make new data for predictions
newdat <- expand.grid(SP = LETTERS[1:5], age = seq(1, 50, 1))
n.pred1 <- predict(fit1, newdat, level=0) # works fine
n.pred2 <- predict(fit2, newdat, level=0)
## in nlme 3.1-124, throws the error:
## Error in eval(expr, envir, enclos) : object 'SP' not found

## New data with  never-yet observed levels of a random effect -- PR#16614 :
set.seed(47)
newD <- expand.grid(SP = LETTERS[2:4], age = runif(16, 1,50),
                    TreeID = sample(c(sample(1:12, 7), 100:102)))
n1prD0 <- predict(fit1, newD, level=0)
n2prD0 <- predict(fit2, newD, level=0)
n1prD1 <- predict(fit1, newD, level=1)   # failed in nlme <= 3.1-126
n2prD1 <- predict(fit2, newD, level=1)   # ditto
(n1prD01 <- predict(fit1, newD, level=0:1))#  "
(n2prD01 <- predict(fit2, newD, level=0:1))#  "
## consistency :
stopifnot(
    identical(is.na(n1prD1), is.na(n2prD1)),
    identical(sort(unique(newD[is.na(n2prD1), "TreeID"])), 100:102),
    sort(unique( newD[is.na(n2prD1), "TreeID"] )) %in% 100:102 ,
    all.equal(as.vector(n1prD0), n1prD01[,"predict.fixed"], tolerance= 1e-15),
    all.equal(as.vector(n2prD0), n2prD01[,"predict.fixed"], tolerance= 1e-15),
    all.equal(as.vector(n1prD1), n1prD01[,"predict.TreeID"],tolerance= 1e-15),
    all.equal(as.vector(n2prD1), n2prD01[,"predict.TreeID"],tolerance= 1e-15))

## new data with factor levels stored as character
stopifnot(all.equal(predict(fit2, data.frame(SP="A", age=2), level = 0),
                    predict(fit2, level = 0)[1], check.attributes = FALSE))
## in nlme <= 3.1-155, failed with
## Error in `contrasts<-`(`*tmp*`, value = contr.funs[1 + isOF[nn]]) : 
##   contrasts can be applied only to factors with 2 or more levels

## model without intercept
fit3 <- update(fit2, fixed = a + b ~ SP - 1)
stopifnot(all.equal(predict(fit3, head(df, 3)),
                    head(predict(fit3), 3), check.attributes = FALSE))
## in nlme <= 3.1-155, prediction failed if not all levels occurred
## Error in f %*% beta[fmap[[nm]]] : non-conformable arguments
