#include "FileIO.ch"

// Exemplo de Uso
FUNCTION main()   
   LOCAL nNumero     := 0
   HB_SetIniComment(";", ";")

   LOG_CLEAR()
   IF nNumero > 0
      LOG_FLOW("IF -> nNumero > 0")
      //Regras
   ELSE
      LOG_FLOW("IF -> nNumero <= 0")
      //Regras
   ENDIF

   SWITCH nNumero
      CASE 0
         LOG_FLOW("Switch -> Case1 -> #nNumero = 0")
         EXIT
   END
RETURN NIL


// Apaga o arquivo e cria novamente
PROCEDURE LOG_CLEAR   
   LOCAL hIniData    := HB_ReadIni( "log.ini" )
   LOCAL nDebug      := CtoN(hIniData["LOG"]['status'])
   LOCAL cFile       := AllTrim(hIniData["LOG"]['file'])

   IF nDebug = 1
      FClose(FCreate(cFile))
   ENDIF
RETURN


// Gera o log indicando onde o script passou
PROCEDURE LOG_FLOW
   PARAM cLocalizador
   LOCAL hIniData    := HB_ReadIni( "log.ini" )
   LOCAL nDebug      := CtoN(hIniData["LOG"]['status'])
   LOCAL cFile       := AllTrim(hIniData["LOG"]['file'])   

   IF nDebug = 1
      LOG_WRITE(cLocalizador, "Debug de Execução")
   ENDIF
RETURN


// Escreve no arquivo de log
PROCEDURE LOG_WRITE
   PARAM cMessage, cType
   LOCAL hIniData    := HB_ReadIni( "log.ini" )
   LOCAL cFile       := AllTrim(hIniData["LOG"]['file'])
   LOCAL nHead       := CtoN(hIniData["LOG"]['head'])
   LOCAL nLogFile, cLine, bWrite

   nLogFile := FOpen(cFile, 1)

   IF FError() <> 0
      nLogFile := FCreate(cFile)
   ENDIF

   bWrite := <|cLine| 
      FSeek(nLogFile, 0, FS_END)
      cLine := cLine + Chr(13)+Chr(10)
      IF FWrite(nLogFile, cLine) <> Len(cLine)
         ? "Error while writing a file:", FError()
      ENDIF 
   >
     
   IF nHead = 1 .AND. ValType(lLogHead) = "U" 
      Eval(bWrite, "########################################################################")
      Eval(bWrite, PadR("## " + cType + " | " + DtoC(Date()) + " - " + Time() + " ", 72, "#"))
      Eval(bWrite, "########################################################################" + Chr(10))
      LOG_PPUBLIC()
   ENDIF

   AEVal(HB_ATokens(cMessage, chr(10)), bWrite)
   FClose(nLogFile)
RETURN

// Cria a variável pública
PROCEDURE LOG_PPUBLIC
   PUBLIC lLogHead := .T.
RETURN