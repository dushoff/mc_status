names(vl) <- names(df)
Answers <- data.frame(row.names=rownames(df))
Questions <- character(0)
Dropped <- character(0)

for (n in names(df)){
	if(sum(!is.na(df[[n]])>0)){
		Answers[[n]] <- df[[n]]
		Questions[[n]] <- vl[[n]]
	} else {
		Dropped[[n]] <- vl[[n]]
	}
}
# rdsave(Answers, Questions, Dropped)
