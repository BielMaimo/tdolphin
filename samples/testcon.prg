//#include "hbcompat.ch"
#include "tdolphin.ch"
#define CRLF Chr( 13 ) + Chr( 10 )

PROCEDURE Main()
   
   LOCAL oServer   := NIL
   LOCAL cText := ""
   
   
   IF ( oServer := ConnectTo() ) == NIL
      RETURN 
   ENDIF

   IF ! oServer:lError 
      cText += "Connection OK" + CRLF
      cText += "Host: " + oServer:cHost +CRLF
      cText += "Database: " +oServer:cDBName + CRLF
      cText += oServer:GetServerInfo() + CRLF 
      cText += oServer:GetClientInfo()

      ? cText + CRLF

   ENDIF

   oServer:End()

RETURN

#include "connto.prg"