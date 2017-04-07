library(dplyr)


Country <- (ddold4 
  %>% filter(Category2=="Total") 
  %>% filter(row_number()==1)
  %>% select(-c(Category,Category2,totalper))
)

print(dfill(ddold4,"extraPartnerYear"))
print(latex(dfill(ddold4,"extraPartnerYear")))

cat("\\bf{Survey Year} & 2003 & 2004 & 2004 & 2003 & 2006-7 & 2005 & 2004-5 & 2006 & 2007 & 2005-6 & \\\\"
  , "\\bf{Sample Size} &" , latex(Country) ## sample size 
  , "\\bf{Category (in percentage)}", spaces
  , hline
  , "\\bf{Age Group}" , spaces
  , latex(dfill(ddold4,"ageGroup"))
  , "\\bf{Residence}" , spaces
  , latex(dfill(ddold4,"urRural"))
  , "\\bf{Education}" , spaces
  , latex(dfill(ddold4,"edu"))
  , "\\bf{Religion}" , spaces 
  , latex(dfill(ddold4,"religion"))
  , "\\bf{Marital Status}" , spaces
  , latex(dfill(ddold4,"maritalStat"))
  , "\\bf{Job}" , spaces
  , latex(dfill(ddold4,"job"))
  , "\\bf{Condom Usage at Last Sex}" , spaces
  , latex(dfill(ddold4,"condom"))
  , "\\bf{Non-cohabiting Partners}" , spaces
  , latex(dfill(ddold4,"extraPartnerYear"))
  , "\\bf{Circumcised}" , spaces
  , latex(dfill(ddold4,"MC"))
  , "\\bf{HIV Knowledge}" , spaces
  , space , "\\bf{Condoms Protect}" , spaces
  , latex(dfill(ddold4,"knowledgeCondomsProtect"),space=TRUE)
  , space , "\\bf{Less Partner Protect}" , spaces
  , latex(dfill(ddold4,"knowledgeLessPartnerProtect"),space=TRUE)
  , space , "\\bf{Healthy People Get Aids}" , spaces
  , latex(dfill(ddold4,"knowledgeHealthyGetAids"),space=TRUE)
  , hline
  , "\\bf{Media}" , spaces
  , space , "\\bf{Newspaper and Magazines}" , spaces
  , latex(dfill(ddold4,"mediaNpMg"),space=TRUE)
  , space , "\\bf{Radio}" , spaces
  , latex(dfill(ddold4,"mediaRadio"),space=TRUE)
  , space , "\\bf{TV}" , spaces
  , latex(dfill(ddold4,"mediaTv"),space=TRUE)
  , file="old_table.tex")

