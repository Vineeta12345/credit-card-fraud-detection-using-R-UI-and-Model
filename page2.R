div(
  h3("Set the",  strong("train"), "and", strong("test"), "sample sizes"),
  wellPanel(
    fluidRow(
      column(4,
             verticalLayout(
               selectInput("slt_method", label = "Select sampling method",
                           choices = c("Sample N", "Sample percentage"))
             )
      ),
      column(4,
             conditionalPanel(condition = "input.slt_method == 'Sample N'",
                              sliderInput("sld_sample", "Sample size for train set",
                                          min = 0, max = rows, value = round(rows / 2, 0), step = 10 ^ (log10(rows) %>% round(0) - 1))
             ),
             conditionalPanel(condition = "input.slt_method == 'Sample percentage'",
                              numericInput("num_train_percent", label = "Train set sample percentage",
                                           value = 0.5,
                                           min = 0.1, max = 0.9, step = 0.01),
                              numericInput("num_test_percent", label = "Test set sample percentage",
                                           value = 0.5,
                                           min = 0.1, max = 0.9, step = 0.01)
             ) 
      )
    )
  )
)