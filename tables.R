library(ordinal)
library(splines)
library(dplyr)

# Answers <- subset(Answers, CC != "LS")

LSdat <- Answers %>% filter(survey=="LS4") %>% mutate(condom="NA")
noLSdat <- Answers %>% filter(survey != "LS4")
Ans2 <- rbind(LSdat,noLSdat)

Ans2 <- Ans2[complete.cases(Ans2),]
oldAns <- model.frame(
  condom ~ 
    ageGroup + urRural + religion + edu + job + maritalStat + extraPartnerYear + MC 
  + knowledgeCondomsProtect + knowledgeLessPartnerProtect + knowledgeHealthyGetAids 
  + period + mediaNpMg + mediaRadio + CC + mediaTv,
  data=Ans2, na.action=na.exclude, drop.unused.levels=TRUE
)


newAns <- model.frame(
  condom ~ 
    ageGroup + urRural + religion + edu + job + maritalStat + extraPartnerYear + MC 
  + knowledgeCondomsProtect + knowledgeLessPartnerProtect + knowledgeHealthyGetAids 
  + period + mediaNpMg + mediaRadio + CC + mediaTv,
  data=Ans2, na.action=na.exclude, drop.unused.levels=TRUE
)



old <- oldAns %>% filter(period=="Old")
new <- newAns %>% filter(period=="New")

old_table <- function(x){
  return(table(old[,x],old[,"CC"]))
}

new_table <- function(x){
  return(table(new[,x],new[,"CC"]))
}

predictorsOLD <- c("ageGroup","urRural","edu","religion","maritalStat","job","condom"
                   ,"extraPartnerYear", "MC","knowledgeCondomsProtect"
                   ,"knowledgeLessPartnerProtect", "knowledgeHealthyGetAids","mediaNpMg"
                   ,"mediaRadio","mediaTv")


predictorsNEW <- c("ageGroup","urRural","edu","religion","maritalStat","job","condom"
                ,"extraPartnerYear", "MC","knowledgeCondomsProtect"
                ,"knowledgeLessPartnerProtect", "knowledgeHealthyGetAids","mediaNpMg"
                ,"mediaRadio","mediaTv")


oldlist <- lapply(predictorsOLD,old_table)
newlist <- lapply(predictorsNEW,new_table)

combdf <- function(pred,lldf){
  tempdf <- as.data.frame.matrix(lldf)
  df <- data.frame(Category=pred,Sub_Category=rownames(tempdf),tempdf)
  return(df)
}

ddold <- data.frame()
ddnew <- data.frame()
for(i in seq_along(predictorsOLD)){
  ddold <- rbind(ddold,combdf(predictorsOLD[i],oldlist[[i]]))
}

for(i in seq_along(predictorsNEW)){
  ddnew <- rbind(ddnew,combdf(predictorsNEW[i],newlist[[i]]))
}
row.names(ddold) <- row.names(ddnew) <- NULL

ddold2 <- (ddold 
  %>% mutate(Total = KE+LS+MW+MZ+NM+RW+TZ+UG+ZM+ZW)
)


ddoldpercent <- (ddold2
  %>% group_by(Category)
  %>% mutate(Category2 = Sub_Category
  , KE = round(KE*100/sum(KE),1)
  , LS = round(LS*100/sum(LS),1)
  , MW = round(MW*100/sum(MW),1)
  , MZ = round(MZ*100/sum(MZ),1)
  , NM = round(NM*100/sum(NM),1)
  , RW = round(RW*100/sum(RW),1)
  , TZ = round(TZ*100/sum(TZ),1)
  , UG = round(UG*100/sum(UG),1)
  , ZM = round(ZM*100/sum(ZM),1)
  , ZW = round(ZW*100/sum(ZW),1)
  )
  %>% select(-c(Sub_Category))
)


ddold3 <- (ddold2
  %>% select(-Sub_Category)
  %>% group_by(Category)
  %>% summarise_each(funs(sum)) 
  %>% ungroup()
  %>% mutate(Category2=as.factor("Total"))
  %>% rbind.data.frame(ddoldpercent,.)
  %>% arrange(Category)
  %>% ungroup()
  %>% select(Category,Category2,KE:ZW,Total)
)

ddnew2 <- (ddnew 
  %>% mutate(Total = KE+LS+MW+MZ+NM+RW+TZ+UG+ZM+ZW)
)
ddnewpercent <- (ddnew2
  %>% group_by(Category)
  %>% mutate(Category2 = Sub_Category
    , KE = round(KE*100/sum(KE),1)
    , LS = round(LS*100/sum(LS),1)
    , MW = round(MW*100/sum(MW),1)
    , MZ = round(MZ*100/sum(MZ),1)
    , NM = round(NM*100/sum(NM),1)
    , RW = round(RW*100/sum(RW),1)
    , TZ = round(TZ*100/sum(TZ),1)
    , UG = round(UG*100/sum(UG),1)
    , ZM = round(ZM*100/sum(ZM),1)
    , ZW = round(ZW*100/sum(ZW),1)
    )
  %>% select(-c(Sub_Category))
)
ddnew3 <- (ddnew2
           %>% select(-Sub_Category)
           %>% group_by(Category)
           %>% summarise_each(funs(sum(.))) 
           %>% ungroup()
           %>% mutate(Category2=as.factor("Total"))
           %>% rbind.data.frame(ddnewpercent,.)
           %>% arrange(Category)
           %>% ungroup()
           %>% select(Category,Category2,KE:ZW,Total)
)

# knitr::kable(ddold3,format="latex",digits=3,align="l")
# knitr::kable(ddnew3,format="latex",digits=3,align="l")

oldtotal <- (ddold3
	%>% filter(Category2 == "Total")
	%>% select(Total)
	%>% filter(row_number()==1)
)

newtotal <- (ddnew3
	%>% filter(Category2 == "Total")
	%>% select(Total)
	%>% filter(row_number()==1)
)


ddold4 <- ddold3 %>% mutate(totalper = round(Total*100/oldtotal[[1]],1))
ddnew4 <- ddnew3 %>% mutate(totalper = round(Total*100/newtotal[[1]],1))

print(ddold4)
print(ddnew4)
