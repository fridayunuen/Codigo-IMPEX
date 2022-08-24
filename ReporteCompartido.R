Responsable <- rep(Sys.info()["user"], length(itemsgenerados))
Fecha <- as.character.Date(Sys.time())

repgenerado <- data.frame(itemsgenerados, Responsable, Fecha)

if (dir.exists("S:/OMNI/ReporteGeneral")) {
  
  setwd("S:/OMNI/ReporteGeneral")
  
  rep <- read.csv("ProductosIMPEX.csv")
  rep <- data.frame(rep)

  rep <- rbind(rep, repgenerado)
  
  write.csv(rep, "ProductosIMPEX.csv", row.names = FALSE)

}else {
  setwd(guardar)
  
  if (file.exists("ENVIAR-a-RESPONSABLE-ProductosIMPEX.csv")){
    
    rep <- read.csv("ENVIAR-a-RESPONSABLE-ProductosIMPEX.csv")
    rep <- data.frame(rep)
    
    rep <- rbind(rep, repgenerado)
    
    write.csv(rep, "ENVIAR-a-RESPONSABLE-ProductosIMPEX.csv", row.names = FALSE)
    
  }else {
    write.csv(repgenerado, "ENVIAR-a-RESPONSABLE-ProductosIMPEX.csv", row.names = FALSE)
    
    
  }
  
}

setwd(DirectorioPadre)
