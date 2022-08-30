/*
 * Funções de log para debug de programas escritos em xHarbour
 * ATENÇÃO: Realizar o include do arquivo log.pr no final do arquivo de código
 *          Verificar se o arquivo log.ini está presente e configurar conforme necessidade
 *
 * PROCEDIMENTOS: 
 * LOG_INIT()  - Carrega os parâmetros necessários para o funcionamento, iniciar na Main()
 *               após a declaração das variáveis
 *
 * LOG_START() - !NÃO CHAMAR DIRETAMENTE!
 *
 * LOG_CLEAR() - Limpa o arquivo de log
 *
 * LOG_FLOW()  - Adiciona um log do fluxo de execução do script, para isso, defina
 *               em alguns pontos do código palavras chave para identificar o fluxo 
 *               de execução
 *               PARAMS: cLocalizador = Identificador no código, ex: "IF -> nNumero <= 0" 
 *
 * LOG_WRITE() - !NÃO CHAMAR DIRETAMENTE!
 * 
 * LOG_VAR()   - Adiciona um log com o nome da variável, tipo e valor
 *               PARAMS: xVar     = Variável
 *                       cVarName = Nome da variável
 *
 * LOG_API()   - Em breve - Adiciona um log da chamada da API e seu resultado
 *               PARAMS: cURL     = URL da requisição
 *                       cSend    = Requisição enviada
 *                       cReturn  = Requisição recebida
 */


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

   IF nLogClear == 1
      LOG_CLEAR()
   ENDIF
RETURN


// Apaga o arquivo e cria novamente
PROCEDURE LOG_CLEAR   
   IF nLogDebug == 1
      FClose(FCreate(cLogFile))
   ENDIF
RETURN


// Gera o log indicando onde o script passou
PROCEDURE LOG_FLOW
   PARAM cLocalizador
   IF nLogDebug == 1
      LOG_WRITE(cLocalizador, "Debug de Execução")
   ENDIF
RETURN


// Gera o log com o conteúdo da variável e o tipo
PROCEDURE LOG_VAR
   PARAM xVar, cVarname
   
   Default(@cVarname, 'notInformed')
   
   IF Valtype(xVar) <> "U"
      LOG_WRITE("Tipo: "+ Valtype(xVar) + Chr(10) + "Valor: " + HB_DumpVar(xVar), "Debug da Variável " + cVarName)
   ELSE
      LOG_WRITE("Tipo: "+ Valtype(xVar) + Chr(10) + "Valor: Variável Vazia", "Debug da Variável " + cVarName)
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
     
   IF nLogHead == 1 .AND. lLogHeadAdded == .F. 
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
