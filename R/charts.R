## TODO: CORECHARTS
## - Diff
## - Intervals
## - SteppedArea


#' Google Charts
#'
#' Google Charts can be displayed inside an \code{info_window}
#'
#' @section `info_window`:
#'
#' When using a chart in an `info_window` you need to use a `list` with at least
#' two elements named `data` and `type`. You can also use a third element called `options`
#' for controlling the appearance of the chart.
#'
#' You must also supply the `id` argument to the layer your are adding (e.g. `add_markers()`),
#' and the **`data`** must have a column with the same name as the `id` (and therefore
#' the same name as the `id` column in the original `data` supplied to the `add_` function).
#'
#' See the specific chart sections for details on how to structure the `data`.
#'
#' @section chart types:
#'
#' the `type` element can be one of
#'   - `area`
#'   - `bar`
#'   - `bubble`
#'   - `candlestick`
#'   - `column`
#'   - `combo`
#'   - `histogram`
#'   - `line`
#'   - `pie`
#'   - `scatter`
#'
#' @section Area:
#'
#' **data**
#'
#' An area chart requires a \code{data.frame} of at least three columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third or more columns: the data used in the chart
#'
#' **type** - `area`
#'
#' **options**
#' see the area charts documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/areachart}
#'
#' Each row of data represents a data point at the same x-axis location
#'
#' @examples
#' \dontrun{
#'
#' set_key("your_api_key")
#'
#' ## AREA
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 2),
#'     year = rep( c("year1", "year2")),
#'     arrivals = sample(1:100, size = nrow(tram_stops) * 2, replace = T),
#'     departures = sample(1:100, size = nrow(tram_stops) * 2, replace = T))
#'
#' chartList <- list(data = markerCharts,
#'    type = 'area',
#'    options = list(width = 400, chartArea = list(width = "50%")))
#'
#' google_map() %>%
#'   add_markers(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#' tram_route$id <- c(rep(1, 30), rep(2, 25))
#'
#' lineCharts <- data.frame(id = rep(c(1,2), each = 2),
#'     year = rep( c("year1", "year2") ),
#'     arrivals = sample(1:100, size = 4),
#'     departures = sample(1:100, size = 4))
#'
#' chartList <- list(data = lineCharts,
#'    type = 'area')
#'
#' google_map() %>%
#'   add_polylines(data = tram_route, id = 'id',
#'     stroke_colour = "id", stroke_weight = 10,
#'     lat = "shape_pt_lat", lon = "shape_pt_lon",
#'     info_window = chartList
#'     )
#'
#' }
#'
#' @section Bar:
#'
#' **data**
#'
#' A bar chart requires a \code{data.frame} of at least three columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third or more columns: the data used in the chart
#'
#' **type** - `bar`
#'
#' **options**
#'
#' See the bar chart documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/barchart}
#'
#' @examples
#' \dontrun{
#'
#' ## BAR
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 2),
#'     year = rep( c("year1", "year2")),
#'     arrivals = sample(1:100, size = nrow(tram_stops) * 2, replace = T),
#'     departures = sample(1:100, size = nrow(tram_stops) * 2, replace = T))
#'
#' chartList <- list(data = markerCharts,
#'    type = 'bar')
#'
#' google_map() %>%
#'   add_markers(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#'
#' lineChart <- data.frame(id = 33,
#'     year = c("year1","year2"),
#'     val1 = c(1,2),
#'     val2 = c(2,1))
#'
#' chartList <- list(data = lineChart, type = 'bar')
#'
#' google_map() %>%
#'   add_polylines(data = melbourne[melbourne$polygonId == 33, ],
#'   polyline = "polyline",
#'   info_window = chartList)
#'
#' }
#'
#'
#' @section Bubble:
#'
#' **data**
#'
#' A bubble chart requires a \code{data.frame} of at least four, and at most six columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third column: x-axis value
#'   4. Fourth column: y-axis value
#'   5. Fith column: visualised as colour
#'   6. Sixth column: visualised as size
#'
#' **type** - `bubble`
#'
#' **options**
#'
#' See the bubble chart documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/bubblechart}
#'
#' @examples
#' \dontrun{
#'
#' ## BUBBLE
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 4),
#'     ID = sample(letters, size = nrow(tram_stops) * 4, replace = T),
#'     time = sample(1:1440, size = nrow(tram_stops) * 4, replace = T),
#'     passengers = sample(1:100, size = nrow(tram_stops) * 4, replace = T),
#'     year = c("year1", "year2", "year3", "year4"),
#'     group = sample(50:100, size = nrow(tram_stops) * 4, replace = T))
#'
#' chartList <- list(data = markerCharts,
#'    type = 'bubble')
#'
#' google_map() %>%
#'   add_markers(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#' }
#'
#' @section Candlestick:
#'
#' **data**
#'
#' A candlestick chart requires a \code{data.frame} of at least six columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third column: Number specifying the 'low' number for the data
#'   4. Fourth column: Number specifying the opening/initial value of the data.
#'    This is one vertical border of the candle. If less than the column 4 value,
#'    the candle will be filled; otherwise it will be hollow.
#'   5. Fith column: Number specifying the closing/final value of the data.
#'    This is the second vertical border of the candle. If less than the column 3 value,
#'    the candle will be hollow; otherwise it will be filled.
#'   6. Sixth column: Number specifying the high/maximum value of this marker.
#'    This is the top of the candle's center line.
#'
#' **type** - `candlestick`
#'
#' **options**
#'
#' See the candlestick chart documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/candlestickchart}
#'
#' @examples
#' \dontrun{
#'
#' ## CANDLESTICK
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 5),
#'     day = rep(c("Mon", "Tues", "Weds", "Thurs", "Fri"), times = nrow(tram_stops) ),
#'     val1 = rep(c(20, 31, 50, 77, 68), times = nrow(tram_stops) ),
#'     val2 = rep(c(28, 38, 55, 77, 66), times = nrow(tram_stops) ),
#'     val3 = rep(c(38, 55, 77, 66, 22), times = nrow(tram_stops) ),
#'     val4 = rep(c(45, 66, 80, 50, 15), times = nrow(tram_stops) ) )
#'
#' chartList <- list(data = markerCharts,
#'    type = 'candlestick',
#'    options = list(legend = 'none',
#'      bar = list(groupWidth = "100%"),
#'      candlestick = list(
#'        fallingColor = list( strokeWidth = 0, fill = "#a52714"),
#'        risingColor = list( strokeWidth = 0, fill = "#0f9d58")
#'        )
#'      ))
#'
#' google_map() %>%
#'   add_markers(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#' }
#'
#'
#' @section Column:
#'
#' **data**
#'
#' A column chart requires a \code{data.frame} of at least three columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third or more columns: the data used in the chart
#'
#' **type** - `column`
#'
#' **options**
#'
#' See the column chart documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/columnchart}
#'
#' @examples
#' \dontrun{
#'
#' ## COLUMN
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 2),
#'     year = rep( c("year1", "year2")),
#'     arrivals = sample(1:100, size = nrow(tram_stops) * 2, replace = T),
#'     departures = sample(1:100, size = nrow(tram_stops) * 2, replace = T))
#'
#' chartList <- list(data = markerCharts,
#'    type = 'column')
#'
#' google_map() %>%
#'   add_markers(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#' polyChart <- data.frame(id = 33,
#'     year = c("year1","year2"),
#'     val1 = c(1,2),
#'     val2 = c(2,1))
#'
#' chartList <- list(data = polyChart, type = 'column')
#'
#' google_map() %>%
#'   add_polygons(data = melbourne[melbourne$polygonId == 33, ],
#'   polyline = "polyline",
#'   info_window = chartList)
#'
#' tram_route$id <- 1
#'
#' polyChart <- data.frame(id = 1,
#'     year = c("year1","year2"),
#'     val1 = c(1,2),
#'     val2 = c(2,1))
#'
#' chartList <- list(data = polyChart, type = 'column')
#'
#' google_map() %>%
#'   add_polygons(data = tram_route,
#'     lon = "shape_pt_lon", lat = "shape_pt_lat",
#'     info_window = chartList)
#'
#'
#' }
#'
#' @section Combo:
#'
#' A combo chart lets you render each series as a different marker type from the following list:
#' line, area, bars, candlesticks, and stepped area.
#'
#' **data**
#'
#' A combo chart requires a \code{data.frame} of at least three columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third or more columns: the data used in the chart
#'
#' **type** - `combo`
#'
#' **options**
#'
#' See the column chart documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/combochart}
#'
#' @examples
#' \dontrun{
#'
#'
#' ## COMBO
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 2),
#'     year = rep( c("year1", "year2")),
#'     arrivals = sample(1:100, size = nrow(tram_stops) * 2, replace = T),
#'     departures = sample(1:100, size = nrow(tram_stops) * 2, replace = T))
#'
#' markerCharts$val <- sample(1:100, size = nrow(markerCharts), replace = T)
#'
#' chartList <- list(data = markerCharts,
#'    type = 'combo',
#'    options = list(
#'      "title" = "Passengers at stops",
#'      "vAxis" = list( title = "passengers" ),
#'      "hAxis" = list( title = "load" ),
#'      "seriesType" = "bars",
#'      "series" = list( "2" = list( "type" = "line" )))) ## 0-indexed
#'
#' google_map() %>%
#'   add_circles(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#' }
#'
#'
#' @section Histogram:
#'
#' **data**
#'
#' A histogram chart requires a \code{data.frame} of at least three columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third or more columns: the data used in the chart
#'
#' **type** - `histogram`
#'
#' **options**
#'
#' See the histogram chart documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/histogram}
#'
#' @examples
#' \dontrun{
#'
#' ## HISTOGRAM
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 20),
#'     day = as.character(1:20))
#'
#' markerCharts$wait <- rnorm(nrow(markerCharts), 0, 1)
#'
#' chartList <- list(data = markerCharts,
#'    type = 'histogram')
#'
#' google_map() %>%
#'   add_circles(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#' }
#'
#'
#' @section Line:
#'
#' **data**
#'
#' A line chart requires a \code{data.frame} of at least three columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third or more columns: the data used in the chart
#'
#' **type** - `line`
#'
#' **options**
#'
#' See the line chart documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/linechart}
#'
#' @examples
#' \dontrun{
#'
#' ## Line
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 20),
#'     day = as.character(1:20),
#'     value = sample(1:100, size = nrow(tram_stops) * 20, replace = T))
#'
#' chartList <- list(data = markerCharts,
#'    type = 'line')
#'
#' google_map() %>%
#'   add_circles(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#' }
#'
#'
#' @section Pie:
#'
#' **data**
#'
#' A pie chart requires a \code{data.frame} of three columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third column: the data used in the chart
#'
#' **type** - `pie`
#'
#' **options**
#'
#' See the pie chart documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/piechart}
#'
#' @examples
#' \dontrun{
#'
#' ## PIE
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 3))
#' markerCharts$variable <- c("yes", "no", "maybe")
#' markerCharts$value <- sample(1:10, size = nrow(markerCharts), replace = T)
#'
#' chartList <- list(data = markerCharts,
#'    type = 'pie',
#'    options = list(title = "my pie",
#'      is3D = TRUE,
#'      height = 240,
#'      width = 240,
#'      colors = c('#440154', '#21908C', '#FDE725')))
#'
#' google_map() %>%
#'   add_markers(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#' ## use pieHole option to make a donut chart
#'
#' chartList <- list(data = markerCharts,
#'    type = 'pie',
#'    options = list(title = "my pie",
#'      pieHole = 0.4,
#'      height = 240,
#'      width = 240,
#'      colors = c('#440154', '#21908C', '#FDE725')))
#'
#' google_map() %>%
#'   add_markers(data = tram_stops, info_window = chartList, id = "stop_id")
#'
#' }
#'
#'
#' @section Scatter:
#'
#' **data**
#'
#' A scatter chart requires a \code{data.frame} of at least four columns:
#'   1. First column: a column of id values, where the column has the same name as the
#'   id column in the \code{data} argument, and therefore the same name as the value supplied
#'   to the \code{id} argument.
#'   2. Second column: variable names used for labelling the data
#'   3. Third column: the data plotted on x-axis
#'   4. Fourth or more columns: the data plotted on y-axis
#'
#' **type** - `scatter`
#'
#' **options**
#'
#' See the scatter chart documentation for various other examples
#' \url{https://developers.google.com/chart/interactive/docs/gallery/scatterchart}
#'
#' @examples
#' \dontrun{
#'
#' ## SCATTER
#' markerCharts <- data.frame(stop_id = rep(tram_stops$stop_id, each = 5))
#' markerCharts$arrival <- sample(1:10, size = nrow(markerCharts), replace = T)
#' markerCharts$departure <- sample(1:10, size = nrow(markerCharts), replace = T)
#'
#' chartList <- list(data = markerCharts,
#'    type = 'scatter')
#'
#' google_map() %>%
#'   add_markers(data = tram_stops, info_window = chartList, id = "stop_id")
#' }
#'
#'
#' @md
#' @name google_charts
NULL


