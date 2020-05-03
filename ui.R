navbarPage(title = "Fraud analysis", theme = "style.css", id = "navbar_page",
  tabPanel("Create model", source(file.path("ui", "nav-page.R"),  local = TRUE)$value),
  useShinyjs()
)