library(dplyr)


Country <- (ddnew4 
  %>% filter(Category2=="Total") 
  %>% filter(row_number()==1)
  %>% select(-c(Category,Category2,totalper))
)


cat("\\bf{Survey Year} & 2014 & 2014 & 2010 & 2011 & 2013 & 2014-15 & 2010 & 2011 & 2013-14 & 2011 & \\\\"
    , "\\bf{Sample Size} &" , latex(Country) ## sample size 
    , "\\bf{Category (in percentage)}", spaces
    , hline
    , "\\bf{Age Group}" , spaces
    , latex(dfill(ddnew4,"ageGroup"))
    , "\\bf{Residence}" , spaces
    , latex(dfill(ddnew4,"urRural"))
    , "\\bf{Education}" , spaces
    , latex(dfill(ddnew4,"edu"))
    , "\\bf{Religion}" , spaces 
    , latex(dfill(ddnew4,"religion"))
    , "\\bf{Marital Status}" , spaces
    , latex(dfill(ddnew4,"maritalStat"))
    , "\\bf{Job}" , spaces
    , latex(dfill(ddnew4,"job"))
    , "\\bf{Condom Usage at Last Sex}" , spaces
    , latex(dfill(ddnew4,"condom"))
    , "\\bf{Non-cohabiting Partners}" , spaces
    , latex(dfill(ddnew4,"extraPartnerYear"))
    , "\\bf{Circumcised}" , spaces
    , latex(dfill(ddnew4,"MC"))
    , "\\bf{HIV Knowledge}" , spaces
    , space , "\\bf{Condoms Protect}" , spaces
    , latex(dfill(ddnew4,"knowledgeCondomsProtect"),space=TRUE)
    , space , "\\bf{Less Partner Protect}" , spaces
    , latex(dfill(ddnew4,"knowledgeLessPartnerProtect"),space=TRUE)
    , space , "\\bf{Healthy People Get Aids}" , spaces
    , latex(dfill(ddnew4,"knowledgeHealthyGetAids"),space=TRUE)
    , hline
    , "\\bf{Media}" , spaces
    , space , "\\bf{Newspaper and Magazines}" , spaces
    , latex(dfill(ddnew4,"mediaNpMg"),space=TRUE)
    , space , "\\bf{Radio}" , spaces
    , latex(dfill(ddnew4,"mediaRadio"),space=TRUE)
    , space , "\\bf{TV}" , spaces
    , latex(dfill(ddnew4,"mediaTv"),space=TRUE)
    , file="new_table.tex")

