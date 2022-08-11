library(stringr)
library(fs)

setwd(DirectorioPadre)


drive<-paste("C:/Users/", Sys.info()["user"],"/SERVICIOS SHASA S DE RL DE CV/Fotos Shasa - Fotografía", sep ="")

carpeta<-drive

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

imagenes <- list.files(carpeta)

jpg<-substr(imagenes, start = nchar(imagenes)-3, stop = (nchar(imagenes)))

imagenes<-imagenes[jpg == ".jpg"]

# extact items from name
items <-unique(substr(sku(imagenes), 1, 10))

extraccion <- as.character(extraer$VarianteColor)

extraccion <- unique(substr(extraccion, start = 1, 10))

reporte <- NULL
moverzip <- NULL

for (i in 1:length(extraccion)) {
  item <- items[str_detect(items, extraccion[i])]
  
  if (identical(item, character(0))) {
    reporte <- c(reporte, extraccion[i])
    print(paste(item, "no encontrado"))
  }else{
    moverzip <- c(moverzip, imagenes[str_detect(imagenes, item)])
    print(paste(item, "extraido"))

    }
}

setwd(carpeta)


if (!is.null(reporte)) {
  lista<-qpcR:::cbind.na(unique(sku(moverzip)), reporte)
  colnames(lista)<-c("ItemsExtraidos", "ItemsNoEncontrados")
}else{
  lista<-unique(sku(moverzip))
  lista<-data.frame("ItemsExtraidos"=lista)
  
}
print(paste("Inicio Primera extraccion", Sys.time()))

a<-zip("ItemsSeleccionados.zip", moverzip)

print(paste("Fin primera extraccion", Sys.time()))


if  (file.exists(a)) {
  file_move(a, guardar)
}

setwd(guardar)
write.csv(lista,  "SubconjuntoItems.csv")
# winDialog(type="ok", message=)
print("Lote extraido con exito :)")