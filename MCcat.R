library(ordinal)
library(ggplot2)

isoList[[10]]$MCCategory <- factor(isoList[[10]]$MCCategory,levels=c("No","Old","New"))
print(varPlot(isoList[[10]],P=varlvlsum$`Pr(>Chisq)`[10]))