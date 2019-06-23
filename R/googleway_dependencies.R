## from htmltools::htmlDependency()
createHtmlDependency <- function(name, version, src, script = NULL, stylesheet = NULL, all_files = FALSE) {
  structure(
    list(
      name = name
      , version = version
      , src = list( file = src )
      , meta = NULL
      , script = script
      , stylesheet = stylesheet
      , head = NULL
      , attachment = NULL
      , package = NULL
      , all_files = all_files
    )
    , class = "html_dependency"
  )
}

addDependency <- function(map, dependencyFunction) {

  existingDeps <- sapply(map$dependencies, function(x) x[['name']])
  addingDependency <- sapply(dependencyFunction, function(x) x[['name']])

  if(!addingDependency %in% existingDeps)
    map$dependencies <- c(map$dependencies, dependencyFunction)

  return(map)
}
