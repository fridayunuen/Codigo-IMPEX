# Tamanos necesarios ------------------------------------------------------
# Se seleccionan solo los tamanos necesarios, el resto va a una carpta para reducir espacio

setwd(carpeta)
imagenes<-list.files()

tamanos_necesarios<-c("1200Wx1200H", "515Wx515H", "400Wx600H", "96Wx96H", "65Wx65H","40Wx40H")

z<-rep(F, times=length(imagenes))

for (i in 1:length(tamanos_necesarios)) {
  
  f<-c(str_detect(imagenes, tamanos_necesarios[i]))
  z<-cbind(z,f)
}

###########################

if (length(imagenes[!as.logical(rowSums(z))])==0) {
  print("Carpeta solo contiene imagenes necesarias")
}else{
  di_img_in<-guardar
  setwd(di_img_in)
  
  n<-paste("imagenes_innecesarias",basename(carpeta), sep="" )
  
  dir.create(n)
  
  di_img_in<-paste(di_img_in, "\\",n, sep = "")
  
  setwd(di_img_in)
  
  file_move(paste(carpeta, "\\", imagenes[!as.logical(rowSums(z))], sep=""), di_img_in)
  
  print("Se han seleccionado solo las imagenes necesarias")
  
  setwd(carpeta)
  
  imagenes<-list.files(carpeta)
}






# Dividiendo imagenes items unicos - items familia ------------------------

setwd(carpeta)

imagenes<-list.files()
items_unicos<-imagenes

items_familia<-NULL
z<-NULL

sku_items<-unique(sku(items_unicos))
id<-substr(sku_items, start = 1, stop = 7)
id_familia<-unique(id[duplicated(id)]) 

if (identical(id_familia, character(0))) {
  print("No hay items con familia")
}else{
  
  for (i in 1:length(id_familia)) {
    sku_items<-unique(sku(items_unicos))
    id<-substr(sku_items, start = 1, stop = 7)
    
    id_total<-substr(sku(items_unicos), start = 1, stop = 7)
    
    z<-items_unicos[str_detect(id_total, id_familia[i])]
    
    items_familia<-c(items_familia, z)
    
    items_unicos<-items_unicos[str_detect(id_total, id_familia[i], negate = T)]
  }
  
  items_familia
  items_unicos
  
}

imagenes<-list.files(carpeta)

