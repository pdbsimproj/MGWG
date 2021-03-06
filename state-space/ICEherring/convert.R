## convert_VPA_ICES
## convert VPA rdat file to ICES input format for use in SAM
## created 10 Sep 2018 Arni Magnusson
## based on comments found in convert_VPA_ICES.r

source("../helper_code/convert_VPA_ICES.r")
suppressWarnings(dir.create("ices_data"))  # dest dir

################################################################################
## Icelandic herring

ices.dir <- "./"
ices.base <- "ices_data/"

vpa.dir <- "./"
vpa.file <- "RUN1NWWG.RDAT"

vpa <- dget(paste0(vpa.dir,vpa.file))

start.yr <- vpa$genparms$minyear
end.yr <- vpa$genparms$maxyear
minage <- vpa$genparms$minage
nages <- vpa$genparms$nages

## Have to figure this out for each stock
ind.mats.all <- vpa$surveyobs
## Survey offset year (see notes in offset.txt)
ind.mats.all <- ind.mats.all[-1,]
rownames(ind.mats.all) <- as.integer(rownames(ind.mats.all)) - 1
## Survey offset done
ind.mats <- list()
ind.mats$n <- 1
ind.mats$names <- "Acoustic"
ind.mats$start.year <- 1987
ind.mats$end.year <- 2016
ind.mats$start.age <- 3
ind.mats$end.age <- 10
ind.mats$timing <- 0
use.cols.start <- 1
use.cols.end <- 8
for (i in 1:ind.mats$n){
  ind.mats$ob[[i]] <- ind.mats.all[rownames(ind.mats.all) %in%
                                   seq(ind.mats$start.year[i],
                                       ind.mats$end.year[i]),
                                   colnames(ind.mats.all) %in%
                                   seq(use.cols.start[i],
                                       use.cols.end[i])]
  colnames(ind.mats$ob[[i]]) <- seq(ind.mats$start.age[i], ind.mats$end.age[i])
}

write.cn(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchnumbers, minage)
write.cw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt, minage)
write.dw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt, minage)
write.lf(ices.dir, ices.base, start.yr, end.yr, nages, minage)
write.lw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$catchwt, minage)
write.mo(ices.dir, ices.base, start.yr, end.yr, nages, vpa$maturity, minage)
write.nm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$natmort, minage)
write.pf(ices.dir, ices.base, start.yr, end.yr, nages, vpa$fspawn, minage)
write.pm(ices.dir, ices.base, start.yr, end.yr, nages, vpa$mspawn, minage)
write.survey(ices.dir, ices.base, start.yr, end.yr, nages, ind.mats)
write.sw(ices.dir, ices.base, start.yr, end.yr, nages, vpa$spstockwt, minage)

from <- paste0(ices.base, dir(ices.base))  # single slash
to <- sub("/_", "/", from)
file.rename(from, to)
