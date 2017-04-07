library(ordinal)
library(splines)
library(ggplot2)
theme_set(theme_bw())

mcs <- ff(mod, modAns, "MC", "period", isolate=TRUE)

resp <- unlist(strsplit(rtargetname,"_"))[1]
if(resp == "condomStatus"){resp = "Condom Usage At Last Sex"}
if(resp == "partnerYearStatus"){resp = "Non-Cohabiting Partners"}

mcs$period <- factor(mcs$period,levels=c("old","new"),labels=c("Pre","Post"))

# Use the same width for error bars and for dodge offset
ww <- 0.15

g <- ggplot(mcs,
            aes(x=period, y=(fit), color=MC, group=MC)
) +ylab(resp) + scale_colour_discrete(guide=guide_legend(title = "Circumcised")) + xlab("Period")

ge <- (g + 
         geom_errorbar(
           aes(ymin=(lwr), ymax=(upr)), 
           width=ww, position = position_dodge(width=ww)
         )
       + geom_point(position = position_dodge(width=ww))
       + geom_line(position = position_dodge(width=ww))
)
print(ge)

#rdsave(mcs, mod, modAns)
