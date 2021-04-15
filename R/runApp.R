runApplication <- function(){
  appDir <- system.file("inst" ,package = "PPClustA")
  print(appDir)
  shiny::runApp(system.file("inst", package = "PPClustA"))
}
