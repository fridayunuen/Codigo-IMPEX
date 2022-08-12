inicio<-"C:/Users/fcolin/Documents/GitHub/Codigo-IMPEX/R-4.2.1/bin"
DirectorioPadre <-"C:/Users/fcolin/Documents/GitHub/Codigo-IMPEX/"

#inicio<-paste("C:/Users/", Sys.info()["user"],"/Downloads/Aplicacion/Codigo-IMPEX/R-4.2.1/bin", sep="")
#DirectorioPadre <- paste("C:/Users/", Sys.info()["user"], "/Downloads/Aplicacion/Codigo-IMPEX", sep = "" )

library(stringr)
library(readxl)
library(zip)
library(fs)


InicioProceso<-paste("Inicio de todo el proceso", Sys.time())

excel<-choose.files()

setwd(DirectorioPadre)


drive<-paste("C:/Users/", Sys.info()["user"],"/SERVICIOS SHASA S DE RL DE CV/Fotos Shasa - Fotografía", sep ="")

# carpeta<-drive

guardar <- choose.dir(caption = "¿En donde se guardara el lote? Carpeta de preferencia vacia*")
extraer <- read_excel("ItemsExtraer.xlsx")

# Function ----------------------------------------------------------------

nombre<-function(imagenes){
  guion<-str_locate(imagenes, "_")[1:length(imagenes)]
  substr(imagenes, start = guion +1, stop = nchar(imagenes)-4)
}

sku<-function(imagenes){
  guion<-str_locate(nombre(imagenes), "_")[1:length(imagenes)]
  a<-substr(nombre(imagenes), start = guion+1, stop = nchar(imagenes))
  guion<-str_locate(a, "_")[1:length(imagenes)]
  substr(a, start = 1, stop = guion - 1)
}

# 

imagenes <- list.files(drive)

jpg<-substr(imagenes, start = nchar(imagenes)-3, stop = (nchar(imagenes)))

imagenes<-imagenes[jpg == ".jpg"]

# extact items from name
items <-unique(substr(sku(imagenes), 1, 10))

extraccion <- as.character(extraer$VarianteColor)

extraccion <- unique(substr(extraccion, start = 1, 10))

reportenoencontrado <- NULL
moverzip <- NULL

for (i in 1:length(extraccion)) {
  item <- items[str_detect(items, extraccion[i])]
  
  if (identical(item, character(0))) {
    reportenoencontrado <- c(reportenoencontrado, extraccion[i])
    print(paste(item, "no encontrado"))
  }else{
    moverzip <- c(moverzip, imagenes[str_detect(imagenes, item)])
    print(paste(item, "extraido"))
    
  }
}

###########

megas <- 32

imagenes <- moverzip
imagenes<-imagenes[jpg==".jpg"]
imagenes<-imagenes[!is.na(sku(imagenes))]

requerimiento <- (megas * 1000000)

r <- 0
lista <- NULL
while (!identical(moverzip, character(0))) {
  setwd(drive)
  r <- r + 1
  items<-unique(substr(sku(moverzip), 1, 10))
  items<-items[!is.na(items)]
  
  # Obteniendo un data frame con el sku y el peso de todas las imagenes
  z <- NULL
  for(i in 1:length(items)) {
    unitem <- moverzip[str_detect(moverzip, items[i])]
    bytes <- sum(file.size(unitem))
    df <- data.frame("item" = items[i], bytes)
    z <- rbind(z, df)
  }
  
  
  p <- NULL
  q <- NULL
  for (i in 1:length(z$bytes)) {
    q <- c(q, z$bytes[i])
    if (sum(q)<requerimiento) {
      p <- c(p, z$bytes[i])
    }else{
      p <- c(p, 0)
    }    
  }
  seleccion <- z[p!=0, ]$item
  lit <- NULL
  for (j in 1:length(seleccion)) {
    e <- moverzip[str_detect(moverzip, seleccion[j])]
    lit <- c(lit, e)
  }
  nombrecarpeta <- paste(guardar, "/Lote", r, "-", Sys.info()["user"], sep = "")
  dir.create(nombrecarpeta)
  # file_move(l, nombrecarpeta)
  nombrezip<-paste("Lote", r, "-", Sys.info()["user"],".zip", sep = "")
  
  #nombrezip<-paste("Lote", r, ".zip", sep = "")
  zip(nombrezip, lit)
  lista <- qpcR:::cbind.na(lista, seleccion)
  
  file_move(nombrezip, nombrecarpeta)

# UNZIP -------------------------------------------------------------------
  setwd(nombrecarpeta)
  if (file.exists(nombrezip)) {
    unzip(nombrezip)
    file.remove(nombrezip)
  }else{
    print("No se genero el zip inicial correctamente")
  }
  
  carpeta<-nombrecarpeta
  imagenes<-list.files(carpeta)
  jpg<-substr(imagenes, start = nchar(imagenes)-3, stop = (nchar(imagenes)))
  imagenes<-imagenes[jpg==".jpg"]
  
# Filtrando Errores -------------------------------------------------------

  errores<-imagenes[str_detect(imagenes, "Error")]
  
  if (!identical(errores, character(0))) {
    
    e<-paste(guardar, "\\Errores", sep = "")
    
    if(!dir.exists(e)){
      dir.create(e)
    }
    
    sku_errores<-unique(sku(errores))
    
    for (i in 1:length(sku_errores)) {
      
      imagenes_error<-imagenes[str_detect(imagenes, sku_errores[i])]
      
      file_move(imagenes_error, e)
      
    }
  
  }
  

# Creacion IMPEX ----------------------------------------------------------

  setwd(DirectorioPadre)
  
  source("Ejecutable.R")
  source("ReporteCompartido.R")
  source("nosku.R")
  setwd(guardar)
  dir_delete(carpeta)
  
  for (k in 1:length(sku(lit))) {
    moverzip <- moverzip[!str_detect(moverzip, sku(lit)[k])]
  }
  
}



if (is.null(reportenoencontrado)){
  print("Todos los items extraidos con exito")
}else{
  print(reportenoencontrado)
  
  
}


