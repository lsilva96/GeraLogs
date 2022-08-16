#include "FileIO.ch"

// Exemplo de Uso
FUNCTION main()   
   LOCAL nNumero     := 0
   LOG_INIT()

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


// Inicia o processo de log
PROCEDURE LOG_INIT
   HB_SetIniComment(";", ";")
   LOG_START()   
RETURN


// Lê o arquivo INI e inicia as variáveis públicas
PROCEDURE LOG_START
   LOCAL    hIniData       := HB_ReadIni( "log.ini" )
   PUBLIC   nLogDebug      := CtoN(hIniData["LOG"]['status'])
   PUBLIC   cLogFile       := AllTrim(hIniData["LOG"]['file'])   
   PUBLIC   nLogHead       := CtoN(hIniData["LOG"]['head'])
   PUBLIC   nLogClear      := CtoN(hIniData["LOG"]['clear'])
   PUBLIC   lLogHeadAdded  := .F.

   IF nLogClear = 1
      LOG_CLEAR()
   ENDIF
RETURN


// Apaga o arquivo e cria novamente
PROCEDURE LOG_CLEAR   
   IF nLogDebug = 1
      FClose(FCreate(cLogFile))
   ENDIF
RETURN


// Gera o log indicando onde o script passou
PROCEDURE LOG_FLOW
   PARAM cLocalizador
   IF nLogDebug = 1
      LOG_WRITE(cLocalizador, "Debug de Execução")
   ENDIF
RETURN


// Escreve no arquivo de log
PROCEDURE LOG_WRITE
   PARAM cMessage, cType
   LOCAL nLogFile, cLine, bWrite

   nLogFile := FOpen(cLogFile, 1)

   IF FError() <> 0
      nLogFile := FCreate(cLogFile)
   ENDIF

   bWrite := <|cLine| 
      FSeek(nLogFile, 0, FS_END)
      cLine := cLine + Chr(13)+Chr(10)
      IF FWrite(nLogFile, cLine) <> Len(cLine)
         ? "Error while writing a file:", FError()
      ENDIF 
   >
     
   IF nLogHead = 1 .AND. lLogHeadAdded = .F. 
      Eval(bWrite, " ")
      Eval(bWrite, "########################################################################")
      Eval(bWrite, PadC(" Log Iniciado | " + DtoC(Date()) + " - " + Time() + " ", 72, "#"))
      Eval(bWrite, "########################################################################" + Chr(10))
      lLogHeadAdded := .T.
   ENDIF

   Eval(bWrite, "# " + cType + " | " + DtoC(Date()) + " - " + Time() + ": ")
   AEVal(HB_ATokens(cMessage, chr(10)), bWrite)
   Eval(bWrite, " ")

   FClose(nLogFile)
RETURN