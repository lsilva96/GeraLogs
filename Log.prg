#include "FileIO.ch"

#define DEBUG_FILE   "./logDebug.log"
#define DEBUG_LOGS   .T.

FUNCTION main()
   LOCAL nNumero     := 0
   PUBLIC lLogHead   := .F.

   clearLog()
   IF nNumero > 0
      logLocal("IF -> nNumero > 0")
      //Regras
   ELSE
      logLocal("IF -> nNumero <= 0")
      //Regras
   ENDIF

   SWITCH nNumero
      CASE 0
         logLocal("Switch -> Case1 -> #nNumero = 0")
         EXIT
   END
RETURN NIL


// Apaga o arquivo e cria novamente
PROCEDURE clearLog
   FClose(FCreate(DEBUG_FILE))
RETURN


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
   LOCAL nLogFile, cLine, bWrite

   nLogFile := FOpen(DEBUG_FILE, 1)

   IF FError() <> 0
      nLogFile := FCreate(DEBUG_FILE)
   ENDIF

   bWrite := <|cLine| 
      FSeek(nLogFile, 0, FS_END)
      cLine := cLine + Chr(13)+Chr(10)
      IF FWrite(nLogFile, cLine) <> Len(cLine)
         ? "Error while writing a file:", FError()
      ENDIF 
   >
     
   IF lLogHead = .F.
      Eval(bWrite, "########################################################################")
      Eval(bWrite, PadR("## " + cType + " | " + DtoC(Date()) + " - " + Time() + " ", 72, "#"))
      Eval(bWrite, "########################################################################" + Chr(10))
      lLogHead := .T.
   ENDIF

   AEVal(HB_ATokens(cMessage, chr(10)), bWrite)
   FClose(nLogFile)
RETURN NIL