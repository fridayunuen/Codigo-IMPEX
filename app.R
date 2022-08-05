library(shiny)
library(shinythemes)
# ui ----------------------------------------------------------------------

ui<-tagList(
  navbarPage(theme = shinytheme("simplex"), 
    
    "SHASA",
    
    tabPanel(
      "Aut Importación de Fotos",
      sidebarPanel(
      # selectInput("talla", "Elige una talla:",
      #             list("Ropa" = c("Unitalla", "S-M-L"),
      #                  "Zapatos" = c("UT", "23-24-25-26-27"),
      #                  "Articulos" = c("Sin_Talla", "Dostallas"))
      # ),
        
        
        actionButton("ejecutar", "Ejecutar", class = "btn-primary")
        
        ), mainPanel(
          tabsetPanel(
            
            h4("Resultados"), 
            
            
            # ,img(src='myImage.png', align = "right")
          )
        )
      
      
      ),
    
    tabPanel("Ayuda", "Instrucciones :)")
        
    )
  
  )

# Server ------------------------------------------------------------------

server <- function(input, output) {
  vals <- reactiveValues()
  observe({
    vals <- input$talla
  })
  

  observeEvent(input$ejecutar,{source("Ejecutable.R")})
  
}


# App ---------------------------------------------------------------------
shinyApp(ui, server)
