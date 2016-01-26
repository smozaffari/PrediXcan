pred <- read.table("DGN_WB_Hutterites", header = T)
obs <- read.table("Observed_HUTT_ensembl", header = T, check.names = F)
samples <- read.table("HUTTsamples.txt")

rownames(obs) <- obs$Gene
obs$Gene <- NULL

pred_1 <- t(pred)
colnames(pred_1) <- samples$V1
pred_2 <- pred_1[, sort(colnames(pred_1))]

obs_1 <- obs[, sort(colnames(obs))]
obs_2 <- obs_1[sort(rownames(obs_1)),]

pred_3 <- pred_2[which(rownames(pred_2)%in%rownames(obs_2)), which(colnames(pred_2)%in%colnames(obs_2))]
obs_3 <- obs_2[which(rownames(obs_2)%in%rownames(pred_2)), which(colnames(obs_2)%in%colnames(pred_2))]

mypvals <- c()
mycorvec <- c()
pred <- pred_3
obs <- obs_3
for (i in 1:dim(pred)[1]) {
  genesum <- summary(lm(as.numeric(obs[i,]) ~ as.numeric(pred[i,])))
  ctest <- cor.test(as.numeric(obs[i,]), as.numeric(pred[i,]))
  cor <- c(ctest$estimate[1])
  mycorvec <- c(mycorvec, cor)
  pval <- genesum$coefficients[8];
  mypvals <- c(mypvals, pval)
}
names(mypvals) <- rownames(pred)
names(mycorvec) <- rownames(pred)

pdf("DGN_WB_Hutterite.pdf")

m <- length(mypvals)
n <- 431
nullcorvec = tanh(rnorm(m)/sqrt(n-3))
qqplot(nullcorvec^2,mycorvec^2); abline(0,1); grid()


qqunif = function(p,BH=T,CI=T,FDRthres=0.05,...)
{
  nn = length(p)
  xx =  -log10((1:nn)/(nn+1))
  dat<-cbind(p[order(p)],1:nn)
  q<-(nn*dat[,1])/dat[,2] # calculate q-values from p-values
  dat<-cbind(dat,q)
  plot( xx,  -log10(p[order(p)]),
        xlab=expression(Expected~~-log[10](italic(p))),
        ylab=expression(Observed~~-log[10](italic(p))),
        cex.lab=1,mgp=c(2,1,0),pch=20,
        ... )
  if(CI)
  {
    ## create the confidence intervals
    c95 <- rep(0,nn)
    c05 <- rep(0,nn)
    ## the jth order statistic from a
    ## uniform(0,1) sample
    ## has a beta(j,n-j+1) distribution
    ## (Casella & Berger, 2002,
    ## 2nd edition, pg 230, Duxbury)
    ## this portion was posted by anonymous on
    ## http://gettinggeneticsdone.blogspot.com/2009/11/qq-plots-of-p-values-in-r-using-ggplot2.html
    
    for(i in 1:nn)
    {
      c95[i] <- qbeta(0.95,i,nn-i+1)
      c05[i] <- qbeta(0.05,i,nn-i+1)
    }
    polygon(c(xx, rev(xx)), c(-log10(c95), rev(-log10(c05))),col = "grey", border = NA)
    #    lines(xx,-log10(c95),col='gray')
    #    lines(xx,-log10(c05),col='gray')
  }
  points(xx,  -log10(p[order(p)]),pch=20)
  #points(xx[dat[,3]<0.05],  -log10(dat[dat[,3]<0.05,1]),pch=20,col="pink")
  
  nsnps<-round((sum(p<=max(dat[dat[,3]<FDRthres,1]))/nn)*100,4)
  y<-max(-log10(p))
  text(0,y,paste(nsnps,"% of genes have a q-value <= ",FDRthres,sep=""),pos=4)
  
  #  print(paste(nsnps,"% of genes have a q-value <= ",FDRthres,sep=""))
  abline(0,1,col='red')
  if(BH)
  {
    abline(-log10(0.05),1, col='black',lty=2)
    abline(-log10(0.10),1, col='black',lty=3)
    abline(-log10(0.25),1, col='black',lty=4)
    legend('bottomright', c("FDR = 0.05","FDR = 0.10","FDR = 0.25"),
           col=c('black','black','black'),lty=2:4, cex=1)
    abline(h=-log10(0.05/nn),col="blue") ## bonferroni
  }
}

qqunif(mypvals, main = "QQplot DGN_WB Hutterites")
plot(obs["ERAP2",], pred["ERAP2",])
plot(obs["NBPF3",], pred["NBPF3",])
dev.off()
