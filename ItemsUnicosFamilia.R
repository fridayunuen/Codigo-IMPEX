






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

