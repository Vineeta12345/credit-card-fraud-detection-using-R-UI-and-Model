div(
  div(id = "welcome-text",
    h2("Welcome to the model builder"),
    p("You can create a model in 3 steps"),
    tags$ul(
      tags$li("Upload or choose a dataset"), 
      tags$li("Set the Validation settings"), 
      tags$li("Design the prediction.")
    )
  ),
  h3("Let's start by choosing a dataset"),
  p("Either use the", tags$a(href = "https://www.kaggle.com/dalpozz/creditcardfraud", "Credit Card Fraud Detection"), "dataset from Kaggle or upload your own."),
  h4("Requirements"),
  p("The uploaded file should be in .csv format (separated by comma [,]). The file needs to be in the following structure:"),
  tags$ul(
    tags$li("A column named", strong("class"), "that specifies whether the event is classified as fraud or not"),
    tags$li("Any number of columns that will be used for classification")
  ),
  fluidRow(style = "padding-left: 15px;",
    radioButtons("rb_dataset", label = "",
                           choices = c("Kaggle dataset", "Upload a file"))
  ),
  fluidRow(style = "padding-left: 15px;",  
    conditionalPanel(condition = "input.rb_dataset == 'Upload a file'",
                   fileInput("file_upload", "", accept = ".csv"),
                   column(2, textOutput("file_error")))
  )
)