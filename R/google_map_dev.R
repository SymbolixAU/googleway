
# library(shiny)
# library(shinydashboard)
#
# key <- read.dcf("~/Documents/.googleAPI", fields = c("GOOGLE_API_KEY"))
#
# ui <- dashboardPage(
#   dashboardHeader(),
#   dashboardSidebar(),
#   dashboardBody(
#
#     uiOutput("map")
#
#   )
# )
#
# server <- function(input, output){
#
#   output$map <- renderUI({
#
#     ## static map
#     tags$iframe(src = paste0("https://www.google.com/maps/embed/v1/place?q=MCG,Melbourne%20Rd,%20AUS
#         &zoom=14
#         &key=", key) )
#
#   })
# }
#
# shinyApp(ui, server)
#

library(htmlwidgets)
library(devtools)

key <- read.dcf("~/Documents/.googleAPI", fields = c("SYMBOLIX_GOOGLE_API_KEY"))




