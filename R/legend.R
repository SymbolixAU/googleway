resolveLegend <- function(legend, legend_options, colour_palettes){
  if(any(vapply(legend, isTRUE, T))){
    legend <- constructLegend(colour_palettes, legend)
    if(!is.null(legend_options)){
      legend <- addLegendOptions(legend, legend_options)
    }
  }
  return(legend)
}


constructLegend <- function(colour_palettes, legend){

  ## remove any colour_palettes not needed
  cp <- sapply(colour_palettes, function(x) names(x[['variables']]))

  legend <- flattenLegend(legend)

  cp <- cp[cp %in% legend]

  ## cp are now the valid colours
  lst <- lapply(colour_palettes, function(x){

    if(all(names(x[['variables']]) %in% cp)){

      ## format the palette - needs binning if it's gradient
      type <- getLegendType(x$palette[['variable']])
      x$palette <- formatPalette(x$palette, type)

      list(
        ## if both a fill and stroke are used, fill takes precedence
        colourType = ifelse('fill_colour' %in% names(x$variables), 'fill_colour', 'stroke_colour'),
        type = type,
        title = unique(x$variable),
        legend = x$palette,
        css = NULL,
        position = NULL
      )
    }
  })

  lst[sapply(lst, is.null)] <- NULL
  return(lst)
}

# Format Palette
#
# Formats the palette ready for the legend. A gradient palette is reduced
# to a selected number of 'bins'. A category legend is returned as-is
#
# @param palette the colour palette to format (returned from createColourPalettes())
# @param type the type of leged/palette (returned from getLegendType)
formatPalette <- function(palette, type){
  ## palette shoudl be a data.frame
  if(type == "gradient"){
    palette <- palette[with(palette, order(variable)), ]

    ## cut the palette
    rows <- 1:nrow(palette)
    rowRange <- range(rows)
    rw <- unique(round(pretty(rows, n = 5)))
    rw <- rw[rw >= rowRange[1] & rw <= rowRange[2]]
    if(rw[1] != 1) rw <- c(1, rw)
    if(rw[length(rw)] != nrow(palette)) rw <- c(rw, nrow(palette))
    #print(rw)
    palette <- palette[rw, ]
  }
  return(palette)
}

# Get Legned Type
# determins the type of legend to plot given the data
# @param colourColum
getLegendType <- function(colourColumn) UseMethod("getLegendType")

#' @export
getLegendType.numeric <- function(colourColumn) "gradient"

#' @export
getLegendType.default <- function(colourColumn) "category"



flattenLegend <- function(legend) UseMethod("flattenLegend")

#' @export
flattenLegend.list <- function(legend){
  legend <- unlist(legend)
  legend <- names(legend)[legend == T]
  return(legend)
}

#' @export
flattenLegend.logical <- function(legend){
  if(length(names(legend)) > 0){
    ## it's a named vector
    legend <- names(legend)[legend]
  }else{
    legend <- c("fill_colour", "stroke_colour")[legend]
  }
  return(legend)
}

# add legend options
#
# updates a legend with various options
#
# @param legend constructed from constructLegend()
# @param legend_options list of user defined legend options
addLegendOptions <- function(legend, legend_options){

  ## If any names of legend_options not in c("fill_colour", "stroke_colour")
  ## then those will be applied to all
  ## otherwise, it will be either a fill_colour or a stroke_colour
  nonAesthetics <- names(legend_options)[!names(legend_options) %in% c("fill_colour", "stroke_colour")]

  if(length(nonAesthetics) > 0){
    ## then we can't use the individual mappings
    legend <- lapply(legend, replaceLegendOption, legend_options)
  }else{
    ## apply the mappings directly to the aesthetics
    toMapDirectly <- names(legend_options)[names(legend_options) %in% c("fill_colour", "stroke_colour")]
    toMapDirectly <- toMapDirectly[vapply(toMapDirectly, function(x) is.list(legend_options[[x]]), T)]

    legend <- lapply(c("fill_colour", "stroke_colour"), function(x){
      idx <- which(vapply(legend, function(y) y$colourType == x, T))
      if(length(idx) > 0){
        replaceLegendOption(legend[[idx]], legend_options[[x]])
      }
    })
  }

  return(legend)
}

replaceLegendOption <- function(legend, legend_option){

  if(!is.null(legend_option[['title']]))
    legend[['title']] <- legend_option[['title']]

  if(!is.null(legend_option[['css']]))
    legend[['css']] <- legend_option[['css']]

  if(!is.null(legend_option[['position']]))
    legend[['position']] <- legend_option[['position']]

  if(!is.null(legend_option[['prefix']]))
    legend[['prefix']] <- legend_option[['prefix']]

  if(!is.null(legend_option[['suffix']]))
    legend[['suffix']] <- legend_option[['suffix']]

  return(legend)
}

