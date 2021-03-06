# functions.R - DESC
# /functions.R

# Copyright European Union, 2018
# Author: Iago Mosqueira (EC JRC) <iago.mosqueira@ec.europa.eu>
#
# Distributed under the terms of the European Union Public Licence (EUPL) V.1.1.

#' data(ple4)
#' mnlnoise(100, catch.n(ple4), log(catch(ple4)), 10)
#' mnlnoise(100, catch.n(ple4), 0.5, 10)

mnlnoise <- function(n, numbers, sdlog, ess) {

  # COMPUTE annual totals
  totals <- quantSums(numbers)

  # ess / sdlog
  if(!is(sdlog, "FLQuant"))
    sdlog <- totals %=% sdlog
  if(!is(ess, "FLQuant"))
    ess <- totals %=% ess

  # COMPUTE proportion at age
  proportions <- numbers %/% totals

  ## add log normal error to totals
  totals_obs <- rlnorm(n = n, meanlog = log(totals), sdlog = sdlog)

  ## add multinomial error to age comps
  if(dim(proportions)[6] == 1)
    proportions_obs <- propagate(proportions, n)
  else
    proportions_obs <- proportions

  # APPLY by year and iter
  for(i in seq(dim(proportions)[2])) {
    # for(j in seq(dim(proportions)[6])) {
    for(j in seq(max(n, dim(proportions)[6]))) {

      proportions_obs[,i,,,,j] <- 
      # rmultinom(n,
        stats::rmultinom(1,
          # size
          c(iter(ess[,i], j)),
          # prob)
          c(iter(proportions[,i],j))) / c(iter(ess[,i],j))
    }
  }

  # compute observed numbers
  proportions_obs %*% totals_obs
}
