library(ordinal)
library(splines)
library(gridExtra)
library(dplyr)
library(ggplot2)
library(reshape)
theme_set(theme_bw())
attr(modAns,"terms") <- NULL 

predNames <- c("age", "wealth","CC", "religion", "edu", "urRural", "job",
           "maritalStat", "media", "knowledge","MC","period")

# predNames <- c("CC", "religion")

catNames <- c("CC","religion","urRural","job","maritalStat","MC","period")

# catNames <- c("CC","religion")

BSmat <- function(x){
  Smat <- diag(length(coef(x)))
  rownames(Smat) <- colnames(Smat) <- attr(coef(x),"name")
  return(Smat)
}

Smat <- BSmat(mod)

dd <- data.frame(model.matrix(delete.response(terms(mod)), modAns[rownames(model.frame(mod)), ]))
ddTZ4 <- (dd 
  %>% filter(CCTZ == 1) 
  %>% filter(religionTanzanian==0)
  %>% summarise_each(funs(mean))
)

if(nrow(Smat)!= length(ddTZ4)){
  ddTZ4 <- data.frame(0,ddTZ4)
}
Smat["CCTZ",grep(pattern="religion",colnames(Smat))] <- -1
Smat["CCTZ",] <- unlist(ddTZ4 * Smat["CCTZ",])


isoList <- lapply(predNames, function(n){
  ordpred(mod, n, modAns,Smat)
})

respLab <- "                                       Non-Cohabiting Partners"
if(rtargetname=="condomStatus_isoplots"){
  respLab <- "                                    Condom Usage At Last Sex"
}

## Relevel  factors into the order we want for religion and marital status... should definitely do it upstream
isoList[[4]] <- (isoList[[4]]
  %>% mutate(religion = factor(religion,levels=c("Catholic/Orthodox", "Other Christian", "Muslim","None/Other", "Tanzanian")))
)

isoList[[8]] <- (isoList[[8]]
  %>% mutate(maritalStat = factor(maritalStat, levels=c("Married", "Partnered", "Separated","Widowed", "Never")))
)

isoList[[12]] <- (isoList[[12]]
  %>% mutate(period = factor(period,levels=c("old", "new"),labels=c("Pre","Post")))
)


print(
grid.arrange(varPlot(rename(isoList[[1]],c(age="Age")),P=varlvlsum$`Pr(>Chisq)`[1],ylab=""),
             varPlot(rename(isoList[[2]],c(wealth="Wealth")),P=varlvlsum$`Pr(>Chisq)`[2],ylab=""),
             varPlot(rename(isoList[[3]],c(CC="Country")),P=varlvlsum$`Pr(>Chisq)`[3],ylab=""),
             varPlot(rename(isoList[[4]] %>% filter(religion != "Tanzanian"),c(religion="Religion")),P=varlvlsum$`Pr(>Chisq)`[4],ylab=""),
             varPlot(rename(isoList[[5]],c(edu="Education")),P=varlvlsum$`Pr(>Chisq)`[5],ylab=""),
             varPlot(rename(isoList[[6]],c(urRural="Residence")),P=varlvlsum$`Pr(>Chisq)`[6],ylab=""),
             varPlot(rename(isoList[[7]],c(job="Job")),P=varlvlsum$`Pr(>Chisq)`[7],ylab=respLab),
             varPlot(rename(isoList[[8]],c(maritalStat="Marital Status")),P=varlvlsum$`Pr(>Chisq)`[8],ylab=""),
             varPlot(rename(isoList[[9]],c(media="Media")),P=varlvlsum$`Pr(>Chisq)`[9],ylab=""),
             varPlot(rename(isoList[[10]],c(knowledge="Knowledge")),P=varlvlsum$`Pr(>Chisq)`[10],ylab=""),
             varPlot(rename(isoList[[11]],c(MC="Circumcised")),P=varlvlsum$`Pr(>Chisq)`[11],ylab=""),
             varPlot(rename(isoList[[12]],c(period="Period")),P=varlvlsum$`Pr(>Chisq)`[12],ylab=""),
             nrow=4)
)

#rdsave(isoList,varlvlsum)