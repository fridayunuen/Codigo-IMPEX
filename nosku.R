

if(!is.null(reporte)){
  if(sum(unique(reporte$Estado) == "El SKU no se encuentra en cubo")>=0){
    
    Producto<-reporte$Archivo
    
    Responsable <- as.character(Sys.info()["user"])
    
    Fecha<-as.character.Date(Sys.time()) 
    
    nosku<-data.frame("NoSKUCubo", Producto, Responsable, Fecha)
    
    if(dir.exists("S:/OMNI/ReporteGeneral")){
      setwd("S:/OMNI/ReporteGeneral")
      
      csv<-read.csv("ProblemasSKU.csv")
      
      nosku<-rbind(csv, nosku)
      
      write.csv(nosku, "ProblemasSKU.csv", row.names = FALSE)
      
    }else{
      
      setwd(guardar)
      
      if (file.exists("ENVIAR-a-RESPONSABLE-ProblemasSKU.csv")){
        
        
        csv<-read.csv("ENVIAR-a-RESPONSABLE-ProblemasSKU.csv")
        csv<-data.frame(csv)
        
        csv<-rbind(csv, nosku)
        
        write.csv(csv, "ENVIAR-a-RESPONSABLE-ProblemasSKU.csv", row.names = FALSE)
        
        
      }else{
        write.csv(nosku, "ENVIAR-a-RESPONSABLE-ProblemasSKU.csv", row.names = FALSE)
        
        
      }
      
      
      
      
    }
    
    
    
  }
  
  
}



