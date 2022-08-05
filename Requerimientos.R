# REQUERIMEINTOS
setwd(DirectorioPadre)

  #source("VerificandoString.R")

# Funciones ---------------------------------------------------------------

imagen_principal<-function(imagenes){
  p<-imagenes[str_detect(imagenes, "Derecha") & str_detect(imagenes, "_1.jpg")]
  p<-str_sort(p, numeric = T, decreasing = T)
  p
}


imagen_frontal<-function(imagenes){
  p<-imagenes[str_detect(imagenes, "Derecha") & str_detect(imagenes, "_2.jpg")]
  p<-str_sort(p, numeric = T, decreasing = T)
  p
}

# Imagenes lateral
imagen_lateral<-function(imagenes){
  p<-imagenes[str_detect(imagenes, "Frontal") & str_detect(imagenes, "_1.jpg")]
  p<-str_sort(p, numeric = T, decreasing = T)
  p
}

# Imagenes lateral
imagen_lateral2<-function(imagenes){
  p<-imagenes[str_detect(imagenes, "Frontal") & str_detect(imagenes, "_2.jpg")]
  p<-str_sort(p, numeric = T, decreasing = T)
  p
}

# Imagen trasera
imagen_trasera<-function(imagenes){
  p<-imagenes[str_detect(imagenes, "Trasera") & str_detect(imagenes, "_1.jpg")]  
  p<-str_sort(p, numeric = T, decreasing = T)
  p
}

imagen_trasera2<-function(imagenes){
  p<-imagenes[str_detect(imagenes, "Trasera") & str_detect(imagenes, "_2.jpg")]  
  p<-str_sort(p, numeric = T, decreasing = T)
  p
}

imagen_izquierda<-function(imagenes){
  p<-imagenes[str_detect(imagenes, "Izquierda") & str_detect(imagenes, "_1.jpg")]  
  p<-str_sort(p, numeric = T, decreasing = T)
  p
}


imagen_izquierda2<-function(imagenes){
  p<-imagenes[str_detect(imagenes, "Izquierda") & str_detect(imagenes, "_.jpg")]  
  p<-str_sort(p, numeric = T, decreasing = T)
  p
}


imagenes_faltantes<-function(subgrupo, tr, tamano_tipo){
  
  reporte3<-NULL
  
  for (i in 1:length(tr)) {
    z<-NULL
    if (sum(str_detect(subgrupo, tr[i]))== 0) {
      z<-data.frame(
        "Estado"= rep(paste("En el item", sku(item)[1], "falta la imagen", tamano_tipo , 
                            "con la siguiente medida:")), 
        "Archivo"=tr[i])
    }
    reporte3<-rbind(z,reporte3)
  }
  reporte3
}

identificacion<-function(vista){
  if (!identical(vista, character(0))) {
    if (length(dimension(vista)) == length(total_tamanos)) {
      str_detect(vista, total_tamanos)
    }else{rep(F, length(total_tamanos))}
  }
}

# Todos los archivos que se subirán ---------------------------------------


setwd(carpeta)
imagenes<-list.files()

sku1<-unique(sku(imagenes))
total_tamanos<-c("1200Wx1200H", "515Wx515H", "400Wx600H", "300Wx300H" ,"96Wx96H", "65Wx65H","40Wx40H", "30Wx30H")
total_img_incopletas<-NULL

