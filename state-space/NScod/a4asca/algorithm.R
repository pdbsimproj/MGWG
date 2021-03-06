#####################################################################
# 20180910 EJ
#
# Running stock assessments for WGMG 2018 projects
#####################################################################

library(RMGWG)
library(ggplotFL)

#====================================================================
# read data
#====================================================================

setwd('../')
idxs <- readFLIndices('survey.dat')
idxs <- window(idxs, end=2016)
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- window(stk, end=2016, start=1983)
stk <- setPlusGroup(stk, 6)
range(stk)[c('minfbar','maxfbar')] <- c(2,4)
setwd('a4asca')

#====================================================================
# default model
#====================================================================

qmod <- list(~s(age, k=4), ~s(age, k=3))
fmod <- ~te(age, year, k = c(4, 17), bs = "tp") + s(age, k = 5)
fit <- sca(stk, idxs, qmodel=qmod, fmodel=fmod)
stk.retro <- retro(stk, idxs, retro=7, qmodel=qmod, k=c(age=4, year=17, age2=5), ftype='te')
fit.rm <- mohn(stk.retro)
fit.pi <- predIdxs(stk, idxs)
fitmc <- sca(stk, idxs, fit='MCMC', mcmc=SCAMCMC(mcmc=250000), qmodel=qmod, fmodel=fmod)
dumpTab1(stk, idxs, fitmc, predIdxs=fit.pi, mohnRho=fit.rm, prefix='te')

#====================================================================
# separable model
#====================================================================

fmod <- ~s(age, k=5) + s(year, k=17)
fitsep <- sca(stk, idxs, fmodel=fmod)
stksep.retro <- retro(stk, idxs, retro=7, fmodel=fmod)
fitsep.rm <- mohn(stksep.retro)
fitsep.pi <- predIdxs(stk, idxs, fmodel=fmod)
fitsepmc <- sca(stk, idxs, fmodel=fmod, fit='MCMC', mcmc=SCAMCMC(mcmc=250000))
dumpTab1(stk, idxs, fitsepmc, predIdxs=fitsep.pi, mohnRho=fitsep.rm, prefix='sep')


