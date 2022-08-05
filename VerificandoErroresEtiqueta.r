#Funciones ------------------------------------------------------------------------------------------------

dimension<-function(imagenes){
  guion<-str_locate(imagenes, "_")[1:length(imagenes)]
  substr(imagenes, start = 1, stop = guion-1) 
}

dim<-function(imagenes){
  x<-str_locate(dimension(imagenes), "W")[1:length(imagenes)]
  guion<-str_locate(imagenes, "x")[1:length(imagenes)]
  
  substr(
    substr(imagenes, start = 1, stop = guion-1), 
    start = 1, stop = x-1)
}

dim2<-function(imagenes){
  x<-str_locate(dimension(imagenes), "x")[1:length(imagenes)]
  h<-str_locate(dimension(imagenes), "H")[1:length(imagenes)]
  
  substr(imagenes, start = x+1, stop = h-1)
}

# validar que si tenga la terminacion .jpg o 4 caracteres en el nombre
nombre<-function(imagenes){
  guion<-str_locate(imagenes, "_")[1:length(imagenes)]
  substr(imagenes, start = guion +1, stop = nchar(imagenes)-4)
}

tipo<-function(imagenes){
  imagenes<-nombre(imagenes)
  guion<-str_locate(imagenes, "_")[1:length(imagenes)]
  substr(imagenes, start = 1, stop = guion-1)
}

# validar que sku sea tamano 10
sku<-function(imagenes){
  guion<-str_locate(nombre(imagenes), "_")[1:length(imagenes)]
  a<-substr(nombre(imagenes), start = guion+1, stop = nchar(imagenes))
  guion<-str_locate(a, "_")[1:length(imagenes)]
  substr(a, start = 1, stop = guion-1)  
}

# Detectando si la etiqueta contiene un error

setwd(carpeta)
imagenes<-list.files()


erroresetiqueta<-imagenes[tipo(imagenes)=="Error"]

if(!identical(erroresetiqueta, character(0))){
        # mover el archivo a una carpeta diferente
    if(length(erroresetiqueta)>0){
        dir.create(paste(guardar, "/Error", sep=""), showWarnings=FALSE)
    for(i in 1:length(erroresetiqueta)){
        file_move(erroresetiqueta[i], paste(guardar, "/Error/", erroresetiqueta[i] , sep=""))
    }
    }
}
# Open cmd and run the following command:
#system("cmd")
#    cd C:\Users\fcolin\Documents\Aplicacion\Reetiquetado
#    Python Ejecutable.py

 
# print("HelloWorld")
