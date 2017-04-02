
SimplifyCheck <- function(simplify){
  if(!is.logical(simplify))
    stop("simplify must be logical - TRUE or FALSE")
}


LogicalCheck <- function(param){
  if(!is.logical(param))
    stop(paste0(deparse(substitute(param))," must be logical - TRUE or FALSE"))
}

