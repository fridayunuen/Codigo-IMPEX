library(readxl)

if (is.na(excel_format(excel))) {
  
  winDialog(type="ok", message="El archivo cubo no es formato excel")
  excel<-choose.files()
  
}else{
  
  libro<-read_excel(excel)
  
  if (is.null(libro$`Location Type`)){
    
    winDialog(type="ok", message="El archivo excel no tiene el formato requerido
              , revise que selecciono cubo con sku y tallas")
    excel<-choose.files()
    
  }else{
    libro<-libro$`Location Type`
  }
  
}


