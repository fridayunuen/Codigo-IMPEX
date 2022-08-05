
# Creando ZIP -------------------------------------------------------------
library(zip)
setwd(guardar)

# exist?

n<-paste("imagenes_innecesarias",basename(carpeta), sep="" )

if (sum(list.files()==n)>0) {

  setwd(n)
  path<-getwd()
  
  file_move(paste(path, "/", list.files(), sep = "") , carpeta)

  setwd(guardar)
  
  file.rename(n, "Resultados")
  
}else{
  dir.create(paste(guardar, "\\Resultados", sep ="" ))
}

resultados<-paste(guardar, "\\Resultados", sep ="" )

setwd(carpeta)
zip("ImportarZIP.zip", list.files())

print("Zip generado con exito")

file_move(paste(carpeta, "\\", "ImportarZIP.zip", sep=""), resultados )


#-------------------------------------------------------------------------
# Eliminando carpeta de errores
n<-paste("carpeta_errores_",basename(carpeta), sep="" )
di_errores<-paste(guardar, "\\",n, sep = "")



if (dir.exists(di_errores)) {
  
  if (identical(list.files(di_errores), character(0) )) {
    
    dir_delete(di_errores)
  }
  
  
}
