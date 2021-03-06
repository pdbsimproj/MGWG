stdline <- function(x, lwd=2, col=1, from=NULL, to=NULL, ...)
{
  if(!is.null(from))
    x <- x[as.integer(names(x)) >= from]
  if(!is.null(to))
    x <- x[as.integer(names(x)) <= to]
  lines(as.integer(names(x)), x, lwd=lwd, col=col, ...)
}

## Example
## plot(NA, xlim=c(1,15), ylim=c(0,16), yaxs="i",
##      xlab="Age", ylab="Weight (kg)", main="Average weight")
## x <- 3:15 - runif(3:15)
## names(x) <- 3:15
## stdline(x, 2, "orange")
