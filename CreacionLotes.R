DirectorioPadre <- getwd()
setwd(DirectorioPadre)

carpeta <- choose.dir( caption = "Seleccione la carpeta que contiene las imagenes")
guardar <- choose.dir( caption = "Seleccione la carpeta donde se guardaran los lotes")

megas <- 32

library(stringr)
library(fs)
#install.packages("qpcR")                            # Install qpcR package
library("qpcR") 

nombre <- function(imagenes){
   guion <- str_locate(imagenes, "_")[1:length(imagenes)]
   substr(imagenes, start = guion +1, stop = nchar(imagenes)-4)
 }
 sku <- function(imagenes){
   guion<-str_locate(nombre(imagenes), "_")[1:length(imagenes)]
   a<-substr(nombre(imagenes), start = guion+1, stop = nchar(imagenes))
   guion<-str_locate(a, "_")[1:length(imagenes)]
   substr(a, start = 1, stop = guion-1)
 }
# -----------------------------------------------------------------------------
requerimiento <- (megas * 1000000)

library(zip)
imagenes <- list.files(carpeta)
r <- 0

lista <- NULL
while (!identical(imagenes, character(0))) {
  setwd(carpeta)
  r <- r + 1
  items<-unique(substr(sku(imagenes), 1, 10))
  # Obteniendo un data frame con el sku y el peso de todas las imagenes
  z <- NULL
  for(i in 1:length(items)) {
    unitem <- imagenes[str_detect(imagenes, items[i])]
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
  l <- NULL
  for (j in 1:length(seleccion)) {
    e <- imagenes[str_detect(imagenes, seleccion[j])]
    l <- c(l, e)
  }

  nombrezip<-paste("Lote", r, ".zip", sep = "")
  zip(nombrezip, l)
  lista <- qpcR:::cbind.na(lista, seleccion)

  file_move(nombrezip, guardar)

  for (k in 1:length(sku(l))) {
    imagenes <- imagenes[!str_detect(imagenes, sku(l)[k])]
  }
}

lista <- lista[, 2:ncol(lista)]

colnames(lista) <- paste("Lote", 1:ncol(lista), sep = "")
 
setwd(guardar)
write.csv(lista,  "ListaLotes.csv")

winDialog(type = "ok", message = "Lotes generados con exito")