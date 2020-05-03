div(id = "nav_page",
  hidden(
    lapply(seq(NUM_PAGES), function(i) {
      div(
        class = "page",
        id = paste0("step", i),
        source(file.path("ui", "01-navpage", sprintf("page%i.R", i)),  local = TRUE)$value
      )
    })
  ),
  
  br(),
  actionButton("prevBtn", "< Previous"),
  actionButton("nextBtn", "Next >")    
)