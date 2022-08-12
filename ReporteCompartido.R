Responsable<-rep(Sys.info()["user"], length(itemsgenerados))
Fecha<-as.character.Date(Sys.time())  


repgenerado<-data.frame(itemsgenerados, Responsable,Fecha)


setwd("S:/OMNI/ReporteGeneral")
rep<-read.csv("ProductosIMPEX.csv")
rep<-data.frame(rep)

rep<-rbind(rep, repgenerado)

write.csv(rep, "ProductosIMPEX.csv", row.names = FALSE)

setwd(DirectorioPadre)
