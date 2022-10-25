## For this assignment, follow the comments to complete the Shiny application
# Coments with instructions will end with ----
library(shiny)
library(reactable)
library(magrittr)
library(Tplyr)
library(dplyr)
library(purrr)
library(rlang)

adsl <- readRDS(file.path('data', 'adsl.rds')) %>%
  # Tplyr generally respects factors! 
  mutate(
    TRT01A = ordered(TRT01A, c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose"))
  )

# Summarize adsl, with the treatment variable TRT01A ----
tab <- tplyr_table(adsl, TRT01A) %>%
  # Add a layer for SEX with a row label of "Sex n (%)" ----
  add_layer(
    group_count(SEX, by = "Sex n (%)")
  ) %>%
  # Add a layer for AGE with a row label of "Age (years)" ----
  add_layer(
    group_desc(AGE, by = "Age (years)")
  ) %>%
  # Add a layer for RACE with a row label of "Race n (%)" ----
  add_layer(
    group_count(RACE, by = "Race n (%)")
  )

# Build the table with metadata ----
b_tab <- build(tab, metadata = TRUE) %>%
  apply_row_masks() %>%
  select(row_id, starts_with("row"), starts_with("var")) %>%
  relocate(row_id, row_label1, row_label2, var1_Placebo, `var1_Xanomeline Low Dose`, `var1_Xanomeline High Dose`)

# This is a very simple UI with the table reactable on top of the subset data
ui <- fillPage(
  reactableOutput("demoTab"),
  reactableOutput("demoList")
)

server <- function(input, output) {
  
  # Set the reactives for row and column from the click event ----
  # For row, pull out the index element from the row element of the input
  # For col, pull out the column element from the col element of the input
  row <- reactive(b_tab[input$row$index,1]$row_id)
  col <- reactive(input$col$column)
  
  output$demoTab <- renderReactable(
    reactable(
      select(b_tab, -row_id, -starts_with("ord")),
      sortable = FALSE,
      # Set the Shiny input 
      onClick = JS("function(rowInfo, colInfo) {
                      if (window.Shiny) {
                        Shiny.setInputValue('row', { index: rowInfo.index + 1 })
                        Shiny.setInputValue('col', { column: colInfo.id })
                        }
                    }"),
      height = 450,
      defaultPageSize = 11,
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
    tmp <- get_meta_subset(tab, row(), col())
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