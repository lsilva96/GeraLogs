#include "FileIO.ch"

#define DEBUG_FILE   "./logDebug.log"
#define DEBUG_LOGS   .T.

FUNCTION main()
   LOCAL nNumero := 0

   IF nNumero > 0
      logLocal("#nNumero>0")
      //Regras
   ELSE
      logLocal("#nNumero<=0")
      //Regras
   ENDIF

RETURN NIL


// Gera o log indicando onde o script passou
PROCEDURE logLocal
   PARAM cLocalizador

   IF DEBUG_LOGS
      logWriteFile(cLocalizador, "Debug de Execução")
   ENDIF
RETURN


// Escreve no arquivo de log
FUNCTION logWriteFile
   PARAM cMessage, cType
   LOCAL cLine, bWrite, nLogFile

   nLogFile := FOpen(DEBUG_FILE, 1)

   IF (FError() <> 0); nLogFile := FCreate(DEBUG_FILE); ENDIF   

   bWrite := <| cLine | FSeek(nLogFile, 0, FS_END)
                        cLine := cLine + Chr(13)+Chr(10)
                        IF FWrite(nLogFile, cLine) <> Len(cLine)
                           ? "Error while writing a file:", FError()
                        ENDIF >
     

   Eval(bWrite, "########################################################################")
   Eval(bWrite, cType + " | " + DtoC(Date()) + " - " + Time() + ": " + Chr(10)+Chr(13))
   AEVAL(HB_ATokens(cMessage, chr(10)), bWrite)
   Eval(bWrite, "########################################################################")
   Eval(bWrite, " ")   
   FClose(nLogFile)
RETURN NIL