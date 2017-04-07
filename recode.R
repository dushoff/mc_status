cat("##############################################\n")
print(rtargetname)
cat("##############################################\n")

library(gdata)
library(dplyr)

Answers <- (Answers
  %>% mutate(religion = tableRecode(religion, "religion", maxCat=4) # 
   , religion = factor(religion,levels=c(levels(religion), "Tanzanian")))
)

# HIV knowledge and dummy coding Tanzanian religion
Answers <- within(Answers, {
  religion[survey=="TZ5"] <- "Tanzanian"
  if(sum(!is.na(knowledgeCondomsProtect))>0){
    levels(knowledgeCondomsProtect)[levels(knowledgeCondomsProtect)=="Reduce chances of AIDS by always using condoms during sex"] <- "Yes"}
  if(sum(!is.na(knowledgeLessPartnerProtect))>0){
    levels(knowledgeLessPartnerProtect)[levels(knowledgeLessPartnerProtect)=="Reduce chance of AIDS: have 1 sex partner with no oth partner"] <- "Yes"
    levels(knowledgeLessPartnerProtect)[levels(knowledgeLessPartnerProtect)=="Reduce chance of AIDS: have 1 sex partner with no other partn"] <- "Yes"
    levels(knowledgeLessPartnerProtect)[levels(knowledgeLessPartnerProtect)=="Reduce chance of AIDS: have 1 sex partnr with no other partn"] <- "Yes"
    levels(knowledgeLessPartnerProtect)[levels(knowledgeLessPartnerProtect)=="Reduce chance of AIDS: have 1 sex partnr with no oth partner"] <- "Yes"}
  if(sum(!is.na(knowledgeHealthyGetAids))>0){
    levels(knowledgeHealthyGetAids)[levels(knowledgeHealthyGetAids)=="DK"] <- "Don't know"
    levels(knowledgeHealthyGetAids)[levels(knowledgeHealthyGetAids)=="Don't know anyone with AIDS"] <- NA}
})


Answers <- (Answers
  ## Reweight before subsetting.
	%>% mutate(sampleWeight = sampleWeight/sum(sampleWeight)) ## Why do we need this? We don't even use it: "grep sampleWeight *" in repo
  # Drop people whose age is older than 49.
	%>% filter(age <= 49)
  # Don't want people who haven't heard of HIV, don't know their circ history or have never had sex
	%>% filter(!is.na(heardHIV) & heardHIV=="Yes")
	%>% filter(!is.na(recentSex) & !grepl("Never", recentSex))
  %>% filter(!is.na(MC) & !(MC=="Don't know") & !(MC=="DK") & !(MC=="DK/Not sure"))
  %>% transmute(survey = survey ## keep just these variables
  , clusterID = as.factor(clusterId) 
  , clusterId = as.factor(paste(survey, clusterID, sep="_")) 
  , age = age
  , ageGroup = ageGroup
  , urRural = urRural
  , edu = edu
  , religion = religion
  , mediaNpMg = mediaNpMg
  , mediaRadio = mediaRadio
  , mediaTv = mediaTv 
  , job = job
  , knowledgeCondomsProtect = knowledgeCondomsProtect
  , knowledgeLessPartnerProtect = knowledgeLessPartnerProtect
  , knowledgeHealthyGetAids = knowledgeHealthyGetAids
  , wealth = wealth/100000
  , maritalStat = tableRecode(maritalStat, "partnership", maxCat=5)
  , condom = drop.levels(condom, reorder=FALSE)
  , MC = drop.levels(MC, reorder=FALSE)
  , CC = as.factor(substring(survey, 1, 2))
  , recode = as.numeric(substring(survey, 3, 3))
  , partnerYear = tfun(partnerYear, 3) ## avoid warning message by entering the number
  , extraPartnerYear = as.factor(ifelse(partnerYear==0, 0, partnerYear-1))
  , extraPartnerYear = factor(extraPartnerYear,levels=0:2,labels=c("0","1",">1"))
  )
  %>% select(-c(partnerYear))
)



# rdsave(Answers)
