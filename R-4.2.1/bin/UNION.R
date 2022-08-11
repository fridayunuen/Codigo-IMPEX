#inicio<-"C:/Users/fcolin/Documents/GitHub/Codigo-IMPEX/R-4.2.1/bin"
#DirectorioPadre <-"C:/Users/fcolin/Documents/GitHub/Codigo-IMPEX/"

inicio<-paste("C:/Users/", Sys.info()["user"],"/Downloads/Aplicacion/Codigo-IMPEX/R-4.2.1/bin", sep="")
DirectorioPadre <- paste("C:/Users/", Sys.info()["user"], "/Downloads/Aplicacion/Codigo-IMPEX", sep = "" )

 library(stringr)
 library(readxl)
 library(zip)
 
 
InicioProceso<-paste("Inicio de todo el proceso", Sys.time())

excel<-choose.files()


setwd(inicio)
source("PrimeraExtraccion.R")

########################################
# if
file.exists("ItemsSeleccionados.zip")

unzip("ItemsSeleccionados.zip")

file.remove("ItemsSeleccionados.zip")


# 

imagenes<-list.files()
jpg<-substr(imagenes, start = nchar(imagenes)-3, stop = (nchar(imagenes)))

imagenes<-imagenes[jpg==".jpg"]



###############################################
###### Priemro filtramos los que tengan Error

errores<-imagenes[str_detect(imagenes, "Error")]

if (!identical(errores, character(0))) {
  
  e<-paste(guardar, "\\Errores", sep = "")
  dir.create(e)
  
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
  
  sku_errores<-unique(sku(errores))
  
  for (i in 1:length(sku_errores)) {
    
    imagenes_error<-imagenes[str_detect(imagenes, sku_errores[i])]
    
    file_move(imagenes_error, e)
    
  }
  
  
}



##################################################

setwd(inicio)

print(paste("Comienzo de creación Lotes 32 megas ", Sys.time()))
source("CreacionLotes.R")
print(paste("Fin de creación Lotes 32 megas ", Sys.time()))

####

setwd(inicio)

files<-list.dirs(carpeta)

dirlotes<-files[str_detect(files, "Lote-")]


print(paste("Inicio Creacion IMPEX", Sys.time()))

for (t in 1:length(dirlotes)) {
  carpeta<-dirlotes[t]
  setwd(DirectorioPadre)
  source("Ejecutable.R")
  setwd(guardar)
  dir_delete(carpeta)
}

print(paste("Fin Creacion IMPEX", Sys.time()))

print(InicioProceso)

print(paste("Fin de todo el proceso", Sys.time()))


