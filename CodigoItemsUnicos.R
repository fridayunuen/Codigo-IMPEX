#Medidas que aparecen en el codigo
Medidas<-c("1200Wx1200H", "515Wx515H","300Wx300H","96Wx96H","65Wx65H","30Wx30H")


setwd(DirectorioPadre)
# source("ItemsUnicosFamilia.R")

# archivos<-items_unicos
archivos<- list.files(carpeta)


setwd(carpeta)

# Definiendo bloques de acuerdo al SKU ------------------------------------

codigo<-NULL



id<-unique(sku(archivos))


if (identical(archivos, character(0))) {
  
  bloque<-NULL
  bloque2<-bloque
  
}else{
  
                                      

# Carga de media ----------------------------------------------------------
  
  bloque<-c("$productCatalog=default",
            "$productCatalogName=default",
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

  
  for (i in 1:length(id)) {
    
    imagenes<-archivos[str_detect(archivos, id[i])]
    
    # Subgrupos ---------------------------------------------------------------
    
    principal<-imagen_principal(imagenes)
    frontal<- imagen_frontal(imagenes)
    lateral<-imagen_lateral(imagenes)
    trasera<- imagen_trasera(imagenes)
    
    trasera2<-imagen_trasera2(imagenes) 
    lateral2<-imagen_lateral2(imagenes) 
    izquierda<-imagen_izquierda(imagenes)
    izquierda2<-imagen_izquierda2(imagenes)
    
    
    
    # Generando código .impex -------------------------------------------------
    
    codigo<-c("#_______________________________________________________________________________________________________________________________",
              "INSERT_UPDATE Media;code[unique=true];$media;mime[default='image/jpg'];folder(qualifier);mediaFormat(qualifier);$catalogVersion")
    
    agregar<-function(tipo, etiqueta){
      c1<-paste(paste(";/", etiqueta, sep = "") ,Medidas,"/", sku(tipo), ";"  ,tipo, ";images;images;", Medidas, sep = "")
      codigo<-c(codigo,c1)
      codigo
    }
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
    
    
      
    #### Aqui puede haber un if si hay mas imagenes que se puedan subir pejemplo: frontal_2
    
# Contenenedores ----------------------------------------------------------

  codigo<- c(codigo, "INSERT_UPDATE MediaContainer;qualifier[unique=true];$medias;$catalogVersion")
    
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
    
    contenedores<-paste(";", secuencia, ";/", tipo,Medidas[1],"/", id[i], ",/", tipo ,Medidas[2], "/", id[i], ",/",tipo ,Medidas[3],"/", id[i], ",/",tipo , Medidas[4] , "/", id[i],",/", tipo, Medidas[5],"/",  id[i],",/", tipo, Medidas[6],"/", id[i], sep = "")

    codigo<-c(codigo,contenedores) 
    
    
    # Fin del codigo principal, inicio del bloque
    
    m<-length(bloque)
    M<-length(codigo)+m
    bloque[(m+1):M]<-codigo
    ###

    
    
    # Comenzando con codigo Ranruas

# Codigo impex 2 (Ranuras) ------------------------------------------------

    codigo2<-c("INSERT_UPDATE Product;code[unique=true];$picture;$thumbnail;$detail;$others;$normal;$thumbnails;$galleryImages;$catalogVersion")
    
    # Concatenando las tallas que estan en el cubo
    
    items<-unique(sku(imagenes))
    
    talla<-if (sum(length(cubo[str_detect(cubo, items)]))>1) {
      
      c(items,
        cubo[str_detect(cubo, items)])
    }else{
      
      cubo[str_detect(cubo, unique(sku(imagenes)))]
    }
    
  z<-NULL
  for (j in 1:length(secuencia)) {
    z<-paste(z, secuencia[j], sep = ",")
  }
  z<-substr(z, 2, nchar(z))
  
  if (length(talla)==1) {
    if(!unique(sku(imagenes))==talla){
      talla<-c(unique(sku(imagenes)), talla)
    }
  }


  ranura<-paste(substr(talla, 1, 7),
            "_",
            substr(talla, 8, nchar(talla)), sep = "")
  
  
  allranuras<-c(replicate(ranura, n = length(tipo)))
  allranuras<-allranuras[str_order(allranuras)]

  
  codigo2<-c(codigo2,paste(";", allranuras,";/",  tipo, Medidas[1],"/",id[i],";/",   tipo,      Medidas[4],"/",id[i],";/", tipo,        Medidas[3],"/",id[i],";/",tipo,         Medidas[2],"/",id[i],";/", tipo,         Medidas[6],"/",id[i],",/",  tipo,       Medidas[5],"/",id[i],";/", tipo,Medidas[6],"/"  ,id[i],";",z, ";",sep = ""))
  
  n<-length(bloque2)
  N<-length(codigo2)+n
  
  bloque2[(n+1):N]<-codigo2
    
  }
  
}
