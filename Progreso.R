
if (is.na(carpeta) | is.na(guardar)) {
  winDialog(type="ok", message="Selecciona la carpeta que contiene las imagenes y posteriormente en donde se alojaran los resultados")
  
}else{
  
  setwd(carpeta)
  
  if (sum(list.dirs()!=".")>0) {
    winDialog(type="ok", message="La carpeta seleccionada tiene subcarpetas")
    
  }else{
    
    library(tcltk)
    pb <- tkProgressBar(title = "Barra de progreso Tk",  # Título de la ventana
                        label = "Porcentaje completado", # Texto de la ventana
                        min = 0,      # Valor mínimo de la barra
                        max = 6, # Valor máximo de la barra
                        initial = 0,  # Valor inicial de la barra
                        width = 300)  # Ancho de la ventana
    
    Sys.sleep(0.1)
    #-------------------
    setwd(DirectorioPadre)
    source("RAW.R")
    w<-1
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1

    setwd(DirectorioPadre)
    source("VerificandoErroresEtiqueta.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    



    setwd(DirectorioPadre)
    source("VerificandoString.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    
    #------------------------------------------------------------------
    
    #-------------------------------------------------------------------
    
    setwd(DirectorioPadre)
    source("Requerimientos.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    
    setwd(DirectorioPadre)
    source("GeneracionTallas.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    
    setwd(DirectorioPadre)
    source("ItemsUnicosFamilia.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    
    setwd(DirectorioPadre)
    source("CodigoItemsUnicos.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    
    setwd(DirectorioPadre)
    source("CodigoItemsFamilia.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    
    setwd(DirectorioPadre)
    source("UltimosDetalles.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    
    setwd(DirectorioPadre)
    source("Lotes.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    
    setwd(DirectorioPadre)
    source("Impresion.R")
    pctg <- paste(round(w/11 *100, 0), "% completado")
    setTkProgressBar(pb, w, label = pctg)
    w<-w+1
    
    Sys.sleep(0.7)
    close(pb) # Cerramos la conexión

  }
  
  
  
}


