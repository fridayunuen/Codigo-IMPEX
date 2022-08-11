# inicio<-"C:/Users/fcolin/Documents/GitHub/Codigo-IMPEX/R-4.2.1/bin"

inico<-paste("C:/Users/", Sys.info()["user"],"/Downloads/Aplicacion/Codigo-IMPEX/R-4.2.1/bin", sep="")

InicioProceso<-paste("Inicio de todo el proceso", Sys.time())

excel<-choose.files()

library(stringr)

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

imagenes[str_detect(imagenes, "Error")]




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


