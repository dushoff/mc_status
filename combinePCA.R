cat("##############################################\n")
print(rtargetname)
cat("##############################################\n")

for (env in envir_list){
	scores <- data.frame(row.names=row.names(env[["scores"]]))
	scores[[env[["catname"]]]] <- env[["scores"]]$PC1
	Answers <- merge(
		Answers, scores, by="row.names", sort=FALSE, all=TRUE
	)
	rownames(Answers) <- Answers$Row.names
	Answers <- Answers[-1]
}

print(summary(Answers))

# rdsave(Answers)
