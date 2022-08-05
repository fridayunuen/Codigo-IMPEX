
setwd(DirectorioPadre)
#source("RAW.R")

# Estructura del String

# Estructura :  "1200Wx1200H_Derecha_2005145096_1.jpg"   "Dimension_Tipo_SKU_No.jpg"
# numero de caracteres MAX 36 MIN 32


##########################################################################
# Verificando que tamano de archivo corresponda la nombre de la im --------

setwd(carpeta)
imagenes<-list.files(carpeta)
info<-exif_read(imagenes)

sizecoresp<-info$ImageWidth == as.numeric(dim(imagenes))&info$ImageHeight == as.numeric(dim2(imagenes))

vmedidas<-if(length(imagenes[!sizecoresp]) >0){
  
    data.frame("Estado"= rep("Medidas de la imagen no corresponden:",
                             length(imagenes[!sizecoresp])),
               "Archivo"=imagenes[is.na(sizecoresp)])
}


subreporte(vmedidas, "Las medidas de las imagen corresponden a su nombre")
imagenes<-list.files(carpeta)
vmedidas

# Espacios en el nombre ---------------------------------------------------

espacio<-if(sum(str_detect(imagenes, " "))>0){
  data.frame("Estado" = c("El nombre de la imagen contiene un espacio en blanco:"),
             "Archivo"=imagenes[str_detect(imagenes, " ")])
}

subreporte(espacio, "Nombres sin espacios")
imagenes<-list.files(carpeta)
espacio

# El numero de caracteres del nombre minimo deben de ser 32  max 36 ---------------


nom<-if(sum(nchar(imagenes)<32)>0) {
  data.frame("Estado"= rep("Formato del nombre del archivo incorrecto:",length(imagenes[nchar(imagenes)<32])),
             "Archivo"=c(imagenes[nchar(imagenes)<32]))
}

subreporte(nom, "Minimo nombre correcto")
imagenes<-list.files(carpeta)
nom



nom2<-if(sum(nchar(imagenes)>38)>0) {
  data.frame("Estado"= rep("Formato del nombre del archivo incorrecto:",length(imagenes[nchar(imagenes)>36])),
             "Archivo"=c(imagenes[nchar(imagenes)>36]))
}

subreporte(nom2, "Maximo nombre correcto")
imagenes<-list.files(carpeta)
nom2
# sku numerico---------------------------------

sku_nonumeric<-is.na(as.numeric(sku(imagenes)))

vsku<-if (sum(sku_nonumeric)>0) {
  data.frame("Estado"= rep("SKU no numerico en:",sum(sku_nonumeric)),
             "Archivo"=imagenes[sku_nonumeric])
}

subreporte(vsku, "SKU numericos")
imagenes<-list.files(carpeta)
vsku

# Terminacion del string .jpg ---------------------------------------------

jpg<-substr(imagenes, start = nchar(imagenes)-3, stop = (nchar(imagenes)))

terminacion<-if (sum(jpg!=".jpg")>0) {
  data.frame("Estado"= rep("Terminación del nombre incorrecto en :",length(imagenes[jpg!=".jpg"])),
             "Archivo"=imagenes[jpg!=".jpg"])
}

subreporte(terminacion, "Extension en nombre de la imagen correcto ")
imagenes<-list.files(carpeta)
terminacion


# Tipo de vistas ----------------------------------------------------------

a<-data.frame(
                tipo(imagenes) == "Derecha", 
                tipo(imagenes) == "Trasera" ,
                tipo(imagenes) == "Frontal",
                tipo(imagenes) == "Izquierda")

tipo_error<- imagenes[rowSums(a)==0]

te<-if (!identical(tipo_error, character(0))) {
  data.frame("Estado"= rep("Error en el nombre en :",length(tipo_error)),
             "Archivo"=tipo_error)
}

subreporte(te, "Formato de nombres correcto")
imagenes<-list.files(carpeta)

