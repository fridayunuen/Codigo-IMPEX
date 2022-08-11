cubo<-libro[!is.na(as.numeric(libro))] 
# existe?


# Detectando si los sku se encuentran dentro de el cubo 

imagenes<-list.files(carpeta)
items<-unique(sku(imagenes))

z<-NULL
x<-NULL
for (i in 1:length(items)) {
  repo<-NULL
  repo2<-NULL

  if (sum(str_detect(cubo, items[i]))==0) {
    repo<-items[i]

    repo2<-imagenes[str_detect(imagenes, items[i])]
  }
  
  z<-c(z, repo)
  x<-c(x, repo2)
  
}

# Si sku no existe en cubo se envia a carpeta de errores 
  df<-NULL
if (!is.null(z)) {
  
  di_errores<-guardar
  setwd(di_errores)
  
  n<-paste("carpeta_errores_",basename(carpeta), sep="" )
  
  if ((sum(list.files()==n))==0) { dir.create(n)}
  
  di_errores<-paste(di_errores, "\\",n, sep = "")
  
  setwd(di_errores)
  
  nocubo<-paste(di_errores, "\\", "NoSKUCubo", sep="")

    dir.create(nocubo)
  
  for (j in 1:length(x)) {
    file_move(paste(carpeta,"\\", x[j], sep="") , nocubo)  
  }
  setwd(carpeta)

  df<-data.frame("Estado" = c("El SKU no se encuentra en cubo") ,
             "Archivo"=z)
  #reporte<-rbind(reporte, df)
  
}  

setwd(carpeta)
imagenes<-list.files()  

reporte<-NULL

reporte<-rbind(
  errores,
  #extension,
  vmedidas,
  espacio,
  nom,
  nom2,
  vsku,
  terminacion,
  total_img_incopletas,
  df) 
  #reporte2)


# Imprimiendo cuadro de dialago que informa que hay errores
  
  if (is.null(reporte)) {
    print("Sin errores")
  }else{
    
    setwd(guardar)
    
    write.table(reporte, "Reporte.txt", row.names = F, quote = FALSE)
    
    winDialog(type="ok", message="Errores localizados. Revise reporte 
              y carpeta de errores")
    
  }
  
  
  