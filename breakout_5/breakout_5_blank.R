library(shiny)
library(reactable)
library(magrittr)
library(Tplyr)
library(dplyr)
library(tidyr)
library(purrr)
library(rlang)

adsl <- readRDS(here::here('data', 'adsl.rds'))
adas <- readRDS(here::here('data', 'adas.rds'))

# Pull your work from Breakout 3: Problem 5 to complete the application ----

ui <- fillPage(
  reactableOutput("demoTab"),
  reactableOutput("demoList")
)

server <- function(input, output) {
  
  row <- reactive(results[input$row$index,1]$row_id)
  col <- reactive(input$col$column)
  
  output$demoTab <- renderReactable(
    reactable(
      select(results, -row_id, -starts_with("ord")),
      sortable = FALSE,
      onClick = JS("function(rowInfo, colInfo) {
                      if (window.Shiny) {
                        Shiny.setInputValue('row', { index: rowInfo.index + 1 })
                        Shiny.setInputValue('col', { column: colInfo.id })
                        }
                    }"),
      height = 600,
      defaultPageSize = 21,
      columns = list(
        row_label1 = colDef(name = ""),
        row_label2 = colDef(name = ""),
        var1_Placebo = colDef(name = "Placebo"),
        `var1_Xanomeline Low Dose` = colDef(name = "Xano Low"),
        `var1_Xanomeline High Dose` = colDef(name = "Xano High")
      )
    )
  )
  
  sub_data <- reactive({
    req(row(), col())
    tmp <- get_meta_subset(t, row(), col())
    tmp
  })
  
  output$demoList<- renderReactable({
    req(sub_data())
    reactable(
      sub_data(),
      sortable = FALSE,
      height = 450,
      defaultPageSize = 11,
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)