library(stringr)
library("fs") 
library(exiftoolr) # necesita una actualizacion 
library(magick)
library(utils)
#install_exiftool()

# RAW  ---------------------------------------------------------------

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


# Verificando String ------------------------------------------------------
