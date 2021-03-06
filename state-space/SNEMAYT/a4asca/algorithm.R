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
idxs <- readFLIndices('SNEMAYT_survey.dat')
stk <- readFLStock('index.low', no.discards = TRUE)
stk <- setPlusGroup(stk, 6)
range(stk)[c('minfbar','maxfbar')] <- c(4,5)

# replace 0 with half of the minimum
catch.n(stk)[catch.n(stk)==0] <- min(catch.n(stk)[catch.n(stk)!=0])/2
idxs <- lapply(idxs, function(x){
	index(x)[index(x)==0] <- min(index(x)[index(x)!=0])/2
	x
})

setwd('a4asca')

#====================================================================
# default model
#====================================================================

qmod <- list(~s(age, k=3), ~s(age, k=3))
fit <- sca(stk, idxs, qmodel=qmod)
stk.retro <- retro(stk, idxs, retro=7, qmodel=qmod)
fit.rm <- mohn(stk.retro)
fit.pi <- predIdxs(stk, idxs, qmodel=qmod)
fitmc <- sca(stk, idxs, fit='MCMC', mcmc=SCAMCMC(mcmc=250000), qmodel=qmod)
dumpTab1(stk, idxs, fitmc, predIdxs=fit.pi, mohnRho=fit.rm, prefix='te')

#====================================================================
# separable model
#====================================================================

fmod <- ~s(age, k=4) + s(year, k=20)
fitsep <- sca(stk, idxs, fmodel=fmod, qmodel=qmod)
stksep.retro <- retro(stk, idxs, retro=7, fmodel=fmod, qmodel=qmod)
fitsep.rm <- mohn(stksep.retro)
fitsep.pi <- predIdxs(stk, idxs, fmodel=fmod, qmodel=qmod)
fitsepmc <- sca(stk, idxs, fmodel=fmod, fit='MCMC', mcmc=SCAMCMC(mcmc=250000), qmodel=qmod)
dumpTab1(stk, idxs, fitsepmc, predIdxs=fitsep.pi, mohnRho=fitsep.rm, prefix='sep')

