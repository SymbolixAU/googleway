
# Data Table Column
#
# Creates the javascript that's used in a Google Data Table Visualisation from
# the specified columns of a data.frame
#
# @param df data.frame
# @param cols columns
#
# @return \code{data.frame} with one row of JSON against each ID
DataTableColumn <- function(df, id, cols){

  ## TODO:
  ## different types of charts:
  ## - area, only numeric columns, needs a 'label' that's also not the ID

  ## in the chartList, pass in 'dataColumns' and 'labelColumn'
  info_window <- vapply(1:nrow(df), function(x) jsonlite::toJSON( list("c" =  df[x, cols] )), "")
  df$info_window <- gsub(paste0(cols, collapse = "|"), replacement = "v", gsub(",","},{",info_window))
  df <- stats::aggregate(stats::formula(paste0("info_window ~ ", id)), data = df, FUN = collapseJson)
  return(df)
}


# Data Table Headings
#
# Creates the javascript that's required for the headings of a javascript
# DataTable
#
# @param df data.frame
DataTableHeading <- function(df, cols){
  v <- vapply(df[, cols], JsonType, "")
  return(paste0('"cols":[{', paste0('"id":"', names(v), '",',
                                    '"label":"', names(v), '",',
                                    '"type":"', v, '"', collapse = "},{"), '}]'))
}



DataTableArray <- function(df, id, cols) {

  ## each row will be an array
  ## the first row will be the headings and types

  df[['info_window']] <- vapply(1:nrow(df), function(x) {
    gsub("^\\[|\\]$", "", jsonlite::toJSON(unname(df[x, cols])))
    } , "")

  headings <- jsonlite::toJSON(cols)

  dataArray <- stats::aggregate(stats::formula(paste0("info_window ~ ", id) ),
                         data = df,
                         FUN = collapseJson)

  dataArray <- paste0("[", headings, ",", dataArray[['info_window']], "]")

  return(dataArray)
}


collapseJson <- function(x) paste0(x, collapse = ",")

JsonType <- function(x) UseMethod("JsonType")

#' @export
JsonType.character <- function(x) return("string")
#' @export
JsonType.Date <- function(x) return("string")
#' @export
JsonType.factor <- function(x) return("string")
#' @export
JsonType.integer <- function(x) return("number")
#' @export
JsonType.logical <- function(x) return("boolean")
#' @export
JsonType.numeric <- function(x) return("number")
#' @export
JsonType.POSIXct <- function(x) return("string")
#' @export
JsonType.default <- function(x) return("string")
