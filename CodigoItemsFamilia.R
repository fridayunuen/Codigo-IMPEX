
setwd(DirectorioPadre)
# source("CodigoItemsUnicos.R")

archivos<-items_familia

setwd(carpeta)

# Definiendo bloques de acuerdo al SKU ------------------------------------
archivos<-items_familia
id<-unique(sku(archivos))

if (is.null(archivos)) {
  print("No hay archivos con familia")
}else{
  
  # Carga de media ----------------------------------------------------------
  
  
  if (is.null(bloque)) {
    
    bloque<-c("$productCatalog=shasaProductCatalog",
              "$productCatalogName=shasaProductCatalogName",
              "$catalogVersion=catalogversion(catalog(id[default=$productCatalog]),version[default='Staged'])[unique=true,default=$productCatalog:Staged]",
              "$media=@media[translator=de.hybris.platform.impex.jalo.media.MediaDataTranslator]",
              "$medias=medias(code, $catalogVersion)",
              "$picture=picture(code, $catalogVersion)",
              "$galleryImages=galleryImages(qualifier, $catalogVersion)",
              "$thumbnail=thumbnail(code, $catalogVersion)",
              "$thumbnails=thumbnails(code, $catalogVersion)",
              "$detail=detail(code, $catalogVersion)",
              "$normal=normal(code, $catalogVersion)",
              "$others=others(code, $catalogVersion)",
              "$data_sheet=data_sheet(code, $catalogVersion)",
              "$individualPhotos=individualPhotos(code, $catalogVersion)")
    bloque2<-bloque
  
    
  }
  
  archivos<-items_familia
  identificador_familia<-unique(substr(sku(archivos), 1, 7))
  
  
  for (j in 1:length(identificador_familia)) {
    
    archivos<-items_familia
    
    archivos<-archivos[str_detect(archivos, identificador_familia[j])]
    id<-unique(sku(archivos))
    codigo<-c("#_______________________________________________________________________________________________________________________________",
              "INSERT_UPDATE Media;code[unique=true];$media;mime[default='image/jpg'];folder(qualifier);mediaFormat(qualifier);$catalogVersion")
    
    for (i in 1:length(id)) {
      
      imagenes<-archivos[str_detect(archivos, id[i])]
      
      # Subgrupos ---------------------------------------------------------------
      
      principal<-imagen_principal(imagenes)
      frontal<- imagen_frontal(imagenes)
      lateral<-imagen_lateral(imagenes)
      trasera<- imagen_trasera(imagenes)
      
      trasera2<-imagen_trasera2(item) 
      lateral2<-imagen_lateral2(item) 
      izquierda<-imagen_izquierda(item)
      izquierda2<-imagen_izquierda2(item)
      
      # Generando c??digo .impex -------------------------------------------------
      
      
      agregar<-function(tipo, etiqueta){
        c1<-paste(paste(";/", etiqueta, sep = "") ,Medidas,"/", sku(tipo), ";"  ,tipo, ";images;images;", Medidas, sep = "")
        codigo<-c(codigo,c1)
        codigo}
      # Vacio para unico, es posible cambiar el valor de las etiquetas
      
      # Vacio para unico, es posible cambiar el valor de las etiquetas
      if (!identical(principal, character(0))) {
        codigo<-agregar(principal,   "")}
      if (!identical(frontal, character(0))){
        codigo<-agregar(frontal,   "frontal-/")}
      if (!identical(lateral, character(0))) {
        codigo<-agregar(lateral,   "izq-/")}
      if (!identical(trasera, character(0))) {
        codigo<-agregar(trasera,   "back-/")}
      
      
      if (!identical(trasera2, character(0))) {
        codigo<-agregar(trasera2,   "back2-/")}
      if (!identical(lateral2, character(0))) {
        codigo<-agregar(lateral2,   "lateral2-/")}
      if (!identical(izquierda, character(0))) {
        codigo<-agregar(izquierda,   "der-/")}
      if (!identical(izquierda2, character(0))) {
        codigo<-agregar(izquierda2,   "der2-/")}
      
    }
      #### Aqui puede haber un if si hay mas imagenes que se puedan subir pejemplo: frontal_2
    
      codigo<- c(codigo, "INSERT_UPDATE MediaContainer;qualifier[unique=true];$medias;$catalogVersion")
      z=NULL
      
      for (k in 1:length(id)) {
        imagenes<-archivos[str_detect(archivos, id[k])]
        
        # Subgrupos ---------------------------------------------------------------
        
        principal<-imagen_principal(imagenes)
        frontal<- imagen_frontal(imagenes)
        lateral<-imagen_lateral(imagenes)
        trasera<- imagen_trasera(imagenes)
        
        trasera2<-imagen_trasera2(item) 
        lateral2<-imagen_lateral2(item) 
        izquierda<-imagen_izquierda(item)
        izquierda2<-imagen_izquierda2(item)
        

        tipo<-NULL
        
        if (!identical(principal, character(0))) {
          tipo<-c(tipo, "")}
        if (!identical(frontal, character(0))){
          tipo<-c(tipo, "frontal-/")}
        if (!identical(lateral, character(0))) {
          tipo<-c(tipo, "izq-/")}
        if (!identical(trasera, character(0))) {
          tipo<-c(tipo, "back-/")}
        
        if (!identical(trasera2, character(0))) {
          tipo<-c(tipo,   "back2-/")}
        if (!identical(lateral2, character(0))) {
          tipo<-c(tipo,   "lateral2-/")}
        if (!identical(izquierda, character(0))) {
          tipo<-c(tipo,   "der-/")}
        if (!identical(izquierda2, character(0))) {
          tipo<-c(tipo,   "der2-/")}
        
        
        secuencia<-paste(id[k], 1:length(tipo) , sep = "")
        
        contenedores<-paste(";", secuencia, ";/", tipo,Medidas[1],"/", id[k], ",/", tipo ,Medidas[2], "/", id[k], ",/",tipo ,Medidas[3],"/", id[k], ",/",tipo , Medidas[4] , "/", id[k],",/", tipo, Medidas[5],"/",  id[k],",/", tipo, Medidas[6],"/", id[k], sep = "")
        z<-c(z, contenedores)

        codigo<-c(codigo,contenedores)
        
        
      }
      
      m<-length(bloque)
      M<-length(codigo)+m
      bloque[(m+1):M]<-codigo
      
    }
    
    
    
    
    # Codigo IMPEX 2 ranuras --------------------------------------------------
  q=NULL
  
  for (j in 1:length(identificador_familia)) {
    
    archivos<-items_familia
    
    archivos<-archivos[str_detect(archivos, identificador_familia[j])]
    id<-unique(sku(archivos))
    codigo2<-c("#_______________________________________________________________________________________________________________________________",
              "INSERT_UPDATE Media;code[unique=true];$media;mime[default='image/jpg'];folder(qualifier);mediaFormat(qualifier);$catalogVersion")
    
    for (i in 1:length(id)) {
      
      imagenes<-archivos[str_detect(archivos, id[i])]
      
      
      principal<-imagen_principal(imagenes)
      frontal<- imagen_frontal(imagenes)
      lateral<-imagen_lateral(imagenes)
      trasera<- imagen_trasera(imagenes)
      
      trasera2<-imagen_trasera2(imagenes) 
      lateral2<-imagen_lateral2(imagenes) 
      izquierda<-imagen_izquierda(imagenes)
      izquierda2<-imagen_izquierda2(imagenes)
      
      
      tipo<-NULL
      
      if (!identical(principal, character(0))) {
        tipo<-c(tipo, "")}
      if (!identical(frontal, character(0))){
        tipo<-c(tipo, "frontal-/")}
      if (!identical(lateral, character(0))) {
        tipo<-c(tipo, "izq-/")}
      if (!identical(trasera, character(0))) {
        tipo<-c(tipo, "back-/")}
      
      if (!identical(trasera2, character(0))) {
        tipo<-c(tipo,   "back2-/")}
      if (!identical(lateral2, character(0))) {
        tipo<-c(tipo,   "lateral2-/")}
      if (!identical(izquierda, character(0))) {
        tipo<-c(tipo,   "der-/")}
      if (!identical(izquierda2, character(0))) {
        tipo<-c(tipo,   "der2-/")}
      
      
      secuencia<-paste(id[i], 1:length(tipo), sep = "")
      
      z<-NULL
      for (k in 1:length(secuencia)) {
        z<-paste(z, secuencia[k], sep = ",")
      }
      z<-substr(z, 2, nchar(z))
      
      talla<-if (sum(length(cubo[str_detect(cubo, unique(sku(imagenes)))]))>1) {
        
        c(unique(sku(imagenes)),
          cubo[str_detect(cubo, unique(sku(imagenes)))])
      }else{
        
        cubo[str_detect(cubo, unique(sku(imagenes)))]
      }
      if (length(talla)==1) {
        if(!unique(sku(imagenes))==talla  ){
          talla<-c(unique(sku(imagenes)), talla)
        }
      }      
      ranura<-paste(substr(talla, 1, 7),
                    "_",
                    substr(talla, 8, nchar(talla)), sep = "")
      
      q<-c(q, paste(";", ranura,";/", Medidas[1],"/",id[i],
                       ";/", Medidas[4],"/",id[i],";/", Medidas[3],"/",id[i],";/", 
                       Medidas[2],"/",id[i],";/", Medidas[6],"/",id[i],",/", 
                       Medidas[5],"/",id[i],";/", Medidas[6],"/"  ,id[i],";",z, ";",
                       sep = ""))
      
      
    }
    codigo2<-c(codigo2, q)
    
    n<-length(bloque2)
    N<-length(codigo2)+n
    
    bloque2[(n+1):N]<-codigo2
    
  
      
      }
    
  }
  

