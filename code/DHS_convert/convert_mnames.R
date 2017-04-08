n <- names(df)
n <- sub("^MV", "V", n)
n <- sub("^SM", "S", n)
n <- sub("^FGM", "FG", n)
n <- sub("^MCASEID", "CASEID", n)
names(df) <- n