for (i in 1:length(sku1) ) {
  setwd(carpeta)
  
  item<-imagenes[str_detect(imagenes, sku1[i])]
  
  y<-NULL
  
  p<-NULL
  t<-NULL
  f<-NULL
  t<-NULL
  
  t2<-NULL
  l2<-NULL
  i1<-NULL
  i2<-NULL
  
  p<-identificacion(imagen_principal(item))
  l<-identificacion(imagen_lateral(item))
  f<-identificacion(imagen_frontal(item))
  t<-identificacion(imagen_trasera(item))
  
  t2<-identificacion(imagen_trasera2(item))
  l2<-identificacion(imagen_lateral2(item))
  i1<-identificacion(imagen_izquierda(item))
  i2<-identificacion(imagen_izquierda2(item))
  
  y<-cbind(p,l,f,t, t2, l2, i1, i2)
  
  if (any(colSums(y)==0)) {
    
    setwd(guardar)
    n<-paste("carpeta_errores_",basename(carpeta), sep="" )
    di_errores<-paste(guardar, "\\",n, sep = "")
    if ((sum(list.files()==n))==0) { dir.create(n)}
    
    TamanosFaltantes<-paste(di_errores, "\\","TamanosFaltantes_",sku(item)[1] , sep = "")
    
    dir.create(TamanosFaltantes)
    
    file_move(paste(carpeta,"\\", item, sep="") , TamanosFaltantes)
    
    
    # Reporte---------------------------------------------------
    
    ti<- data.frame("Estado" = "Total de Imagenes Incompletas" ,
                                      "Archivo"=sku1[i])
    
    especificamente<-rbind(
    imagenes_faltantes(imagen_frontal(item), total_tamanos, "Derecha_2"),
    imagenes_faltantes(imagen_lateral(item), total_tamanos, "Frontal_1"),
    imagenes_faltantes(imagen_principal(item), total_tamanos, "Derecha_1"),
    imagenes_faltantes(imagen_trasera(item),  total_tamanos, "Trasera_1"),
    
    imagenes_faltantes(imagen_trasera2(item), total_tamanos, "Trasera_2"),
    imagenes_faltantes(imagen_lateral2(item), total_tamanos, "Frontal_2"),
    imagenes_faltantes(imagen_izquierda(item), total_tamanos, "Izquierda_1"),
    imagenes_faltantes(imagen_izquierda2(item),  total_tamanos, "Izquierda_2")
    
    
    
    
    )
    
    total_img_incopletas<-rbind(total_img_incopletas, rbind(ti,especificamente))
    
  
    }
  
}  


tamanos_necesarios<-c("1200Wx1200H", "515Wx515H", "400Wx600H" ,"96Wx96H", "65Wx65H","40Wx40H")

 #Code --------------------------------------------------------------------
 setwd(carpeta)
 imagenes<-list.files()
   
 sku1<-unique(sku(imagenes))
 reporte2<-NULL
 
 for (i in 1:length(sku1)) {
   
   item<-imagenes[str_detect(imagenes, sku1[i]) ]
   
   reporte1<-NULL
   
   reporte1<-rbind(
     imagenes_faltantes(imagen_frontal(item), tamanos_necesarios, "Derecha_2"),
     imagenes_faltantes(imagen_lateral(item), tamanos_necesarios, "Frontal_1"),
     imagenes_faltantes(imagen_principal(item), tamanos_necesarios, "Derecha_1"),
     imagenes_faltantes(imagen_trasera(item),  tamanos_necesarios, "Trasera_1"),
     
     imagenes_faltantes(imagen_trasera2(item), total_tamanos, "Trasera_2"),
     imagenes_faltantes(imagen_lateral2(item), total_tamanos, "Frontal_2"),
     imagenes_faltantes(imagen_izquierda(item), total_tamanos, "Izquierda_1"),
     imagenes_faltantes(imagen_izquierda2(item),  total_tamanos, "Izquierda_2")
     
     )
 
   reporte2<-rbind(reporte2, reporte1)
   
 }
 
 
 if (!is.null(reporte2)) {
   
  q<-substr(reporte2$Estado, start = 12, stop = 21)
  y<-substr(reporte2$Estado, start =39, str_locate(reporte2$Estado, "con")[,1] -2 )
  
  reporte2<-data.frame("Estado" = c("Falta la vista"), 
             "Archivo"= unique(paste(y, q, sep = " en ")) )
  
  
   
   
   df<-data.frame(
     "Estado"= c("-----------------------------------------------------------------------------------"), 
     "Archivo"=c("--------------"))
   
   reporte2<-rbind(df, reporte2)
 }

 

 

