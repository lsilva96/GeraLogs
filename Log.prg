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
      logWriteFile()
   ENDIF
RETURN


// Escreve no arquivo de log
FUNCTION logWriteFile
   IF ! FileValid(DEBUG_FILE)
      FCreate(DEBUG_FILE)
   ENDIF

   
RETURN NIL