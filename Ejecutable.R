#source("Directorios.txt")

DirectorioPadre<-getwd()
setwd(DirectorioPadre)

carpeta<-choose.dir(caption = "Seleccione la carpeta que contiene las imagenes")
guardar<-choose.dir(caption = "¿Dónde se guardarán los resultados?")
excel<-choose.files()

megas<-32


source("ValidacionInputs.R")

source("Progreso.R")

setwd(DirectorioPadre)

# Depuramos memoria
rm(list = ls())

