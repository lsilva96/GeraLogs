/*
 * Fun��es de log para debug de programas escritos em xHarbour
 * ATEN��O: Realizar o include do arquivo log.pr no final do arquivo de c�digo
 *          Verificar se o arquivo log.ini est� presente e configurar conforme necessidade
 *
 * PROCEDIMENTOS: 
 * LOG_INIT()  - Carrega os par�metros necess�rios para o funcionamento, iniciar na Main()
 *               ap�s a declara��o das vari�veis
 *
 * LOG_START() - !N�O CHAMAR DIRETAMENTE!
 *
 * LOG_CLEAR() - Limpa o arquivo de log
 *
 * LOG_FLOW()  - Adiciona um log do fluxo de execu��o do script, para isso, defina
 *               em alguns pontos do c�digo palavras chave para identificar o fluxo 
 *               de execu��o
 *               PARAMS: cLocalizador = Identificador no c�digo, ex: "IF -> nNumero <= 0" 
 *
 * LOG_WRITE() - !N�O CHAMAR DIRETAMENTE!
 * 
 * LOG_VAR()   - Em breve - Adiciona um log com o nome da vari�vel, tipo e valor
 *               PARAMS: cVarName = Nome da vari�vel
 *
 * LOG_API()   - Em breve - Adiciona um log da chamada da API e seu resultado
 *               PARAMS: cURL     = URL da requisi��o
 *                       cSend    = Requisi��o enviada
 *                       cReturn  = Requisi��o recebida
 */


// Inicia o processo de log
PROCEDURE LOG_INIT
   HB_SetIniComment(";", ";")
   LOG_START()   
RETURN


// L� o arquivo INI e inicia as vari�veis p�blicas
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
      LOG_WRITE(cLocalizador, "Debug de Execu��o")
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