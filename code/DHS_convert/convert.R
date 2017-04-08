library(foreign)

if (!exists("input_files"))
	stop("No input file defined for RTARGET")

df <- read.spss(input_files[[1]], to.data.frame=TRUE)
vl <- attr(df, "variable.labels")
