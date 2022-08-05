setwd(carpeta)

# si el tamaño es mayor a 

archivos<-list.files()

requerimiento<- (megas*1000000)

# Si los archivos son mayores iguales a lo que soporta SAP en una subida se 
# dividen los archivos ne pequeños lotes

if (sum(file.size(archivos))>=requerimiento) {
  
  r<-0
  
  while (!identical(archivos, character(0))) {
    r<-r+1
    bytes<-file.size(archivos)
    
    df<-data.frame("imagenes"=archivos, bytes)
    
    p<-NULL
    q<-NULL
    
    for (i in 1:length(df$bytes)) {
      q<-c(q, df$bytes[i])
      if (sum(q)<requerimiento) {
        p<-c(p, df$bytes[i])
        
      }else{
        p<-c(p,0)
        
      }
      
    }
    
    
    nombrezip<-paste("Lote", r, ".zip", sep = "")
    
    zip(nombrezip, df[p!=0,]$imagenes)
    
    file_move(nombrezip, resultados)
    
    archivos<-df[p==0,]$imagenes
    
  }
  
  
}
