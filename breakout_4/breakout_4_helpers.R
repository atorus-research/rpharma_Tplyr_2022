## For this assignment, follow the comments to complete the Shiny application
# Coments with instructions will end with ----
library(shiny)
library(reactable)
library(magrittr)
library(Tplyr)
library(dplyr)
library(purrr)
library(rlang)


adsl <- readRDS(here::here('data', 'adsl.rds')) %>%
  # Tplyr generally respects factors! 
  mutate(
    TRT01A = ordered(TRT01A, c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose"))
  )

# Summarize adsl, with the treatment variable TRT01A ----
tab <- tplyr_table(____, ____) %>%
  # Add a layer for SEX with a row label of "Sex n (%)" ----
  add_layer(
    group_count(____, by = "____")
  ) %>%
  # Add a layer for AGE with a row label of "Age (years)" ----
  add_layer(
    group_desc(____, by = "____")
  ) %>%
  # Add a layer for RACE with a row label of "Race n (%)" ----
  add_layer(
    group_count(____, by = "____")
  )
# When you're done, if you have time, edit the table above and see what else you can make, 
# and how the table is still interactive! 

# Build the table with metadata ----
results <- build(tab, ____) %>%
  # This is all post processing
  # See https://atorus-research.github.io/Tplyr/articles/styled-table.html
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
  row <- reactive(results[____$____$____,1]$row_id)
  col <- reactive(____$____$____)
  
  output$demoTab <- renderReactable(
    reactable(
      select(results, -row_id, -starts_with("ord")),
      sortable = FALSE,
      # Set the Shiny inputs for row and column  ----
      # For the first input value, set the input value to 'row'. For the second, set it to 'col'. 
      # Set the key for 'row' to index and 'col' to column for reference later
      # This small JS function talks with Shiny by letting us pass in a JavaScript function directly. 
      # Note that the data format here is built to work with reactable
      onClick = JS("function(rowInfo, colInfo) {
                      if (window.Shiny) {
                        Shiny.setInputValue('____', { ____: rowInfo.index + 1 })
                        Shiny.setInputValue('____', { ____: colInfo.id })
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
  
  # Grab the subset metadata by using the row and col reactives ----
  # Remember that the Tplyr table's object name is `tab`, and that reactives are callables! (i.e. need ())
  # row will be the row_id, and col will be the column. Use ?get_meta_subset() for help
  sub_data <- reactive({
    req(____(), ____())
    tmp <- ____
    tmp
  })
  
  # Now we'll render the subset datable as a reactable table using the sub_data() reactive we made above
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