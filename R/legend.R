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

    print(rw)

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


constructLegend <- function(colour_palettes){

  lapply(colour_palettes, function(x){

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
  })

}

# add legend options
#
# updates a legend with various options
#
# @param legend constructed from constructLegend()
# @param legend_options list of user defined legend options
addLegendOptions <- function(legend, legend_options){

  ## TODO:
  ## - if the legend_options is a single unnamed list, update all the legends
  ## - if the legend is a named list, update the specific legends

  ## if named list, check those names exist in the legend
  ##
  ## will only work if these elements are also lists
  toMapDirectly <- names(legend_options)[names(legend_options) %in% c("fill_colour", "stroke_colour")]
  toMapDirectly <- toMapDirectly[vapply(toMapDirectly, function(x) is.list(legend_options[[x]]), T)]

  if(length(toMapDirectly) > 0){
    ## there are some options to mape directly to legend elements
    ## this will udpate the elements with the options directly
    # aesthetic <- toMapDirectly[1]
    # idx <- which(vapply(legend, function(x) x$colourType == aesthetic, T))
    # legend[[idx]]
    # legend_options[[aesthetic]]

    ## valid options
    ## title, css, position, prefix, suffix
    #legend[[idx]] <- replaceLegendOption(legend[[idx]], legend_options[[aesthetic]])

    legend <- lapply(toMapDirectly, function(x){
      idx <- which(vapply(legend, function(y) y$colourType == x, T))
      replaceLegendOption(legend[[idx]], legend_options[[x]])
    })
  }

  ## if legend_options are not named either fill or stroke, they get applied
  ## to ALL legend elements

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

