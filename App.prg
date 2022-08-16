#include "FileIO.ch"

// Exemplo de Uso
FUNCTION main()   
   LOCAL nNumero := 0
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

// Adiciona as funcionalidades de LOG
#include "log.prg"