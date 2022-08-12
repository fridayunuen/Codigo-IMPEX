
if(!is.null(reporte)){
  if(unique(reporte$Estado) == "El SKU no se encuentra en cubo"){
    
    setwd("S:/OMNI/ReporteGeneral")
    
    csv<-read.csv("ProblemasSKU.csv")
    
    Producto<-reporte$Archivo
    
    Responsable <- as.character(Sys.info()["user"])
    
    Fecha<-as.character.Date(Sys.time()) 
    
    nosku<-data.frame("NoSKUCubo", Producto, Responsable, Fecha)
    
    nosku<-rbind(csv, nosku)
    
    write.csv(nosku, "ProblemasSKU.csv", row.names = FALSE)
    
  }
  
  
}



