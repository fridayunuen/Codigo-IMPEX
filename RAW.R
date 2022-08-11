
# Librerias ---------------------------------------------------------------
# if ya estan instaladas? 
library(stringr)
library("fs") 
library(exiftoolr) # necesita una actualizacion 
library(magick)
library(utils)
#install_exiftool()

# Funciones ---------------------------------------------------------------

mover_errores<-function(num_errores, errores){
  di_errores<-guardar
  setwd(di_errores)
  
  n<-paste("carpeta_errores_",basename(carpeta), sep="" )
  
  if ((sum(list.files()==n))==0) { dir.create(n)}
  
  di_errores<-paste(di_errores, "\\",n, sep = "")
  
  for (j in 1:num_errores) {
    file_move(paste(carpeta,"\\", errores[j], sep="") , di_errores)  
  }
  setwd(carpeta)
}

subreporte<-function(reporte1, mensaje){
  if (is.null(reporte1$Archivo)) {
    print(mensaje)
  }else{
    numero_errores<-length(unique(reporte1$Archivo))
    mover_errores(numero_errores, errores = unique(reporte1$Archivo))
    imagenes<-list.files(carpeta)
  }
}

# Primer filtro -----------------------------------------------------------

setwd(carpeta)
  
  imagenes<-list.files(carpeta)
  
  info<-exif_read(imagenes)
  
  
  # Errores  ----------------------------------------------------------------
  
  errores<-if (length(imagenes[!is.na(info$Error)])>0) {
    data.frame("Estado" = info$Error[!is.na(info$Error)] ,
               "Archivo"=imagenes[!is.na(info$Error)])
  }
  
  subreporte(errores, "Carpeta sin errores generales")
  
  imagenes<-list.files(carpeta)
  
  # Extensiones permitidas-------------------------------------
  
  
 # info<-exif_read(imagenes)
 # 
 # extension<-if (sum(info$FileTypeExtension!="JPG")>0 ) {
 #   data.frame("Estado"= c("Formato del archivo no admitido en:"),
 #              "Archivo"=imagenes[!info$FileTypeExtension =="JPG"])
 # }
 # 
 # subreporte(extension, mensaje = "Carpeta sin errores en el tipo de extension")
 # imagenes<-list.files(carpeta)

  