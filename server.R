create_samples <- function(data, method, ui_value, times = 1) {
  sample_fun <- ifelse(method == "Sample N", sample_n, sample_frac)
  sets <- lapply(1:times, function(x) {
    list(
      train <- data %>% sample_fun(ui_value),
      test <- setdiff(data, train)
    )
  })
}

function(input, output, session) {
  #session$onSessionEnded(stopApp)
  
  source(file.path("server", "nav-page.R"),  local = TRUE)$value
  
  rv <- reactiveValues(data = NULL, train = NULL, test = NULL, page = 1)
}