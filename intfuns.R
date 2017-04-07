ff <- function(mod, frame, v1, v2,
               dfspec=100, level=0.05, isolate=FALSE){
  
  ordTrans <- function(v, a){
    sapply(v, function(n){
      return(sum(plogis(n-a)))
    })
  }
  
  eff <- function(mod) {
    if (inherits(mod, "lm")) 
      return(coef(mod))
    if (inherits(mod, "mer")) 
      return(fixef(mod))
    if (inherits(mod, "clmm")) {
      ef <- c(0, mod$beta)
      names(ef) <- c("(Intercept)", names(mod$beta))
      return(ef)
    }
    stop(paste("eff does not recognize model class", 
               class(mod), collapse=" "
    ))
  }
  
  df <- ifelse(
    grepl("df.residual", paste(names(mod), collapse="")), 
    mod$df.residual, dfspec
  )
  mult <- qt(1-level/2, df)
  
  # Eliminate rows that were not used
  rframe <- frame[rownames(model.frame(mod)), ]
  names(rframe) <- fnames <- names(frame)
  attr(rframe,"terms") <- NULL  ## clean out terms attribute
  
  findVar <- function(vname, fnames){
    pat <- paste("\\b", vname, sep="")
    fCol <- grep(pat, fnames)
    
    if(length(fCol)<1) {
      stop(paste("No matches to",
                 varname, "in the frame", collapse=" ")
      )
    }
    print(paste("Selected variable", fnames[fCol]))
    if(length(fCol)>1) {
      stop(paste("Too many matches:", fnames[fCol], collapse=" "))
    }
    return(fCol)
  }
  
  c1 <- findVar(v1, fnames)
  c2 <- findVar(v2, fnames)
  
  findCols <- function(vlist, mmNames){
    mlist <- lapply(vlist, function(v){
      pat <- paste("\\b", v, sep="")
      mmCols <- grep(pat, mmNames)
      if (length(mmCols)<1) 
        stop(paste("No matches to", 
                   v, "in the model matrix", collapse=" "))
      return(mmCols)
    })
    mmCols <- union(mlist[[1]], mlist[[2]])
    print(paste(c("Selected columns:",
                  mmNames[mmCols], "from the model matrix"), collapse=" ")
    )
    return(mmCols)
  }
  
  # Make model matrix and select columns
  modTerms <- delete.response(terms(mod))
  mm <- model.matrix(modTerms, rframe)
  mmNames <- colnames(mm)
  mmCols <- findCols(c(v1, v2), mmNames)
  
  # Model matrix with levels of focal variables 
  lframe <- function(f, c1, c2){
    lv1 <- levels(f[[c1]])
    lv2 <- levels(f[[c2]])
    l1 <- length(lv1)
    l2 <- length(lv2)
    varframe <- f[rep(1, l1*l2), ]
    varframe[[c1]] <- gl(l1, l2, l1*l2, labels=lv1)
    varframe[[c2]] <- gl(l2, 1, l1*l2, labels=lv2)
    names(varframe) <- names(f)
    return(varframe)
  }
  
  varframe <- lframe(rframe, c1, c2)
  
  # Mean row of model matrix
  rowbar<-matrix(apply(mm, 2, mean), nrow=1)
  mmbar<-rowbar[rep(1, nrow(varframe)), ]
  
  # A model matrix with mean rows except for the variables of interest
  mmvar <- mmbar
  mmnew <- model.matrix(modTerms, varframe)
  for(c in mmCols){
    mmvar[, c] <- mmnew[, c]
  }
  
  ef <- eff(mod)
  vc <- vcov(mod)
  if (inherits(mod, "clmm")) {
    f <- c(names(mod$alpha)[[1]], names(mod$beta))
    vc <- vc[f, f]
  }
  if (!identical(colnames(mm), names(ef))) {
    print(setdiff(colnames(mm), names(ef)))
    print(setdiff(names(ef), colnames(mm)))
    stop("Effect names do not match: check for empty factor levels?")
  }
  
  pred <- mmvar %*% ef
  
  # (Centered) predictions for SEs
  if (isolate) {
    mmvar <- mmvar-mmbar
  }
  
  pse_var <- sqrt(diag(mmvar %*% tcrossprod(vc, mmvar)))
  
  print(mod$alpha)
  
  pf <- data.frame(
    f1 = varframe[[c1]],
    f2 = varframe[[c2]],
    fit = ordTrans(pred, mod$alpha),
    lwr = ordTrans(pred-mult*pse_var, mod$alpha),
    upr = ordTrans(pred+mult*pse_var, mod$alpha),
    rawfit = pred,
    rawlwr = pred-mult*pse_var,
    rawupr = pred+mult*pse_var
  )
  
  names(pf)[1:2] <- names(varframe)[c(c1, c2)]
  return(pf)
}