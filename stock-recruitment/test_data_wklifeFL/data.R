

# load libraries
library(FLCore)
library(ggplotFL)
library(tidyr)

# read in operating models from wklifeFL package
load("../wklifeFL/data/stks.RData")

# pick a stock
stk_name <- "pol-nsea_rollercoaster"
stk <- stks[[stk_name]]

# stock summary
metrics(stk)
plot(metrics(stk)) + facet_wrap(qname ~ ., ncol = 2, scales = "free")

# plot harvest rate
#plot(stk@harvest) + facet_wrap(year ~ age, ncol = 3, scales = "free")
xyplot(data ~ age | factor(year), data = iterMedians(harvest(stk)),
       type = "l",
       scales = list(relation = "free"))


# create index
ages <- 1:dims(stk)$age

# set selectivity at a50 of maturity
mat <- c(iterMedians(mat(stk)[,1]))
a50_pars <- coef(glm(mat ~ ages, family = binomial))
a50 <- unname(-1 * a50_pars[1] / a50_pars[2])

catchability <-

indx <-


# write out stock
i <- 1
stk_i <- stk[,,,,,i]
FLCore::writeFLStock(stk_i, output.file = paste0(stk_name, "_", i))



