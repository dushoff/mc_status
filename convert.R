library(foreign)

if (!exists("input_files"))
	stop(paste("No input file defined for", rtargetname)

df <- read.spss(input_files[[1]], to.data.frame=TRUE)
vl <- attr(df, "variable.labels")
