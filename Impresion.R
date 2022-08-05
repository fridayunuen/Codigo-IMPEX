
### Mover a Ultimos detalles
if (is.null(bloque)) {
  
  winDialog(type="ok", message="La carpeta se encuentra vacia. Revise reporte 
              y carpeta de errores")
  
}else{
  #setwd(DirectorioPadre)
  #source("UltimosDetalles.R")
  
  setwd(carpeta)
  imagenes<-list.files()
  itemsgenerados<-unique(sku(imagenes))
  

  winDialog(type="ok", message="Codigo .impex generado con exito")
  
  setwd(resultados)
  
  write.table(bloque, "CodigoImpex_1.txt", row.names = FALSE, quote = FALSE, col.names = F)
  write.table(bloque2, "CodigoImpex_2_Ranuras.txt", row.names = FALSE, quote = FALSE, col.names = F)
  write.table(itemsgenerados, "ItemsGenerados.txt", row.names = FALSE, quote = FALSE, col.names = F)
  #write.table(bloque3, "ImpexContenedores.txt", row.names = FALSE, quote = FALSE, col.names = F)
  
}








