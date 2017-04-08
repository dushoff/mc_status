library(shapefiles)

if (!exists("input_files"))
	stop("No input file defined for RTARGET")

gps <- read.dbf(input_files[[1]])[[1]]
