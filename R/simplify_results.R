
collapseResult <- function(res) paste0(res, collapse = "")

resultType <- function(res) UseMethod("resultType")

#' @export
resultType.character <- function(res) collapseResult(res)

#' @export
resultType.list <- function(res) return(res)

#' @export
resultType.default <- function(res) stopMessage(res)









