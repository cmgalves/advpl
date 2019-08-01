#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

&& Nome       : Classe de Boleto Bancário do Banco do Brasil para Impressora Laser
&& Descrição  : Esta Classe Permite a Impressão do Boleto Bancário em Relatório Gráfico TMSPrinter()
&& Nota       : Esta classe ira imprimir o boleto mesmo que o mesmo nao tenha sido enviado ao banco atraves do CNAB          
&& 			    Baseado na Especificação Técnica de Cobrança BB Versão 1 de 30/05/2007
&& 			    Baseado na Especificação Técnica de Cobrança Bradesco de 10/2002
&& 			    Baseado na Especificação Técnica de Cobrança Itaú de Setembro/2007
&& 			    %E1_PORJUR%, %E1_VALJUR% e %E!_DESCFIN% são indicadores que podem ser usados nas mensagens do Boleto, que serão convertidos automaticamente pelos valores
&& 			    Criado Funções de Modulo10, Modulo11, Nosso Número, Cód. de Barra e Linha Digitável Genéricas para os Principais Bancos
&& 			    Site para Validação de Código de Barras: http:&& evandro.net/codigo_barras.htm
&& 			    Site do FEBRABAN: http:&& www.febraban.org.br/
&& 			    Site de Conversão de Medidas: http:&& www.translatorscafe.com/cafe/units-converter/typography/calculator/pixel-(X)-to-centimeter-%5Bcm%5D/
&& 			    Pontos Específicos de Cada Banco no Código: 	Method NossoNro(), Method RetNossoNro() e Method CodBarra()    					 

&& Campos Pers: - E1_ZZBLT  (LOGICO)   - Boleto Impresso? - SE1 - Para determinar se vai ou nao ao CNAB apos a impressao
&& 			   	- EE_ZZCART (CARAC. 3) - Carteira junto com os parâmetros do CNAB - SEE

&& Cons.Pers  : - SA61 (Específico do BB - Filtro do Banco, tal como "001" ou "237", etc) 
&& 			    - ZZBL (Consulta Esp da Tabela Z1 do SX5 - Mensagens para o Boleto) - Usar Função SX5DESF3("Z1",.T.,.T.)

&& Ambiente   : Financeiro

&& Autor      : Winston Dellano de Castro - Totvs IP Ribeirão
&& Alteracoes : Mary Hergert - Totvs IP Campinas (alteracoes especificas Plasticos MB
&& Dt Criação : 19/01/2010

&& Constantes de Margem das Páginas
#DEFINE HMARGEM   050
#DEFINE VMARGEM   050

&& Constantes para Alinhamento de Texto
#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2

&& ###############################
&& UTILIZAÇÃO DA CLASSE DO BOLETO
&& ###############################

&& Função de Exemplo para Uso da Classe do Boleto para o Banco do Brasil
User Function BolBB()

	local oBoleto := nil
	local cFiltro := ""
	
	&& Filtro para Teste da Classe
	&& USAR FILTRO NA ORDEM 1 DO SE1: E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	&& local cFiltro:="E1_FILIAL=='" + xFilial("SE1") + "' .AND. E1_PREFIXO == 'UNI' .AND. E1_NUM == '044722' .AND. E1_PARCELA == '  ' .AND. E1_TIPO == 'NF' "

	&& Imprime Boleto do Banco do Brasil e Não Apresenta Perguntas na Inicialização
	&& Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	&& e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	&& Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("18")
	oBoleto := Boleto():new("001",.T.,cFiltro,1)

return

&& Função de Exemplo para Uso da Classe do Boleto para o Banco Bradesco
User Function BolBRA()

	local oBoleto := nil
	local cFiltro := ""

	&& Imprime Boleto do Banco Bradesco, Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 2
	&& Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	&& e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	&& Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("19")
	oBoleto := Boleto():new("237",.T.,cFiltro,2)

return

&& Função de Exemplo para Uso da Classe do Boleto para o Banco Safra (Banco Correspondente = Bradesco)
User Function bltSafra()

	local oBoleto := nil
	local cFiltro := ""

	&& Imprime Boleto do Banco Safra, Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 2
	&& Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	&& e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	&& Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("09")
	oBoleto := Boleto():new("422",.T.,cFiltro,1)

return

&& Função de Exemplo para Uso da Classe do Boleto para o Banco Itaú
User Function BolITA()

	local oBoleto := nil
	local cFiltro := ""

	&& Imprime Boleto do Banco Itaú, Não Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 2
	&& Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	&& e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	&& Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("110")
	oBoleto := Boleto():new("341",.F.,cFiltro,2)

return

&& Função de Exemplo para Uso da Classe do Boleto para o Banco Votorantim (Banco Correspondente = Itau)
User Function bltVtm()

	local oBoleto := nil
	local cFiltro := ""

	&& Imprime Boleto do Banco Votorantim, Apresenta Perguntas na Inicialização e Usa o Modelo de Layout 1
	&& Para Configurar o Convênio que será utilizado, alimente o campo EE_CODEMP com o Convenio com o Nº de Dígitos Corretos
	&& e Também o Campo EE_FAXATU com o nº de dígitos do nº sequencial utilizado pela empresa de acordo com o Convenio utilizado
	&& Adicione o campo personalizado EE_ZZCART e adicione a carteira utilizada pelo Banco ("109")
	oBoleto := Boleto():new("655",.T.,cFiltro,1)

return

&& ###############################
&& DEFINIÇÃO DA CLASSE DO BOLETO
&& ###############################

Class Boleto

	&& Atributos para Seleção dos Dados a Imprimir
	Data cAlias
	Data cCpoMark
	Data cIndexName
	Data cIndexKey 
	Data cFilter
	Data lFiltrado
    
    && Atributos dos Dados para o Relatório
	Data cBanco
	Data aCampos
	Data aDadosEmp
	Data aDadosSel
	Data aDadosTit
	Data aDadosBanco
	Data aDadosSac
	Data cNossoNum
	Data cCodBarra
	Data cLinhaDig
	Data aFrases  
	Data cProtesto
	                  
	&& Atributos para Geração do Relatório 
	Data oReport
	Data aLogoBco
	Data lMostraPrg
	Data cGrpPerg
	Data aPergs	
	Data cTamanho
	Data ctitulo 
	Data cDesc1  
	Data cDesc2 
	Data cDesc3
	Data wnrel  
	Data areturn
	Data nLastKey
	Data nModelo
	
	&& Métodos
	Method new(cCodBanco,lPrgOnInit,cFiltro) Constructor	&& Inicializa os Atributos da Classe
	Method openReport()										&& Executa o Assistente e Dispara os outros métodos
	Method loadPergs()										&& Carrega as Peguntas
	Method montaRel()										&& Carrega os Dados e Dispara a Impressão
	Method nossoNro(cNossNroOld)							&& Define o Nosso Número
	Method retNossoNro()									&& Retorna o Nosso Número Formatado
	Method codBarra()										&& Define o Código de Barras e a Linha Digitável
	Method printRel()								  		&& Executa a Impressão do Boleto
	Method grvNossNum()										&& Grava o Nosso Número no SE1
	Method somaUtil()										&& Soma determinada quantidade de dias uteis a uma data
				
End Class  

&& Inicializa o Objeto Boleto e Abre o Assistente de Impressão do Relatório
/*cCodBanco disponíveis:
- 001 (BB) - Cart. 18 Convênio de 4, 6 e 7 Dígitos e Cart. 11
- 033 (SANTANDER)
- 104 (CEF)
- 237 (BRADESCO) - Carteira 19
- 422 (SAFRA) - Banco Correspondente
- 341 (ITAÚ)
- 655 (VOTORANTIM) - Banco Correspondente
- 409 (UNIBANCO)
 */
Method new(cCodBanco,lPrgOnInit,cFiltro,nModelo) Class Boleto

	default lPrgOnInit :=.F.
	default cCodBanco  :="001" && Banco do Brasil
	default cFiltro    :=""
	default nModelo    :=1 && Modelos Disponíveis: 1 e 2

	&& Inicializa Propriedades do Objeto
	::lMostraPrg  := lPrgOnInit && Indica se irá abrir as Perguntas na Inicialização
	::cBanco	  := cCodBanco && Informa o Código do Banco a ser gerado o Boleto
	::cNossoNum	  := ""
	::cCodBarra   := ""
	::cLinhaDig	  := ""

	if !Empty(cFiltro)
		::cFilter  :=cFiltro && Filtro Passado pelo Usuário para Impressão Direta
		::lFiltrado:=.T.
	else 
		::cFilter  :=""
		::lFiltrado:=.F.
	endif
	
	if alltrim(cCodBanco) == "001"
		::cGrpPerg := padr("ZZBL01",len(SX1->X1_GRUPO))
	elseif alltrim(cCodBanco) == "422"
		::cGrpPerg := padr("BLTSAFRA",len(SX1->X1_GRUPO))
	else
		::cGrpPerg := padr("BLTVTM",len(SX1->X1_GRUPO))
	endif

	::aCampos	  :={}
	::aDadosSel   :={}
	::aDadosEmp   :={}
	::aDadosTit   :={}
	::aDadosBanco :={}
	::aDadosSac   :={}
	::aFrases	  :={}
	::aPergs	  :={}     
	::cTamanho 	  :="M"
	::ctitulo  	  :="Impressao de Boleto com Codigo de Barras"
	::cDesc1   	  :="Este programa destina-se a impressao do Boleto Bancario com Codigo de Barras."
	::cDesc2   	  :="Será impresso somente os títulos transferidos para Cobrança Simples."
	::cDesc3   	  :=""
	::cAlias  	  :="SE1"
	::cCpoMark	  :="E1_OK"
	::wnrel    	  :="BOLETO" && Nome do Arquivo do Relatório
	::nModelo	  :=nModelo && Modelo de Layout do Boleto
	
	&& Tipo do Formulário, Margem, Destinatário, Formato de Impressão, Dispositivo, Driver, Filtro Usuário,    
	::areturn  	  :={"Zebrado", 1,"Administracao", 2, 2, 1, "",1 } 
	::nLastKey 	  :=0
	
	&& Define o logotipo do banco
	Do Case		
		Case ::cBanco == "001" && (Banco do Brasil)
			::aLogoBco	  := {"System\Bitmaps\LOGOBB.BMP"}
			::cDesc3	  := "Especifico para o Banco do Brasil."
		Case ::cBanco == "033" && (Santander)
			::aLogoBco	  := {"System\Bitmaps\LOGOSANT.BMP"}        
			::cDesc3	  := "Especifico para o Banco Santander."	
		Case ::cBanco == "104" && (Caixa Economica Federal)
			::aLogoBco	  := {"System\Bitmaps\LOGOCEF.BMP"}	 
			::cDesc3	  := "Especifico para o Banco Caixa Economica Federal."
		Case ::cBanco == "237" && (Bradesco)
			::aLogoBco	  := {"System\Bitmaps\LOGOBRA.BMP"}
			::cDesc3	  := "Especifico para o Banco Bradesco."
		Case ::cBanco == "422" && (Safra)
			::aLogoBco	  := {"System\Bitmaps\LOGOBRA.BMP"}
			::cDesc3	  := "Especifico para o Banco Bradesco."
		Case ::cBanco == "341" && (Itaú)
			::aLogoBco	  := {"System\Bitmaps\LOGOITAU.BMP"}
			::cDesc3	  := "Especifico para o Banco Itau."
		Case ::cBanco == "655" && (Votorantim)
			::aLogoBco	  := {"System\Bitmaps\LOGOITAU.BMP"} && {"System\Bitmaps\LOGOVT01.JPG"}
			::cDesc3	  := "Especifico para o Banco Itau." && "Especifico para o Banco Votorantim."
		Case ::cBanco == "409" && (Unibanco)
			::aLogoBco	  := {"System\Bitmaps\LOGOUNI.BMP"} 
			::cDesc3	  := "Especifico para o Banco Unibanco."										
	EndCase

	&& Inicializa a Classe TMSPrinter (Relatório Gráfico) e Define Propriedades Gerais
	::oReport:=TMSPrinter():new("Boleto Laser")
	::oReport:StartPage()     && Inicia uma nova página
	::oReport:SetPage(9) 	  && Define como Tamanho A4
	::oReport:SetPortrait()   && ou SetLandscape()
	::oReport:SetLoMetricMode() && Each logical unit is converted to 0.1 millimeter. Positive x is to the right; positive y is up.
		
	&& Abre a Tela do Assistente de Impressão, juntamente com a opção para seleção dos títulos
	::openReport()
return Self                                          

&& Abre o Assistente do Relatório, Executa o Seletor para Definir os Registros a Imprimir, 
&& Carrega os Dados para a Memória e Executa a Impressão
Method openReport() Class Boleto

	local lExec		 := .F.
	
	private areturn	 := ::areturn
	private nLastKey := ::nLastKey
	private cMarca   := GetMark()
	private lInverte := .T.
    
	&& Carrega as Perguntas
	::loadPergs()

	&& Cria a interface para impressão do relatório
	&& Desabilita os parâmetros se tiver sido passado um filtro específico do Título a ser impresso
	&& Sintaxe: SetPrint(<cAlias>,<cProgram>,[cPergunte],[cTitle],[cDesc1],[cDesc2],[cDesc3],[lDic],[aOrd],[lCompres],[cSize],[uParm12],[lFilter],[lCrystal],[cNameDr],[uParm16],[lServer],[cPortPrint])-->creturn
	&& dellano ::Wnrel := SetPrint(::cAlias,::Wnrel,Iif(::lFiltrado,"",::cGrpPerg),@::cTitulo,::cDesc1,::cDesc2,::cDesc3,.F.,,,::cTamanho,,)
	
	&& Se o usuário pressionar ESC ou Cancelar o Assistente de Impressão
	if nLastKey == 27
		Set Filter to && Limpa o Filtro
		return .T.    && Finaliza o Método
	endif
	
	&& Prepara o Ambiente de Impressão conforme de acordo com o Array areturn
	&& Sintaxe: Setdefault (<areturn>,<cAlias>,[uParm3],[uParm4],[cSize],[nFormat])
	&& dellano Setdefault(areturn,::cAlias,,,::cTamanho)
	
	&& Se o usuário pressionar ESC ou Cancelar o Assistente de Impressão
	if nLastKey == 27
		Set Filter to && Limpa o Filtro
		return .T.    && Finaliza o Método
	endif
	
	if ::lFiltrado && Se foi filtrado pelo usuário não apresenta a seleção de títulos e Imprime Direto o Título
		CursorWait() && Mostra Ampulheta
		
		&& Abre o Arquivo de Títulos a Receber e Filtra com utilizando o Filtro Passado na Instanciação do Objeto$		
		dbSelectArea(::cAlias) 
		dbSetOrder(1) && Ordem do Filtro: E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		dbSetFilter({|| .T. },::cFilter) && Filtro Precisa seguir a ordem 1 do SE1
		dbGoTop()		
				
		Processa({||::MontaRel()},"Imprimindo Boleto...") && Exibe a Régua de Processamento e Executa a Impresão do Relatório
		
		CursorArrow() && Libera Ampulheta	
	else	
		&& Carrega Informações dos Campos para a Listagem de Seleção dos Títulos com MarkBrowse
		aAdd(::aCampos,{"E1_OK      ",""})
		aAdd(::aCampos,{"E1_TIPO    ","Tipo","@!"})
		aAdd(::aCampos,{"E1_PREFIXO ","Prefixo","@!"})
	    aAdd(::aCampos,{"E1_NUM     ","Titulo","@!"})
		aAdd(::aCampos,{"E1_PARCELA ","Parcela","@!"})
		aAdd(::aCampos,{"E1_CLIENTE ","Cliente","@!"}) 
		aAdd(::aCampos,{"E1_LOJA    ","Loja","@!"})
		aAdd(::aCampos,{"E1_NOMCLI  ","Nome Cliente","@!"})
		aAdd(::aCampos,{"E1_NATUREZ ","Natureza","@!"}) 
		aAdd(::aCampos,{"E1_EMISSAO ","Emissao","@!"})
		aAdd(::aCampos,{"E1_VENCTO  ","Vencto","@!"})
		aAdd(::aCampos,{"E1_VALOR   ","Valor","@EZ 999,999,999.99"})
		aAdd(::aCampos,{"E1_SDACRES ","Acresc","@EZ 999,999,999.99"})
		aAdd(::aCampos,{"E1_SDDECRE ","Descont","@EZ 999,999,999.99"})
		aAdd(::aCampos,{"E1_SALDO   ","Saldo","@EZ 999,999,999.99"})
		aAdd(::aCampos,{"E1_PEDIDO  ","Pedido","@!"})
		aAdd(::aCampos,{"E1_NUMBCO  ","Nosso Nro","@!"})		
		
		&& Define os Detalhes do Índice e Filtro para Seleção dos Títulos
		&& Filtra somente os Títulos Transferidos para o Banco, Agência e Conta Informado nos Parâmetros
		::cIndexName	:= Criatrab(Nil,.F.) && Busca um arquivo válido para o índice temporário e retorna o nome do índice
		::cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_PARCELA+DTOS(E1_EMISSAO)" && Define o Índice de Ordenação
		::cFilter	:= "E1_FILIAL=='" + xFilial("SE1") + "' .And. E1_SALDO>0 .And. "
		::cFilter	+= "E1_PREFIXO>='" + MV_PAR01 + "' .And. E1_PREFIXO<='" + MV_PAR02 + "' .And. " 
		::cFilter	+= "E1_NUM>='" + MV_PAR03 + "' .And. E1_NUM<='" + MV_PAR04 + "' .And. "
		::cFilter	+= "E1_PARCELA>='" + MV_PAR05 + "' .And. E1_PARCELA<='" + MV_PAR06 + "' .And. "		
		::cFilter	+= "E1_TIPO = 'NF'  .And. "		
		::cFilter	+= "E1_CLIENTE>='" + MV_PAR07 + "' .And. E1_CLIENTE<='" + MV_PAR09 + "' .And. "
		::cFilter	+= "E1_LOJA>='" + MV_PAR08 +"' .And. E1_LOJA<='" + MV_PAR10 + "' .And. "
		::cFilter	+= "DTOS(E1_EMISSAO)>='" + DTOS(MV_PAR11) + "' .and. DTOS(E1_EMISSAO)<='" + DTOS(MV_PAR12) + "' .And. "
		::cFilter	+= "DTOS(E1_VENCREA)>='" + DTOS(MV_PAR13) + "' .and. DTOS(E1_VENCREA)<='" + DTOS(MV_PAR14) + "' "
		&& Filtro removido visto que, no caso da MB, devem ser levados os titulos que NAO foram para o CNAB
		&&::cFilter	+= " .And. E1_NUMBOR>='" + MV_PAR15 + "' .And. E1_NUMBOR<='" + MV_PAR16 + "' .And. "
		&&::cFilter	+= "E1_PORTADO=='" + MV_PAR17 + "' .And. "
		&&::cFilter	+= "E1_AGEDEP=='" + MV_PAR18 + "' .And. "
		&&::cFilter	+= "E1_CONTA=='" + MV_PAR19 + "'"
		
		&& Alimenta um indice Temporário de acordo com os parâmetros passados e filtra os dados
		MsgRun("Selecionando Registros. Por favor aguarde...",,{|| IndRegua("SE1", ::cIndexName, ::cIndexKey,, ::cFilter)})
		
		&& Abre o Arquivo de Títulos a Receber Filtrados
		dbSelectArea(::cAlias)
		#IFNDEF TOP && Se não for Top
			&& Agrega o índice ao Alias Ativo - OrdBagExt() - retorna a extensão do índice utilizado
			dbSetIndex(::cIndexName + OrdBagExt()) 
		#endif
		dbGoTop()
	
		&& Abre Caixa de Diálogo no Formato MarkBrowse para Seleção dos Títulos a Imprimir
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
		@ 001,001 TO 170,350 BROWSE ::cAlias FIELDS ::aCampos OBJECT oMark MARK ::cCpoMark
		oMark:oBrowse:lCanAllMark:=.T. && Indica se habilita(.T.)/desabilita(.F.) a opção de marcar todos os registros do browse.
		
		&& Define os Botões de Ação na Tela de Seleção dos Títulos
		TBUTTON():new(180,240,"Marcar/Desm.",oDlg,{|| oMark:oBrowse:AllMark()},35,11,,,,.T.) && Seleciona/Deseleciona Todos os Registros	
		@ 180,280 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg)) && Executar
		@ 180,310 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg)) && Cancelar
		
		ACTIVATE DIALOG oDlg CENTERED
	
		CursorWait() && Mostra Ampulheta
	
		if lExec && Se marcado para executar
			Processa({||::MontaRel()},"Imprimindo Boleto...") && Exibe a Régua de Processamento e Executa a Impresão do Relatório
		endif
		
		RetIndex(::cAlias) && Retorna a quantidade de índices ativos para um Alias aberto no sistema.
		Ferase(::cIndexName+OrdBagExt())	&& Apaga o Arquivo do Índice Temporário
		
		CursorArrow() && Libera Ampulheta	
	endif
return .T.

&& Cria ou Modifica o Grupo de Perguntas e o Carrega na Memória, tendo a opção de mostrar as perguntas
&& antes de abrir o assistente de impressão
Method loadPergs() Class Boleto
	
	&& Carrega o Grupo de Perguntas a ser gravado no SX1
	aAdd(::aPergs,{"De Prefixo"		,"","","mv_ch1","C",TamSx3("E1_PREFIXO")[1]		,0,0,"G","","MV_PAR01","","","",""									,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Prefixo"	,"","","mv_ch2","C",TamSx3("E1_PREFIXO")[1]		,0,0,"G","","MV_PAR02","","","",Repl("Z",TamSx3("E1_PREFIXO")[1])	,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Numero"		,"","","mv_ch3","C",TamSx3("E1_NUM")[1]			,0,0,"G","","MV_PAR03","","","",""									,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Numero"		,"","","mv_ch4","C",TamSx3("E1_NUM")[1]			,0,0,"G","","MV_PAR04","","","",Repl("Z",TamSx3("E1_NUM")[1])		,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Parcela"		,"","","mv_ch5","C",TamSx3("E1_PARCELA")[1]		,0,0,"G","","MV_PAR05","","","",""									,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Parcela"	,"","","mv_ch6","C",TamSx3("E1_PARCELA")[1]		,0,0,"G","","MV_PAR06","","","",Repl("Z",TamSx3("E1_PARCELA")[1])	,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Cliente"		,"","","mv_ch7","C",TamSx3("E1_CLIENTE")[1]		,0,0,"G","","MV_PAR07","","","",""									,"","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(::aPergs,{"De Loja"		,"","","mv_ch8","C",TamSx3("E1_LOJA")[1]		,0,0,"G","","MV_PAR08","","","",""									,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Cliente"	,"","","mv_ch9","C",TamSx3("E1_CLIENTE")[1]		,0,0,"G","","MV_PAR09","","","",Repl("Z",TamSx3("E1_CLIENTE")[1])	,"","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(::aPergs,{"Ate Loja"		,"","","mv_cha","C",TamSx3("E1_LOJA")[1]		,0,0,"G","","MV_PAR10","","","",Repl("Z",TamSx3("E1_LOJA")[1])		,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Emissao"		,"","","mv_chb","D",8							,0,0,"G","","MV_PAR11","","","","01/01/80"							,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Emissao"	,"","","mv_chc","D",8							,0,0,"G","","MV_PAR12","","","","31/12/19"							,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"De Vencimento"	,"","","mv_chd","D",8							,0,0,"G","","MV_PAR13","","","","01/01/80"							,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Vencimento"	,"","","mv_che","D",8							,0,0,"G","","MV_PAR14","","","","31/12/19"							,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Do Bordero"		,"","","mv_chf","C",TamSx3("E1_NUMBOR")[1]		,0,0,"G","","MV_PAR15","","","",""									,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Ate Bordero"	,"","","mv_chg","C",TamSx3("E1_NUMBOR")[1]		,0,0,"G","","MV_PAR16","","","",Repl("Z",TamSx3("E1_NUMBOR")[1])	,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Banco"			,"","","mv_chi","C",TamSx3("E1_PORTADO")[1]  	,0,0,"S","","MV_PAR17","","","","001"								,"","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	aAdd(::aPergs,{"Agencia"		,"","","mv_chj","C",TamSx3("E1_AGEDEP")[1]		,0,0,"S","","MV_PAR18","","","","33626"								,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"C/C"			,"","","mv_chk","C",TamSx3("E1_CONTA")[1]		,0,0,"S","","MV_PAR19","","","","80677-3"							,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Sub-Conta"		,"","","mv_chl","C",TamSx3("EE_SUBCTA")[1]		,0,0,"S","","MV_PAR20","","","","003"                            	,"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(::aPergs,{"Mensagem 1"		,"","","mv_chm","C",99							,0,0,"G","","MV_PAR21","","","",""									,"","","","","","","","","","","","","","","","","","","","","ZZBL","","","",""})
	aAdd(::aPergs,{"Mensagem 2"		,"","","mv_chn","C",99							,0,0,"G","","MV_PAR22","","","",""									,"","","","","","","","","","","","","","","","","","","","","ZZBL","","","",""})
	aAdd(::aPergs,{"Mensagem 3"		,"","","mv_cho","C",99							,0,0,"G","","MV_PAR23","","","",""									,"","","","","","","","","","","","","","","","","","","","","ZZBL","","","",""})

	&& Cria ou Modifica o Grupo de Perguntas
	AjustaSx1(::cGrpPerg,::aPergs)
	
	&& Carrega o Grupo de Perguntas para as Variáveis de Memória e não apresenta em Tela
	if ::lFiltrado && Se filtrado somente carrega as variáveis mas não apresenta em tela
		Pergunte (::cGrpPerg,.F.)
	else
		Pergunte (::cGrpPerg,::lMostraPrg)
	endif                
	
return

&& Carrega os Dados a Imprimir para a Memória em Arrays e Executa a Impressão o Relatório
Method montaRel() Class Boleto

	Local nTit	:= 0
	Local nItens:= 0
	Local nPos  := 0
	Local nCont := 0
	Local nTaxa := 0
	Local xcR	:= 	Char(13) + Char(10)
         
	&& Carrega Dados da Empresa
	aAdd(::aDadosEmp,SM0->M0_NOMECOM) 																&& [1]Nome da Empresa
	aAdd(::aDadosEmp,SM0->M0_ENDCOB) 																&& [2]Endereço
	aAdd(::aDadosEmp,alltrim(SM0->M0_BAIRCOB)+", "+alltrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB) 	&& [3]Complemento
	aAdd(::aDadosEmp,"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)) 				&& [4]CEP
	aAdd(::aDadosEmp,"PABX/FAX: "+SM0->M0_TEL) 													&& [5]Telefones
	aAdd(::aDadosEmp,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))  					&& [6]CNPJ
	aAdd(::aDadosEmp,"I.E.: "+Transform(SM0->M0_INSC,"@R 999.999.999.999")) 						&& [7]I.E

	dbGoTop()
	ProcRegua(SE1->(RecCount())) && Define o Tamanho Máximo da Régua de Processamento	

	Do While SE1->(!EOF()) && Percorre o Arquivo do SE1 Ativo que está filtrado	
	
	
		IncProc()  && Incrementa a Régua de Processamento
		nItens+= 1 && Contabiliza Itens a Percorrer
		
		if !Marked("E1_OK")
			SE1->(dbSkip())
			Loop
		endif
       
	    SA1->(dbSetOrder(1))
		SA1->(dbSeek( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA  ))	    
		
		If (SA1->A1_BCO1 $ "CXC CX1")
			MsgInfo("Banco do Cliente é :" + SA1->A1_BCO1 + xcR + " O Boleto não será Impresso!!!!")
		   	SE1->(dbSkip())
			Loop
		Endif
       	
       	If !Empty(SE1->E1_NUMBCO)
       		If MsgYesNo("Reimpressão do Título no. "+Alltrim(SE1->E1_NUM)+" Parc. "+Alltrim(SE1->E1_PARCELA)+"?")

       			If !(Upper(Alltrim(cUsername)) $ Upper(Alltrim(GetMv("ZZ_USERBOL"))))
		
		    		SE1->(dbSkip())
					Loop       				
       			Endif  
       		Else                                         
       		
				SE1->(dbSkip())
				Loop
       		Endif
       	Endif
        
        &&&&&&& 1a. Regra: FOB com Redespacho é sempre boleto impresso pelo Banco:    
		SD2->(dbSetOrder(3))
		If SD2->(dbSeek( xFilial("SD2") + SE1->E1_NUM + SE1->E1_PREFIXO + SE1->E1_CLIENTE + SE1->E1_LOJA ))
			SC5->(dbSetOrder(1))
			If SC5->(dbSeek( xFilial("SC5") + SD2->D2_PEDIDO ))				
				If SC5->C5_TPFRETE == "F" .and. !Empty(SC5->C5_REDESP) .AND. !(SC5->C5_ZZTPOPE $ GETMV('MB_TPOPERA'))
		    		Alert('1a. Regra: FOB com Redespacho é sempre boleto impresso pelo Banco' + Char(13) + Char(10) + 'Pedido: ' + SD2->D2_PEDIDO + Char(13) + Char(10) + 'Tipo de Frete: ' + SC5->C5_TPFRETE + Char(13) + Char(10) + 'Redespacho: ' + SC5->C5_REDESP ,'ALERTA MB')
		    		SE1->(dbSkip())
					Loop				
				Endif
			Endif
		Endif

		&&&&&&& 2a. Regra: Verifica se cobra taxa do cliente, se cobrar busca valor no parâmetro ZZ_TXBOL:    
		nTaxa := 0		
	    SA1->(dbSetOrder(1))
	    If SA1->(dbSeek( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA  ))	    
	    	
//	    	If SA1->A1_ZZTPBOL == "1"	&& 1=Banco;2=MB   Fazer um filtro de duplicatas usando esses campo abaixo victor 12/01/12
	    	If SA1->A1_ZZTPBOL == "1"	.and. SC5->C5_ZZTPBOL == "1"
	    		MsgInfo("O Boleto referente ao titulo: "+Alltrim(SE1->E1_NUM)+" Parc. "+Alltrim(SE1->E1_PARCELA)+" nao sera gerado! Tipo do boleto no cadastro do cliente e no pedido igual a Banco!")
	    		SE1->(dbSkip())
				Loop
			ElseIf (SA1->A1_ZZTPBOL == "1"	.and. SC5->C5_ZZTPBOL == "2") .or. (SA1->A1_ZZTPBOL == "2"	.and. SC5->C5_ZZTPBOL == "1")
				If !MsgYesNo("Cadastro de Cliente x Pedido de Venda divergente!"+CRLF+"Deseja imprimir Boleto para "+Alltrim(SE1->E1_NUM)+" Parc. "+Alltrim(SE1->E1_PARCELA)+"?")
		    		SE1->(dbSkip())
					Loop
				Endif
	    	Endif
	    
		    If SA1->A1_ZZTXBOL == "1"
				nTaxa := GetMv("ZZ_TXBOL")
			Endif
		Endif			
		
		&& dellano if IsMark(::cCpoMark,cMarca,lInverte) .Or. ::lFiltrado
			&& Posiciona o SA6 (Bancos)
			dbSelectArea("SA6")
			dbSetOrder(1)
			&&dbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)
			dbSeek(xFilial("SA6")+mv_par17+mv_par18+mv_par19,.T.)

			&& Posiciona na Arq de Parâmetros do Banco / CNAB
			dbSelectArea("SEE")
			dbSetOrder(1)
			&&dbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)+M->MV_PAR20,.T.)
			dbSeek(xFilial("SEE")+mv_par17+mv_par18+mv_par19+MV_PAR20,.T.)

			&& Posiciona o SA1 (Cliente)
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
						
			&& Carrega os Dados do Banco
			::aDadosBanco := {}
			aAdd(::aDadosBanco,SA6->A6_COD)													&& [1]Numero do Banco
			aAdd(::aDadosBanco,SA6->A6_NREDUZ)												&& [2]Nome do Banco
			aAdd(::aDadosBanco,subStr(SA6->A6_AGENCIA, 1, 5))								&& [3]Agência
			aAdd(::aDadosBanco,subStr(SA6->A6_NUMCON,1,Len(alltrim(SA6->A6_NUMCON))-2)) 	&& [4]Conta Corrente
			aAdd(::aDadosBanco,subStr(SA6->A6_NUMCON,Len(alltrim(SA6->A6_NUMCON)),1))		&& [5]Dígito da conta corrente
			aAdd(::aDadosBanco,"17-019") 													&& [6]Codigo da Carteira Completo
			aAdd(::aDadosBanco,alltrim(SEE->EE_ZZCART))										&& [7]Carteira - Campo Pers. no SEE
			aAdd(::aDadosBanco,alltrim(SEE->EE_CODEMP)) 									&& [8]Convênio do Banco
			aAdd(::aDadosBanco,Len(alltrim(SEE->EE_CODEMP))) 								&& [9]Nº de Dígitos do Convênio do Banco
			aAdd(::aDadosBanco,SEE->EE_FAXATU) 												&& [10]Nº Seq. Interno para Uso com o Boleto
			aAdd(::aDadosBanco,"")
			
			&& Carrega os Dados do Cliente
			::aDadosSac:={}
			if Empty(SA1->A1_ENDCOB)
				aAdd(::aDadosSac,alltrim(SA1->A1_NOME))   		    		            && [1]Razão Social
				aAdd(::aDadosSac,alltrim(SA1->A1_COD)+"-"+SA1->A1_LOJA)		    		&& [2]Código
				aAdd(::aDadosSac,alltrim(SA1->A1_END)+"-"+alltrim(SA1->A1_BAIRRO)) 		&& [3]Endereço
				aAdd(::aDadosSac,alltrim(SA1->A1_MUN))							    	&& [4]Cidade
				aAdd(::aDadosSac,SA1->A1_EST)											&& [5]Estado
				aAdd(::aDadosSac,SA1->A1_CEP) 											&& [6]CEP
				aAdd(::aDadosSac,SA1->A1_CGC) 									    	&& [7]CNPJ
				aAdd(::aDadosSac,SA1->A1_PESSOA)								    	&& [8]PESSOA	
			else
				aAdd(::aDadosSac,alltrim(SA1->A1_NOME))		    		                && [1]Razão Social
				aAdd(::aDadosSac,alltrim(SA1->A1_COD)+"-"+SA1->A1_LOJA)		    		&& [2]Código
				aAdd(::aDadosSac,alltrim(SA1->A1_ENDCOB)+"-"+alltrim(SA1->A1_BAIRROC)) 	&& [3]Endereço
				aAdd(::aDadosSac,alltrim(SA1->A1_MUNC))							    	&& [4]Cidade
				aAdd(::aDadosSac,SA1->A1_ESTC)											&& [5]Estado
				aAdd(::aDadosSac,SA1->A1_CEPC) 											&& [6]CEP
				aAdd(::aDadosSac,SA1->A1_CGC) 									    	&& [7]CNPJ
				aAdd(::aDadosSac,SA1->A1_PESSOA)								    	&& [8]PESSOA	
			endif
			                  
			&& Carrega os Dados do Título
			::aDadosTit:={}
			aAdd(::aDadosTit,alltrim(SE1->E1_NUM)+alltrim(SE1->E1_PARCELA))				&& [1] Número do título
			aAdd(::aDadosTit,SE1->E1_EMISSAO)											&& [2] Data da emissão do título
			aAdd(::aDadosTit,dDataBase)													&& [3] Data da emissão do boleto
			aAdd(::aDadosTit,SE1->E1_VENCTO)                 							&& [4] Data do vencimento
			aAdd(::aDadosTit,((SE1->E1_SALDO + nTaxa) - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)))&& [5] Valor do título
			aAdd(::aDadosTit,SE1->E1_PREFIXO )     										&& [6] Prefixo do Título
			aAdd(::aDadosTit,"DM")	      												&& [7] Tipo do Titulo Espécie de Docto Padrao (DM=DUPLICATA MERCANTIL, DS=DUPLICATA DE SERVIÇO, RC=RECIBO)
            
		 	&& Carrega as Frases Padrões
		 	::aFrases := {}       
/*
	 		aAdd(::aFrases,MV_PAR21)
	 		aAdd(::aFrases,MV_PAR22)
	 		aAdd(::aFrases,MV_PAR23)		 	
*/

	 		aAdd(::aFrases,'Juros de R$ '+AllTrim(Transform(Round(((SE1->E1_SALDO + nTaxa) - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)) * GetMV('MB_TXJUROS'),2),"999,999,999.99")) + ' ao dia')
	 		aAdd(::aFrases,'Multa de R$ '+AllTrim(Transform(Round(((SE1->E1_SALDO + nTaxa) - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)) * GetMV('MB_TXMULTA'),2),"999,999,999.99")) + ' após vencimento')
	 		aAdd(::aFrases,'Protesto após (05 DIAS) do vencimento')		 	

	 		aAdd(::aFrases,"PARCELA Nº " + SE1->E1_PARCELA )		 	
		 	/*
		 	if ::cBanco == "001"
		 		aAdd(::aFrases,"Juros de Mora de 4,00% ao mês")
		 		aAdd(::aFrases,"")
		 		aAdd(::aFrases,"")
		 	elseif ::cBanco == "655"
		 		aAdd(::aFrases,"Titulo entregue em cessão fiduciária em favor do cedente acima") && MV_PAR23)
				aAdd(::aFrases,"Juros de Mora de 3,00% ao mês") && MV_PAR22)
				aAdd(::aFrases,"") && MV_PAR23)
			elseif ::cBanco == "422"
		 		aAdd(::aFrases,"")
		 		aAdd(::aFrases,"")
		 		aAdd(::aFrases,"")
			endif*/
 
			&& Substitui o conteúdo de %E1_PORCJUR% nas Frases com Valores do Título
			if SE1->E1_PORCJUR > 0
				::aFrases[1]:= STRTRAN(::aFrases[1],"%E1_PORCJUR%",alltrim(Transform((::aDadosTit[5]*SE1->E1_PORCJUR/100),"@E 99,999.9999"))+" ( "+cValToChar(SE1->E1_PORCJUR)+"% )")
				::aFrases[2]:= STRTRAN(::aFrases[2],"%E1_PORCJUR%",alltrim(Transform((::aDadosTit[5]*SE1->E1_PORCJUR/100),"@E 99,999.9999"))+" ( "+cValToChar(SE1->E1_PORCJUR)+"% )")
				::aFrases[3]:= STRTRAN(::aFrases[3],"%E1_PORCJUR%",alltrim(Transform((::aDadosTit[5]*SE1->E1_PORCJUR/100),"@E 99,999.9999"))+" ( "+cValToChar(SE1->E1_PORCJUR)+"% )")
			else
				For nCont:=1 to 3 && Para as 3 mensagens
					nPos:= aScan(::aFrases,{|cTexto| "%E1_PORCJUR%" $ cTexto })
					if nPos>0
						::aFrases[nPos]:="" && Limpa a Frase Inteira caso o conteúdo do campo seja vazio
					endif
				Next nCont
			endif
				
			&& Substitui o conteúdo de %E1_VALJUR% nas Frases com Valores do Título
			if SE1->E1_VALJUR > 0
				::aFrases[1]:= STRTRAN(::aFrases[1],"%E1_VALJUR%",alltrim(Transform(SE1->E1_VALJUR,"@E 99,999.99")))
				::aFrases[2]:= STRTRAN(::aFrases[2],"%E1_VALJUR%",alltrim(Transform(SE1->E1_VALJUR,"@E 99,999.99")))
				::aFrases[3]:= STRTRAN(::aFrases[3],"%E1_VALJUR%",alltrim(Transform(SE1->E1_VALJUR,"@E 99,999.99")))
			else
				For nCont:=1 to 3 && Para as 3 mensagens
					nPos:= aScan(::aFrases,{|cTexto| "%E1_VALJUR%" $ cTexto })
					if nPos>0
						::aFrases[nPos]:="" && Limpa a Frase Inteira caso o conteúdo do campo seja vazio
					endif
				Next nCont
			endif
	
			&& Substitui o conteúdo de %E1_DESCFIN% nas Frases com Valores do Título
			if SE1->E1_DESCFIN > 0
				::aFrases[1]:= STRTRAN(::aFrases[1],"%E1_DESCFIN%",alltrim(Transform(SE1->E1_DESCFIN,"@E 99,999.99")))
				::aFrases[2]:= STRTRAN(::aFrases[2],"%E1_DESCFIN%",alltrim(Transform(SE1->E1_DESCFIN,"@E 99,999.99")))
				::aFrases[3]:= STRTRAN(::aFrases[3],"%E1_DESCFIN%",alltrim(Transform(SE1->E1_DESCFIN,"@E 99,999.99")))
			else
				For nCont:=1 to 3 && Para as 3 mensagens
					nPos:= aScan(::aFrases,{|cTexto| cTexto $ "%E1_DESCFIN%"})
					if nPos>0
						::aFrases[nPos]:="" && Limpa a Frase Inteira caso o conteúdo do campo seja vazio
					endif
				Next nCont
			endif
	  
			&& Calcula a data limite para protesto e substitui a clausula %cDt% nas mensagens do título
			::SomaUtil(SE1->E1_VENCREA,3)
			If !Empty(::aFrases)
				::aFrases[1]:= STRTRAN(::aFrases[1],"%cDt%",dToc(::cProtesto))
				::aFrases[2]:= STRTRAN(::aFrases[2],"%cDt%",dToc(::cProtesto))
				::aFrases[3]:= STRTRAN(::aFrases[3],"%cDt%",dToc(::cProtesto))
			EndIf

			&& Define o Código do Nosso Número
			::NossoNro(SE1->E1_NUMBCO) 
			
			&& Define o Código de Barras e a Linha Digitável
			::CodBarra()
			
			&& Imprime o Relatório para os Dados Atualmente Selecionados
			::PrintRel() 
			
			nTit+= 1 && Contabiliza títulos impressos
		&& dellano endif
		SE1->(dbSkip()) && Pula o Registro SE1 Filtrado
	EndDo
	
	if nTit>0  && Apresenta apenas se houver registros a serem impressos
		::oReport:EndPage()     && Finaliza a página
		::oReport:Setup()       && Apresenta o Seletor para Escolha da Impressora a Utilizar na Impressão
		::oReport:Preview()     && Visualiza antes de imprimir	
	endif
return

&& #########################################################################
&& MÉTODOS PARA CÁLCULO DO NOSSO NÚMERO, DO CÓDIGO DE BARRA E LINHA DIGITÁVEL 
&& #########################################################################

&& Define o Nosso Número de Acordo com o Banco, Carteira e Convênio, utilizando o Código Seq. como parte do Nosso Número
&& Alimenta o Atributo NossoNum e Retorna o valor do Atributo
Method nossoNro(cNossNroOld) Class Boleto

	local cBase		:= "" 
	local cDV		:= ""                   
	local cNossoNro	:= ""
	
	local cBanco	:= alltrim(::aDadosBanco[1])
	local cAgencia	:= alltrim(::aDadosBanco[3])
	local cConta	:= alltrim(::aDadosBanco[4]) && Sem Dígito Verificador (DAC)
	local cCarteira := alltrim(::aDadosBanco[7])
	local cConvenio	:= alltrim(::aDadosBanco[8])
	local nDigConv	:= ::aDadosBanco[9]
	local cCodSeq	:= alltrim(::aDadosBanco[10])
	
	&& cNossNroOld := "" && Dellano - Força o calculo
	
	if !Empty(cNossNroOld)
		cNossoNro:= cNossNroOld
	else		
		&& Banco do Brasil
		if cBanco == "001" 
			if cCarteira == "18" && Cobrança Simples - Boleto Impresso na Empresa
			
				cBase	   := alltrim(cConvenio)+alltrim(cCodSeq) && Convênio + Nº Seq.
				
				if nDigConv == 4 && Dígitos do Convênio de 4 Dígitos
					&& Convenio deve ter 4 Dígitos e Nº Seq. 7 Dígitos = 11 Dígitos
					cDV	   := U_Modulo11(cBase,9,2,cBanco) && 12 Dígitos no Total com Dígito Verif.					
				elseif nDigConv == 6 && Dígitos do Convênio de 6 Dígitos
					&& Convenio deve ter 6 Dígitos e Nº Seq. 5 Dígitos = 11 Dígitos
					cDV	   := U_Modulo11(cBase,9,2,cBanco) && 12 Dígitos no Total com Dígito Verif.
				elseif nDigConv == 7 && Convênio de 7 Dígitos
					&& Convenio deve ter 7 Dígitos e Nº Seq. 10 Dígitos  = 17 Dígitos
					cDV	   := "" && 17 Dígitos no Total Sem DV
				else
					cDV	   := "" && Sem DV
				endif

				cNossoNro  := cBase + cDV && Grava o Nosso Número Completo
					
				&& Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
				GrvNumSeq(Soma1(alltrim(cCodSeq)))
				
			elseif cCarteira == "17"

				if nDigConv == 7
					cBase := alltrim(cConvenio)+right(alltrim(cCodSeq),10) && Convênio + Nº Seq.
					cDV	  := ""
				elseif nDigConv == 6 && Dígitos do Convênio de 6 Dígitos
					&& Convenio deve ter 6 Dígitos e Nº Seq. 5 Dígitos = 11 Dígitos
					cBase := alltrim(cConvenio)+right(alltrim(cCodSeq),5) && Convênio + Nº Seq.
					cDV	  := U_Modulo11(cBase,9,2,cBanco) && 12 Dígitos no Total com Dígito Verif.
				endif
				
				cNossoNro  := cBase + cDV && Grava o Nosso Número Completo

				&& Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
				GrvNumSeq(Soma1(alltrim(cCodSeq)))
				
		    elseif cCarteira == "11" && Boleto Impresso no Banco, bem como geração do Nosso Número.
		    
		    	cNossoNro := "00000000000000000"
		    endif

		&& Caixa Econômica Federal
		elseif cBanco == "104"
			if cCarteira == "12" && Cobrança Simples - Boleto Impresso na Empresa
				cBase	  := "9"+subStr(cCodSeq,4,9)
				cDV		  := U_Modulo11(cBase,7,2,cBanco)
				cNossoNro := cBase + cDV
				
				&& Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
				GrvNumSeq(strZero(val(cCodSeq)+1,12))
							
			elseif cCarteira == "14" && Cobrança sem Registro - Boleto Impresso na Empresa
				cBase	  := "82"+subStr(cCodSeq,5,8)
				cDV		  := U_Modulo11(cBase,7,2,cBanco)
				cNossoNro := cBase + cDV
				
				&& Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
				GrvNumSeq(strZero(val(cCodSeq)+1,12))
		    endif
		
		&& Bradesco ou Safra
		elseif cBanco == "237" .or. cBanco == "422"
			if cCarteira == "19" && Cobrança sem Registro
				cBase	  := alltrim(cCodSeq) && 11 Dígitos Sequenciais
				cDV	   	  := U_Modulo11(cCarteira+cBase,2,7,cBanco) && 12 Dígitos no Total com Dígito Verif. - Modulo 11 sobre Carteira + Nosso Nro
				cNossoNro := cBase + cDV && Grava o Nosso Número Completo				

			elseif cCarteira == "09"
				cBase	  := subStr(dtos(SE1->E1_EMISSAO),3,2) +alltrim(cCodSeq)
				cDV	   	  := U_Modulo11(cCarteira+cBase,2,7,"422")
				cNossoNro := cCarteira + cBase + cDV
				cDV	   	  := U_Modulo11(cNossoNro,2,7,"237")
				cNossoNro := cNossoNro + cDV
			endif
			
			&& Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco
			GrvNumSeq(Soma1(alltrim(cCodSeq)))
			
		&& Banco Itaú ou Votorantim
		elseif cBanco == "341" .or. cBanco == "655"
			cBase	  := cCarteira+alltrim(cCodSeq) && 3 Dígitos da Carteira + 8 Dígitos Sequenciais = 11 Dígitos
			
			if cCarteira == "126" .Or. cCarteira == "131" .Or. cCarteira == "145" .Or. ;
				cCarteira == "150" .Or. cCarteira == "168" && Carteiras Escriturais e na Modalidade Direta
				
				cDV:= U_Modulo10(cBase,2,1,"Divisor") && 12 Dígitos no Total com Dígito Verif. - Somente Carteira e Num. Seq.
			else				  
				cDV:= U_Modulo10(cAgencia+cConta+cBase,2,1,"Divisor") && 12 Dígitos no Total com Dígito Verif. - Agencia+CC sem DAC+Carteira+Num. Seq
			endif			
			cNossoNro := cBase + cDV && Grava o Nosso Número Completo							
			
			&& Atualiza o Numero Sequencial do Cadastro de Parâmetros Banco			
			GrvNumSeq(Soma1(alltrim(cCodSeq)))
		endif		
	endif
	
	&& Grava o Último Nº Gerado como Atributo para Uso Posterior
	If !Empty(Alltrim(cNossoNro))
		::cNossoNum:= Alltrim(cNossoNro)
	Else
		::cNossoNum:= ::RetNossoNro()		
	Endif	
	
    && Armazena o Nosso Número no Arquivo
    ::GrvNossNum()
          
return (::cNossoNum)

&& Grava o Número Sequencial no Arquivo de Configurações do Banco/CNAB
Static Function GrvNumSeq(cCodSeq)
	dbSelectArea("SEE")
	RecLock("SEE")
		SEE->EE_FAXATU:= cCodSeq
	MsUnLock()		
return

&& Grava o Nosso Número e que o Boleto foi impresso na Base no SE1 Posicionado
Method grvNossNum() Class Boleto
	&& Armazena o nosso Número Gerado no SE1
	dbSelectArea("SE1")
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO := ::cNossoNum
	SE1->E1_ZZBLT := .T. && Indica que o Boleto foi impresso - Campo Personalizado
	MsUnlock()
return

&& Retorna o Nosso Número Formatado, Conforme o Banco e Convênio
Method retNossoNro() Class Boleto

	local cBanco	:= ::aDadosBanco[1]
	local nDigConv	:= ::aDadosBanco[9]
	local cNossoNro := ::cNossoNum
  
	 && Banco do Brasil
	if cBanco == "001" .and. Empty(cNossoNro)
		if nDigConv == 6 && Dígitos do Convênio de 6 Dígitos
			cNossoNro:= left(cNossoNro,Len(cNossoNro)-1) + "-" + Right(cNossoNro,1)
		elseif nDigConv == 7 && Dígitos do Convênio de 7 Dígitos
			cNossoNro:= cNossoNro
		else
			cNossoNro:= cNossoNro
	  	endif
 	
 	&& Bradesco
	elseif cBanco == "237" .and. Empty(cNossoNro)
		cNossoNro:= left(cNossoNro,Len(cNossoNro)-1) + "-" + Right(cNossoNro,1)
		
 	&& Safra
	elseif cBanco == "422" .and. Empty(cNossoNro)
		cNossoNro:= left(cNossoNro,4) + "/" + subStr(cNossoNro,5,Len(allTrim(cNossoNro))-5) + "-" + Right(cNossoNro,1)

	&& Banco Itaú ou Votorantim
	elseif (cBanco == "341" .or. cBanco == "655") .and. Empty(cNossoNro)
		cNossoNro:= left(cNossoNro,3) + "/" + subStr(cNossoNro,4,Len(cNossoNro)-4) + "-" + Right(cNossoNro,1)	
		
	else 
		cNossoNro:= cNossoNro
	endif
	
return (cNossoNro)

&& Define o Código de Barras e a Linha Digitável do Boleto
Method CodBarra() Class Boleto   

	local cBanco	  := ::aDadosBanco[1]
	local cAgencia    := ::aDadosBanco[3]
	local cConta      := ::aDadosBanco[4] && Sem DAC
	local cCarteira   := ::aDadosBanco[7]
	local cConvenio	  := ::aDadosBanco[8]
	local nDigConv	  := ::aDadosBanco[9]
	local cCodSeq	  := ::aDadosBanco[10]
	local cVencto	  := DTOS(::aDadosTit[4]) && Converte para AAAAMMDD
	local cMoeda	  := "9" && Código da Moeda no Banco - 9 = Real
	local cNNumSemDV  := "" 
	local cCampoLivre := ""
	local cFator	  := ""
	local cDigBarra	  := ""
	local cParte1	  := ""
	local cDig1		  := ""
	local cParte2	  := ""
	local cDig2		  := ""
	local cParte3	  := ""
	local cDig3		  := ""
	local cParte4	  := ""
	local cParte5	  := ""
	
    && Ajusta a Agencia para 4 Dígitos
	cAgencia:=left(cAgencia,4)
		
	&& Define o Nosso Número sem DV e Parte do Campo Livre
	&& Variável para Cada Banco e cada Tipo de Convênio
	if cBanco == "001" && Banco do Brasil
		if nDigConv == 4 && Dígitos do Convênio de 4 Dígitos (Com DV)
			cNNumSemDV  := left(::cNossoNum,11)
			cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira	&& 11 + 4 + 8 + 2 = 25
			
		elseif nDigConv == 6 && Dígitos do Convênio de 6 Dígitos (Com DV)
			cNNumSemDV  := left(::cNossoNum,11)
			cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira && 11 + 4 + 8 + 2 = 25
		
		elseif nDigConv == 7 && Dígitos do Convênio de 7 Dígitos (Sem DV) - Faixa Acima de 1.000.000 - Somente para Carteiras 16 e 18
			cNNumSemDV  := ::cNossoNum
			cCampoLivre := "000000"+cNNumSemDV+"21" && 6 + 17 + 2 = 25 
		
		else
			cNNumSemDV:= ::cNossoNum
			cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira && 11 + 4 + 8 + 2 = 25
		endif

	&& Banco Bradesco
	elseif cBanco == "237"
		cNNumSemDV  := left(::cNossoNum,11)
		cCampoLivre := cAgencia+cCarteira+cNNumSemDV+strZero(val(cConta),7)+"0" && 4 + 2 + 11 + 7 + 1 = 25
	
	&& Banco Safra
	elseif cBanco == "422"
		cNNumSemDV  := left(::cNossoNum,13)
		cCampoLivre := cAgencia+cNNumSemDV+strZero(val(cConta),7) +"0" && 4 + 2 + 11 + 7 + 1 = 25		
		
	&& Banco Itaú ou Votorantim
	elseif cBanco == "341" .or. cBanco == "655"
		cNNumSemDV  := left(::cNossoNum,11)
		cCampoLivre := cNNumSemDV+Right(::cNossoNum,1)+cAgencia+strZero(val(cConta),5)+U_Modulo10(cAgencia+cConta,2,1,"Divisor")+"000"	&& 11 + 1 + 4 + 5 + 1 + 3 = 25	
	
	else && Para outros Bancos - Estudar as Especificações de Outros Bancos
		cNNumSemDV:= ::cNossoNum
		cCampoLivre := cNNumSemDV+cAgencia+strZero(val(cConta),8)+cCarteira && 11 + 4 + 8 + 2 = 25 
	endif
	
	&& Define o Fator de Vencimento com o Valor do Título
	
	&& Banco do Brasil
	if cBanco == "001"
		&& Regra: Deduzir do Vencto a Data Base de 03/07/2000 e Acrescer a 1000
		cFator := Str(1000+(STOD(cVencto)-STOD("20000703")),4) && Fator = 4 Dígitos
		cFator += strZero(::aDadosTit[5]*100,10) && Valor = 10 Dígitos
	
	&& Bradesco ou Safra
	elseif cBanco == "237" .or. cBanco == "422"
		&& Regra: Deduzir do Vencto a Data Base de 07/10/1997 e Acrescer a 1000
		cFator := strZero(STOD(cVencto)-STOD("19971007"),4) && Fator = 4 Dígitos
		cFator += strZero(::aDadosTit[5]*100,10) && Valor = 10 Dígitos		
	
	&& Outros Bancos
	else
		&& Regra: Deduzir do Vencto a Data Base de 03/07/2000 e Acrescer a 1000
		cFator := Str(1000+(STOD(cVencto)-STOD("20000703")),4) && Fator = 4 Dígitos
		cFator += strZero(::aDadosTit[5]*100,10) && Valor = 10 Dígitos	
	endif
		
	&& Define o Campo Livre
	if cBanco == "655"
		cCampoLivre := "341"+cMoeda+cFator+cCampoLivre
	elseif cBanco == "422"
		cCampoLivre := "237"+cMoeda+cFator+cCampoLivre
	else
		cCampoLivre := cBanco+cMoeda+cFator+cCampoLivre
	endif
	
 	&& Dígito Verificador do Campo Livre
	cDigBarra   := U_Modulo11(cCampoLivre,2,9,cBanco,2)

	&& Composição Final do Código de Barra
	::cCodBarra := subStr(cCampoLivre,1,4)+cDigBarra+subStr(cCampoLivre,5,Len(cCampoLivre))		                                      

	&& Composição da Linha Digitável
	if cBanco == "655"
		cParte1 := "341"
	elseif cBanco == "422"
		cParte1 := "237"
	else
		cParte1 := cBanco
	endif
	
	cParte1  := cParte1 + cMoeda
	cParte1  := cParte1 + subStr(::cCodBarra,20,5) && Posição 20 a 24 do Cód. de Barras
	cDig1    := U_Modulo10(cParte1,2,1) && Modulo10, alternando com bases de 2 e 1 - DAC
	cParte2  := subStr(::cCodBarra,25,10) && Posição 25 a 34 do Cód. de Barras
	cDig2    := U_Modulo10(cParte2,2,1) && Modulo10, alternando com bases de 2 e 1 - DAC
	cParte3  := subStr(::cCodBarra,35,10) && Posição 35 a 44 do Cód. de Barras
	cDig3    := U_Modulo10(cParte3,2,1) && Modulo10, alternando com bases de 2 e 1 - DAC
	cParte4  := cDigBarra && DV do Cód. de Barra Em Modulo11 Calculado Previamente
	cParte5  := cFator && Fator de Vencto + Valor
	
	&& Montagem Final da Linha Digitável
	::cLinhaDig := 	subStr(cParte1,1,5)+"."+subStr(cparte1,6,4)+cDig1+" "+;
					subStr(cParte2,1,5)+"."+subStr(cparte2,6,5)+cDig2+" "+;
					subStr(cParte3,1,5)+"."+subStr(cparte3,6,5)+cDig3+" "+;
					cParte4+" "+;
					cParte5
	
return

&& Executa a Impressão do Relatório Gráfico
Method printRel() Class Boleto

	&& DEFINE OS ESTILOS DE FONTES A SEREM UTILIZADOS - O Nº NA VARIÁVEL IDENTIFICA O TAMANHO DA FONTE
	&& Parametros de TFont.New(): 1.Nome da Fonte (Windows), 3.Tamanho em Pixels, 5.Bold (T/F)
	local oFont8   :=TFont():new("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	local oFont10  :=TFont():new("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont11c :=TFont():new("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont11  :=TFont():new("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont14  :=TFont():new("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont20  :=TFont():new("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont21  :=TFont():new("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont16n :=TFont():new("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	local oFont15  :=TFont():new("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	local oFont15n :=TFont():new("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	local oFont14n :=TFont():new("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	local oFont24  :=TFont():new("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	local aBitmap  :=::aLogoBco 
	local cString  :=""
	local nI 	   :=0
	local nRow1	   :=0
	local nRow2	   :=0
	local nRow3	   :=0
	local nHPage   :=0
	local nVPage   :=0
	
	&& Configuração de Posicionamento da Página	
	nHPage := ::oReport:nHorzRes()
	nHPage *= (300/::oReport:nLogPixelX())
	nHPage -= HMARGEM  
	
	nVPage := ::oReport:nVertRes() 
	nVPage *= (300/::oReport:nLogPixelY())
	nVPage -= VMARGEM
	
	if ::nModelo == 1	
		
		/******************/
		/* PRIMEIRA PARTE */
		/******************/

		nRow1 := 0
		 
		::oReport:line(nRow1+0150,500,nRow1+0070, 500) && Linha Vertical
		::oReport:line(nRow1+0150,710,nRow1+0070, 710) && Linha Vertical
		
		::oReport:sayBitMap(nRow1+0075,94,aBitMap[1],0400,0072) && Logotipo do Banco
		::oReport:sayBitMap(nRow1+0075,94,aBitMap[1],0400,0072) && Logotipo do Banco

		if ::aDadosBanco[1] == "655"
		::oReport:say(nRow1+0075,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
		::oReport:say(nRow1+0075,513,"237-2",oFont21)
		else
		::oReport:say(nRow1+0075,513,::aDadosBanco[1]+"-9",oFont21)	&& [1]Numero do Banco
		endif
		
		::oReport:say(nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		::oReport:line(nRow1+0150,100,nRow1+0150,2300)
		
		::oReport:say(nRow1+0150,100 ,"Cedente",oFont8)
		if ::cBanco == "655"
			::oReport:say(nRow1+0200,100 ,"BANCO VOTORANTIM S/A",oFont10)	&& Nome + CNPJ da Empresa
		elseif ::cBanco == "422"
			::oReport:say(nRow1+0200,100 ,"BANCO SAFRA",oFont10)			&& Nome + CNPJ da Empresa
		else
			::oReport:say(nRow1+0200,100 ,::aDadosEmp[1],oFont10)				&& Nome + CNPJ da Empresa
		endif
		
		::oReport:say(nRow1+0150,1060,"Agência/Código Cedente",oFont8)
		::oReport:say(nRow1+0200,1060,::aDadosBanco[3]+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5],oFont10)
		
		::oReport:say(nRow1+0150,1510,"Nro.Documento",oFont8)
		::oReport:say(nRow1+0200,1510,::aDadosTit[6]+::aDadosTit[1],oFont10) && Prefixo+Numero+Parcela
		
		::oReport:say(nRow1+0250,100 ,"Sacado",oFont8)
		::oReport:say(nRow1+0300,100 ,SubStr(::aDadosSac[1],1,56),oFont10) && Nome do Cliente
		
		::oReport:say(nRow1+0250,1060,"Vencimento",oFont8)
		::oReport:say(nRow1+0300,1060,strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4),oFont10)
		
		::oReport:say(nRow1+0250,1510,"Valor do Documento",oFont8)
		::oReport:say(nRow1+0300,1550,Transform(::aDadosTit[5],"@E 99,999,999.99"),oFont10)
		
		::oReport:say(nRow1+0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
		::oReport:say(nRow1+0450,0100,"com as características acima.",oFont10)
		::oReport:say(nRow1+0350,1060,"Data",oFont8)
		::oReport:say(nRow1+0350,1410,"Assinatura",oFont8)
		::oReport:say(nRow1+0450,1060,"Data",oFont8)
		::oReport:say(nRow1+0450,1410,"Entregador",oFont8)
		
		::oReport:line(nRow1+0250, 100,nRow1+0250,1900 ) && Linha Horizontal
		::oReport:line(nRow1+0350, 100,nRow1+0350,1900 ) && Linha Horizontal
		::oReport:line(nRow1+0450,1050,nRow1+0450,1900 ) && Linha Horizontal
		::oReport:line(nRow1+0550, 100,nRow1+0550,2300 ) && Linha Horizontal
		
		::oReport:line(nRow1+0550,1050,nRow1+0150,1050 ) && Linha Vertical
		::oReport:line(nRow1+0550,1400,nRow1+0350,1400 ) && Linha Vertical
		::oReport:line(nRow1+0350,1500,nRow1+0150,1500 ) && Linha Vertical
		::oReport:line(nRow1+0550,1900,nRow1+0150,1900 ) && Linha Vertical
		
		::oReport:say(nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
		::oReport:say(nRow1+0205,1910,"(  )Ausente"                                   ,oFont8)
		::oReport:say(nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont8)
		::oReport:say(nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
		::oReport:say(nRow1+0325,1910,"(  )Não procurado"                             ,oFont8)
		::oReport:say(nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont8)
		::oReport:say(nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
		::oReport:say(nRow1+0445,1910,"(  )Falecido"                                  ,oFont8)
		::oReport:say(nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)	           
	
		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		
		nRow2 := 0
		
		&& Pontilhado Separador
		For nI := 100 to 2300 step 50
			::oReport:Line(nRow2+0580, nI,nRow2+0580, nI+30)
		Next nI
		
		::oReport:sayBitMap(nRow2+0635,94,aBitMap[1],0400,0072)
		
		::oReport:line(nRow2+0710,100,nRow2+0710,2300) && Linha Horizontal
		::oReport:line(nRow2+0710,500,nRow2+0630, 500) && Linha Vertical
		::oReport:line(nRow2+0710,710,nRow2+0630, 710) && Linha Vertical
		
		&& ::oReport:say(nRow2+0644,100,::aDadosBanco[2],oFont11 )		&& [2]Nome do Banco
		if ::aDadosBanco[1] == "655"
		::oReport:say(nRow2+0635,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
		::oReport:say(nRow2+0635,513,"237-2",oFont21)
		else
		::oReport:say(nRow2+0635,513,::aDadosBanco[1]+"-9",oFont21)	&& [1]Numero do Banco
		endif
		&& ::oReport:say(nRow2+0644,755,::cLinhaDig,oFont15n)			&& Linha Digitavel do Codigo de Barras
		::oReport:say(nRow2+0644,1755,"RECIBO DO SACADO",oFont10)		&& Descrição da Seção
		
		::oReport:line(nRow2+0810,100,nRow2+0810,2300 ) && Linha Horizontal
		::oReport:line(nRow2+0910,100,nRow2+0910,2300 ) && Linha Horizontal
		::oReport:line(nRow2+0980,100,nRow2+0980,2300 ) && Linha Horizontal
		::oReport:line(nRow2+1050,100,nRow2+1050,2300 ) && Linha Horizontal
		
		::oReport:line(nRow2+0910,500,nRow2+1050,500)   && Linha Vertical
		::oReport:line(nRow2+0980,750,nRow2+1050,750)	 && Linha Vertical
		::oReport:line(nRow2+0910,1000,nRow2+1050,1000) && Linha Vertical
		::oReport:line(nRow2+0910,1300,nRow2+0980,1300) && Linha Vertical
		::oReport:line(nRow2+0910,1480,nRow2+1050,1480) && Linha Vertical
		
		::oReport:say(nRow2+0710,100 ,"local de Pagamento",oFont8)
		::oReport:say(nRow2+0750,100 ,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)
		
		::oReport:say(nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		::oReport:say(nRow2+0750,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+0810,100 ,"Cedente",oFont8)
		if ::cBanco == "655"
			::oReport:say(nRow2+0850,100 ,"BANCO VOTORANTIM S/A",oFont10)	&& Nome da Empresa
		elseif ::cBanco == "422"
			::oReport:say(nRow2+0850,100 ,"BANCO SAFRA",oFont10)			&& Nome da Empresa
		else
			::oReport:say(nRow2+0850,100 ,::aDadosEmp[1],oFont10)				&& Nome da Empresa
		endif
		
		::oReport:say(nRow2+0810,1810,"Agência/Código Cedente",oFont8)
		cString := alltrim(Subs(::aDadosBanco[3],1,4))
		cString += if(empty(Subs(::aDadosBanco[3],5,1)),"","-"+Subs(::aDadosBanco[3],5,1))+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5]
		nCol := 1810+(374-(len(cString)*22))+40
		::oReport:say(nRow2+0850,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+0910,100 ,"Data do Documento",oFont8)
		::oReport:say(nRow2+0940,100, strZero(Day(::aDadosTit[2]),2) +"/"+ strZero(Month(::aDadosTit[2]),2) +"/"+ Right(Str(Year(::aDadosTit[2])),4),oFont10)
		
		::oReport:say(nRow2+0910,505 ,"Nro.Documento",oFont8)
		::oReport:say(nRow2+0940,605 ,::aDadosTit[6]+::aDadosTit[1],oFont10) && Prefixo+Numero+Parcela
		
		::oReport:say(nRow2+0910,1005,"Espécie Doc.",oFont8)
		::oReport:say(nRow2+0940,1050,::aDadosTit[7],oFont10) && Tipo do Titulo
		
		::oReport:say(nRow2+0910,1305,"Aceite",oFont8)
		::oReport:say(nRow2+0940,1400,"N",oFont10)
		
		::oReport:say(nRow2+0910,1485,"Data do Processamento",oFont8)
		::oReport:say(nRow2+0940,1550,strZero(Day(::aDadosTit[3]),2) +"/"+ strZero(Month(::aDadosTit[3]),2) +"/"+ Right(Str(Year(::aDadosTit[3])),4),oFont10) && Data de impressao
		
		::oReport:say(nRow2+0910,1810,"Nosso Número",oFont8)
		cString:= ::RetNossoNro() && Retorna o Nosso Número Formatado
		nCol := 1850+(374-(len(cString)*22))
		::oReport:say(nRow2+0940,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+0980,100 ,"Uso do Banco",oFont8)
		if ::cBanco == "422"
		::oReport:say(nRow2+1010,155 ,"CIP130",oFont10)
		endif
		
		::oReport:say(nRow2+0980,505 ,"Carteira",oFont8)
		::oReport:say(nRow2+1010,555 ,::aDadosBanco[7],oFont10)
		
		::oReport:say(nRow2+0980,755 ,"Espécie",oFont8)
		::oReport:say(nRow2+1010,805 ,"R$",oFont10)
		
		::oReport:say(nRow2+0980,1005,"Quantidade",oFont8)
		::oReport:say(nRow2+0980,1485,"Valor",oFont8)
		
		::oReport:say(nRow2+0980,1810,"Valor do Documento",oFont8)
		cString:= Transform(::aDadosTit[5],"@E 99,999,999.99")
		nCol := 1810+(374-(len(cString)*22))
		::oReport:say(nRow2+1010,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+1050, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		If !Empty(::aFrases)
			::oReport:say(nRow2+1150, 100,::aFrases[1],oFont10)
			::oReport:say(nRow2+1200, 100,::aFrases[2],oFont10)
			::oReport:say(nRow2+1250, 100,::aFrases[3],oFont10)
			::oReport:say(nRow2+1300, 100,::aFrases[4],oFont10)
		EndIf		
		::oReport:say(nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
		::oReport:say(nRow2+1120,1810,"(-)Outras Deduções",oFont8)
		::oReport:say(nRow2+1190,1810,"(+)Mora/Multa",oFont8)
		::oReport:say(nRow2+1260,1810,"(+)Outros Acréscimos",oFont8)
		::oReport:say(nRow2+1330,1810,"(=)Valor Cobrado",oFont8)
		
		::oReport:say(nRow2+1400,100 ,"Sacado",oFont8)
		::oReport:say(nRow2+1430,400 ,::aDadosSac[1]+" ("+::aDadosSac[2]+")",oFont10)
		::oReport:say(nRow2+1483,400 ,::aDadosSac[3],oFont10)
		::oReport:say(nRow2+1536,400 ,::aDadosSac[4]+" - "+::aDadosSac[5] + " - " + ::aDadosSac[6],oFont10) && Cidade+Estado+CEP
		
		/*if ::aDadosSac[8] = "J"
			::oReport:say(nRow2+1589,400 ,"CNPJ: "+TRANSFORM(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10) && CNPJ
		else
			::oReport:say(nRow2+1589,400 ,"CPF: "+TRANSFORM(::aDadosSac[7],"@R 999.999.999-99"),oFont10) 	&& CPF
		endif*/
			
		::oReport:say(nRow2+1605, 100,"Sacador/Avalista " + ::aDadosBanco[11],oFont8)
		::oReport:say(nRow2+1645,1810,"Autenticação Mecânica",oFont8)
		
		::oReport:line(nRow2+0710,1800,nRow2+1400,1800) 
		::oReport:line(nRow2+1120,1800,nRow2+1120,2300)
		::oReport:line(nRow2+1190,1800,nRow2+1190,2300)
		::oReport:line(nRow2+1260,1800,nRow2+1260,2300)
		::oReport:line(nRow2+1330,1800,nRow2+1330,2300)
		::oReport:line(nRow2+1400, 100,nRow2+1400,2300)
		::oReport:line(nRow2+1640, 100,nRow2+1640,2300)
		
		/******************/
		/* TERCEIRA PARTE */
		/******************/
		
		nRow3 := 0
		
		&& Pontilhado Separador
		For nI := 100 to 2300 step 50
			::oReport:Line(nRow3+1880, nI, nRow3+1880, nI+30)
		Next nI
		
		::oReport:line(nRow3+2000,100,nRow3+2000,2300) && Linha Horizontal
		::oReport:line(nRow3+2000,500,nRow3+1920,0500) && Linha Vertical
		::oReport:line(nRow3+2000,710,nRow3+1920,0710) && Linha Vertical
		
		::oReport:sayBitMap(nRow1+1925,94,aBitMap[1],0400,0072) 	   && Logotipo do Banco
		if ::aDadosBanco[1] == "655"
		::oReport:say(nRow3+1925,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
		::oReport:say(nRow3+1925,513,"237-2",oFont21)
		else
		::oReport:say(nRow3+1925,513,::aDadosBanco[1]+"-9",oFont21)	&& [1]Numero do Banco
		endif
		::oReport:say(nRow3+1934,755,::cLinhaDig,oFont15n)		   && Linha Digitavel do Codigo de Barras
		
		::oReport:line(nRow3+2100,100,nRow3+2100,2300) && Linha Horizontal
		::oReport:line(nRow3+2200,100,nRow3+2200,2300) && Linha Horizontal
		::oReport:line(nRow3+2270,100,nRow3+2270,2300) && Linha Horizontal
		::oReport:line(nRow3+2340,100,nRow3+2340,2300) && Linha Horizontal
		
		::oReport:line(nRow3+2200, 500,nRow3+2340, 500) && Linha Vertical
		::oReport:line(nRow3+2270, 750,nRow3+2340, 750) && Linha Vertical
		::oReport:line(nRow3+2200,1000,nRow3+2340,1000) && Linha Vertical
		::oReport:line(nRow3+2200,1300,nRow3+2270,1300) && Linha Vertical
		::oReport:line(nRow3+2200,1480,nRow3+2340,1480) && Linha Vertical
		
		::oReport:say(nRow3+2000, 100,"local de Pagamento",oFont8)
		::oReport:say(nRow3+2055, 100,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)
		           
		::oReport:say(nRow3+2000,1810,"Vencimento",oFont8)
		cString  := strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		::oReport:say(nRow3+2040,nCol,cString,oFont11c)
		
		::oReport:say(nRow3+2100, 100,"Cedente",oFont8)
		if ::cBanco == "655"
			::oReport:say(nRow3+2140,100 ,"BANCO VOTORANTIM S/A",oFont10)	&& Nome da Empresa
		elseif ::cBanco == "422"
			::oReport:say(nRow3+2140,100 ,"BANCO SAFRA",oFont10)			&& Nome da Empresa
		else
			::oReport:say(nRow3+2140,100 ,::aDadosEmp[1],oFont10)				&& Nome da Empresa
		endif
		
		::oReport:say(nRow3+2100,1810,"Agência/Código Cedente",oFont8)
		cString  := alltrim(Subs(::aDadosBanco[3],1,4))
		cString  += if(empty(Subs(::aDadosBanco[3],5,1)),"","-"+Subs(::aDadosBanco[3],5,1))+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5]
		nCol 	 := 1810+(374-(len(cString)*22))+40
		::oReport:say(nRow3+2140,nCol,cString ,oFont11c)
			
		::oReport:say(nRow3+2200, 100,"Data do Documento",oFont8)
		::oReport:say(nRow3+2230, 100, strZero(Day(::aDadosTit[2]),2) +"/"+ strZero(Month(::aDadosTit[2]),2) +"/"+ Right(Str(Year(::aDadosTit[2])),4), oFont10)
			
		::oReport:say(nRow3+2200, 505,"Nro.Documento",oFont8)
		::oReport:say(nRow3+2230, 605,::aDadosTit[6]+::aDadosTit[1],oFont10) && Prefixo+Numero+Parcela
		
		::oReport:say(nRow3+2200,1005,"Espécie Doc.",oFont8)
		::oReport:say(nRow3+2230,1050,::aDadosTit[7],oFont10) && Tipo do Titulo
		
		::oReport:say(nRow3+2200,1305,"Aceite",oFont8)
		::oReport:say(nRow3+2230,1400,"N",oFont10)
		
		::oReport:say(nRow3+2200,1485,"Data do Processamento",oFont8)
		::oReport:say(nRow3+2230,1550,strZero(Day(::aDadosTit[3]),2) +"/"+ strZero(Month(::aDadosTit[3]),2) +"/"+ Right(Str(Year(::aDadosTit[3])),4),oFont10) && Data impressao
			
		::oReport:say(nRow3+2200,1810,"Nosso Número",oFont8)
		cString  := ::RetNossoNro() && Retorna o Nosso Número Formatado
		nCol 	 := 1850+(374-(len(cString)*22))
		::oReport:say(nRow3+2230,nCol,cString,oFont11c)	
		
		::oReport:say(nRow3+2270, 100,"Uso do Banco",oFont8)
		if ::cBanco == "422"
		::oReport:say(nRow3+2300, 155,"CIP130",oFont10)
		endif
		
		::oReport:say(nRow3+2270, 505,"Carteira",oFont8)
		::oReport:say(nRow3+2300, 555,::aDadosBanco[7],oFont10)
		
		::oReport:say(nRow3+2270, 755,"Espécie",oFont8)
		::oReport:say(nRow3+2300, 805,"R$",oFont10)
		
		::oReport:say(nRow3+2270,1005,"Quantidade",oFont8)
		::oReport:say(nRow3+2270,1485,"Valor",oFont8)
		
		::oReport:say(nRow3+2270,1810,"Valor do Documento",oFont8)
		cString  := Transform(::aDadosTit[5],"@E 99,999,999.99")
		nCol 	 := 1810+(374-(len(cString)*22))
		::oReport:say(nRow3+2300,nCol,cString,oFont11c)
		
		::oReport:say(nRow3+2340, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		If !Empty(::aFrases)
			::oReport:say(nRow2+2440, 100,::aFrases[1],oFont10)
			::oReport:say(nRow2+2490, 100,::aFrases[2],oFont10)
			::oReport:say(nRow2+2540, 100,::aFrases[3],oFont10)
			::oReport:say(nRow2+2590, 100,::aFrases[4],oFont10)
		EndIf
		::oReport:say(nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
		::oReport:say(nRow3+2410,1810,"(-)Outras Deduções",oFont8)
		::oReport:say(nRow3+2480,1810,"(+)Mora/Multa",oFont8)
		::oReport:say(nRow3+2550,1810,"(+)Outros Acréscimos",oFont8)
		::oReport:say(nRow3+2620,1810,"(=)Valor Cobrado",oFont8)
		
		::oReport:say(nRow3+2690, 100,"Sacado",oFont8)
		::oReport:say(nRow3+2700, 400,::aDadosSac[1]+" ("+::aDadosSac[2]+")",oFont10)
		
		::oReport:say(nRow3+2753, 400,::aDadosSac[3],oFont10)
		::oReport:say(nRow3+2806, 400,::aDadosSac[4]+" - "+::aDadosSac[5]+" - "+::aDadosSac[6],oFont10) && Cidade+Estado+CEP
		
		/*if ::aDadosSac[8] = "J"
			::oReport:say(nRow3+2859, 400,"CNPJ: "+TRANSFORM(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10) && CNPJ
		else
			::oReport:say(nRow3+2859, 400,"CPF: "+TRANSFORM(::aDadosSac[7],"@R 999.999.999-99"),oFont10) 	&& CPF
		endif*/
		
		::oReport:say(nRow3+2868, 100,"Sacador/Avalista " + ::aDadosBanco[11],oFont8)
		::oReport:say(nRow3+2908,1810,"Autenticação Mecânica",oFont8)
		
		::oReport:line(nRow3+2000,1800,nRow3+2690,1800) && Linha Vertical
		::oReport:line(nRow3+2410,1800,nRow3+2410,2300) && Linha Horizontal
		::oReport:line(nRow3+2480,1800,nRow3+2480,2300) && Linha Horizontal
		::oReport:line(nRow3+2550,1800,nRow3+2550,2300) && Linha Horizontal
		::oReport:line(nRow3+2620,1800,nRow3+2620,2300) && Linha Horizontal
		::oReport:line(nRow3+2690, 100,nRow3+2690,2300) && Linha Horizontal
		
		::oReport:line(nRow3+2905, 100,nRow3+2905,2300) && Linha Horizontal
		    
		::oReport:say(nRow3+3060,1800,"FICHA DE COMPENSAÇÃO",oFont10)
	
		/*	
		| Parametros do MSBAR                                              |
		+------------------------------------------------------------------+
		| 01 cTypeBar String com o tipo do codigo de barras                |
		|    "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"                    |
		|    "INT25","MAT25,"IND25","CODABAR","CODE3_9"                    |
		| 02 nRow           Numero da Linha em centimentros                |
		| 03 nCol           Numero da coluna em centimentros               |
		| 04 cCode          String com o conteudo do codigo                |
		| 05 oPr            Objeto Printer                                 |
		| 06 lcheck         Se calcula o digito de controle                |
		| 07 Cor            Numero da Cor, utilize a "common.ch"           |
		| 08 lHort          Se imprime na Horizontal                       |
		| 09 nWidth         Numero do Tamanho da barra em centimetros      |
		| 10 nHeigth        Numero da Altura da barra em milimetros        |
		| 11 lBanner        Se imprime o linha em baixo do codigo          |
		| 12 cFont          String com o tipo de fonte                     |
		| 13 cMode          String com o modo do codigo de barras CODE128  |
		*/
		
		&& Conversão de Pixels para CM
		&& Fator = 0,0084682	cm/pixel
		&& Exemplo => 75 pixel = 0.63 cm; 2905 pixel = 24.60 cm; 3035 pixel = 25.70cm
	
		&& Imprime o Código de Barra - ATENÇÃO! Dimensões podem variar dependendo da Impressora Selecionada
		&& Sintaxe: MSBAR3(cTypeBar,nRow,nCol,cCode,::oReport,lCheck,Color,lHorz,nWidth,nHeigth,lBanner,cFont,cMode)
		&& Padrão FEBRABAN => 2 de 5 Intercalado -> INT25
		&& MSBAR3("INT25",25.3,1.4,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)
		MSBAR3("INT25",24.7,1.1,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)
		
	&& MODELO DE LAYOUT 2
	elseif ::nModelo == 2
		
		/******************/
		/* PRIMEIRA PARTE */
		/******************/

		nRow1 := 0
		 
		::oReport:line(nRow1+0150,500,nRow1+0070, 500) && Linha Vertical
		::oReport:line(nRow1+0150,710,nRow1+0070, 710) && Linha Vertical
		
		::oReport:sayBitMap(nRow1+0075,94,aBitMap[1],0400,0072) && Logotipo do Banco

		if ::aDadosBanco[1] == "655"
		::oReport:say(nRow1+0075,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
		::oReport:say(nRow1+0075,513,"237-2",oFont21)
		else
		::oReport:say(nRow1+0075,513,::aDadosBanco[1]+"-9",oFont21)	&& [1]Numero do Banco
		endif
		
		::oReport:say(nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		::oReport:line(nRow1+0150,100,nRow1+0150,2300)
		
		::oReport:say(nRow1+0150,100 ,"Cedente",oFont8)
		::oReport:say(nRow1+0200,100 ,::aDadosEmp[1],oFont10)	&& Nome + CNPJ da Empresa
		
		::oReport:say(nRow1+0150,1060,"Agência/Código Cedente",oFont8)
		::oReport:say(nRow1+0200,1060,::aDadosBanco[3]+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5],oFont10)
		
		::oReport:say(nRow1+0150,1510,"Nro.Documento",oFont8)
		::oReport:say(nRow1+0200,1510,::aDadosTit[6]+::aDadosTit[1],oFont10) && Prefixo+Numero+Parcela
		
		::oReport:say(nRow1+0250,100 ,"Sacado",oFont8)
		::oReport:say(nRow1+0300,100 ,::aDadosSac[1],oFont10) && Nome do Cliente
		
		::oReport:say(nRow1+0250,1060,"Vencimento",oFont8)
		::oReport:say(nRow1+0300,1060,strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4),oFont10)
		
		::oReport:say(nRow1+0250,1510,"Valor do Documento",oFont8)
		::oReport:say(nRow1+0300,1550,Transform(::aDadosTit[5],"@E 99,999,999.99"),oFont10)
		
		::oReport:say(nRow1+0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
		::oReport:say(nRow1+0450,0100,"com as características acima.",oFont10)
		::oReport:say(nRow1+0350,1060,"Data",oFont8)
		::oReport:say(nRow1+0350,1410,"Assinatura",oFont8)
		::oReport:say(nRow1+0450,1060,"Data",oFont8)
		::oReport:say(nRow1+0450,1410,"Entregador",oFont8)
		
		::oReport:line(nRow1+0250, 100,nRow1+0250,1900 ) && Linha Horizontal
		::oReport:line(nRow1+0350, 100,nRow1+0350,1900 ) && Linha Horizontal
		::oReport:line(nRow1+0450,1050,nRow1+0450,1900 ) && Linha Horizontal
		::oReport:line(nRow1+0550, 100,nRow1+0550,2300 ) && Linha Horizontal
		
		::oReport:line(nRow1+0550,1050,nRow1+0150,1050 ) && Linha Vertical
		::oReport:line(nRow1+0550,1400,nRow1+0350,1400 ) && Linha Vertical
		::oReport:line(nRow1+0350,1500,nRow1+0150,1500 ) && Linha Vertical
		::oReport:line(nRow1+0550,1900,nRow1+0150,1900 ) && Linha Vertical
		
		::oReport:say(nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
		::oReport:say(nRow1+0205,1910,"(  )Ausente"                                   ,oFont8)
		::oReport:say(nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont8)
		::oReport:say(nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
		::oReport:say(nRow1+0325,1910,"(  )Não procurado"                             ,oFont8)
		::oReport:say(nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont8)
		::oReport:say(nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
		::oReport:say(nRow1+0445,1910,"(  )Falecido"                                  ,oFont8)
		::oReport:say(nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)	           
	
		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		
		nRow2 := 0
		
		&& Pontilhado Separador
		For nI := 100 to 2300 step 50
			::oReport:Line(nRow2+0580, nI,nRow2+0580, nI+30)
		Next nI
		
		::oReport:sayBitMap(nRow2+0635,94,aBitMap[1],0400,0072)
		
		::oReport:line(nRow2+0710,100,nRow2+0710,2300) && Linha Horizontal
		::oReport:line(nRow2+0710,500,nRow2+0630, 500) && Linha Vertical
		::oReport:line(nRow2+0710,710,nRow2+0630, 710) && Linha Vertical
		
		&& ::oReport:say(nRow2+0644,100,::aDadosBanco[2],oFont11 )		&& [2]Nome do Banco

		if ::aDadosBanco[1] == "655"
		::oReport:say(nRow2+0635,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
		::oReport:say(nRow2+0635,513,"237-2",oFont21)
		else
		::oReport:say(nRow2+0635,513,::aDadosBanco[1]+"-9",oFont21)	&& [1]Numero do Banco
		endif
		::oReport:say(nRow2+0644,755,::cLinhaDig,oFont15n)			&& Linha Digitavel do Codigo de Barras
		
		::oReport:line(nRow2+0810,100,nRow2+0810,2300 ) && Linha Horizontal
		::oReport:line(nRow2+0910,100,nRow2+0910,2300 ) && Linha Horizontal
		::oReport:line(nRow2+0980,100,nRow2+0980,2300 ) && Linha Horizontal
		::oReport:line(nRow2+1050,100,nRow2+1050,2300 ) && Linha Horizontal
		
		::oReport:line(nRow2+0910,500,nRow2+1050,500)   && Linha Vertical
		::oReport:line(nRow2+0980,750,nRow2+1050,750)	 && Linha Vertical
		::oReport:line(nRow2+0910,1000,nRow2+1050,1000) && Linha Vertical
		::oReport:line(nRow2+0910,1300,nRow2+0980,1300) && Linha Vertical
		::oReport:line(nRow2+0910,1480,nRow2+1050,1480) && Linha Vertical
		
		::oReport:say(nRow2+0710,100 ,"local de Pagamento",oFont8)
		::oReport:say(nRow2+0750,100 ,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)
		
		::oReport:say(nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		::oReport:say(nRow2+0750,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+0810,100 ,"Cedente",oFont8)
		::oReport:say(nRow2+0850,100 ,::aDadosEmp[1],oFont10) && Nome da Empresa
		
		::oReport:say(nRow2+0810,1810,"Agência/Código Cedente",oFont8)
		cString := alltrim(Subs(::aDadosBanco[3],1,4)+"-"+Subs(::aDadosBanco[3],5,1)+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5])
		nCol := 1810+(374-(len(cString)*22))+40
		::oReport:say(nRow2+0850,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+0910,100 ,"Data do Documento",oFont8)
		::oReport:say(nRow2+0940,100, strZero(Day(::aDadosTit[2]),2) +"/"+ strZero(Month(::aDadosTit[2]),2) +"/"+ Right(Str(Year(::aDadosTit[2])),4),oFont10)
		
		::oReport:say(nRow2+0910,505 ,"Nro.Documento",oFont8)
		::oReport:say(nRow2+0940,605 ,::aDadosTit[6]+::aDadosTit[1],oFont10) && Prefixo+Numero+Parcela
		
		::oReport:say(nRow2+0910,1005,"Espécie Doc.",oFont8)
		::oReport:say(nRow2+0940,1050,::aDadosTit[7],oFont10) && Tipo do Titulo
		
		::oReport:say(nRow2+0910,1305,"Aceite",oFont8)
		::oReport:say(nRow2+0940,1400,"N",oFont10)
		
		::oReport:say(nRow2+0910,1485,"Data do Processamento",oFont8)
		::oReport:say(nRow2+0940,1550,strZero(Day(::aDadosTit[3]),2) +"/"+ strZero(Month(::aDadosTit[3]),2) +"/"+ Right(Str(Year(::aDadosTit[3])),4),oFont10) && Data de impressao
		
		::oReport:say(nRow2+0910,1810,"Nosso Número",oFont8)
		cString:= ::RetNossoNro() && Retorna o Nosso Número Formatado
		nCol := 1850+(374-(len(cString)*22))
		::oReport:say(nRow2+0940,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+0980,100 ,"Uso do Banco",oFont8)
		if ::cBanco == "422"
		::oReport:say(nRow3+1010,155 ,"CIP130",oFont10)
		endif
		
		::oReport:say(nRow2+0980,505 ,"Carteira",oFont8)
		::oReport:say(nRow2+1010,555 ,::aDadosBanco[7],oFont10)
		
		::oReport:say(nRow2+0980,755 ,"Espécie",oFont8)
		::oReport:say(nRow2+1010,805 ,"R$",oFont10)
		
		::oReport:say(nRow2+0980,1005,"Quantidade",oFont8)
		::oReport:say(nRow2+0980,1485,"Valor",oFont8)
		
		::oReport:say(nRow2+0980,1810,"Valor do Documento",oFont8)
		cString:= Transform(::aDadosTit[5],"@E 99,999,999.99")
		nCol := 1810+(374-(len(cString)*22))
		::oReport:say(nRow2+1010,nCol,cString,oFont11c)
		
		::oReport:say(nRow2+1050, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		If !Empty(::aFrases)
			::oReport:say(nRow2+1150, 100,::aFrases[1],oFont10)
			::oReport:say(nRow2+1200, 100,::aFrases[2],oFont10)
			::oReport:say(nRow2+1250, 100,::aFrases[3],oFont10)
			::oReport:say(nRow2+1300, 100,::aFrases[4],oFont10)
		EndIF
		::oReport:say(nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
		::oReport:say(nRow2+1120,1810,"(-)Outras Deduções",oFont8)
		::oReport:say(nRow2+1190,1810,"(+)Mora/Multa",oFont8)
		::oReport:say(nRow2+1260,1810,"(+)Outros Acréscimos",oFont8)
		::oReport:say(nRow2+1330,1810,"(=)Valor Cobrado",oFont8)
		
		::oReport:say(nRow2+1400,100 ,"Sacado",oFont8)
		::oReport:say(nRow2+1430,400 ,::aDadosSac[1]+" ("+::aDadosSac[2]+")",oFont10)
		::oReport:say(nRow2+1483,400 ,::aDadosSac[3],oFont10)
		::oReport:say(nRow2+1536,400 ,::aDadosSac[4]+" - "+::aDadosSac[5] + " - " + ::aDadosSac[6],oFont10) && Cidade+Estado+CEP
		
		/*if ::aDadosSac[8] = "J"
			::oReport:say(nRow2+1589,400 ,"CNPJ: "+TRANSFORM(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10) && CNPJ
		else
			::oReport:say(nRow2+1589,400 ,"CPF: "+TRANSFORM(::aDadosSac[7],"@R 999.999.999-99"),oFont10) 	&& CPF
		endif*/
			
		::oReport:say(nRow2+1605, 100,"Sacador/Avalista " + ::aDadosBanco[11],oFont8)
		::oReport:say(nRow2+1645,1810,"Autenticação Mecânica",oFont8)
		
		::oReport:line(nRow2+0710,1800,nRow2+1400,1800) 
		::oReport:line(nRow2+1120,1800,nRow2+1120,2300)
		::oReport:line(nRow2+1190,1800,nRow2+1190,2300)
		::oReport:line(nRow2+1260,1800,nRow2+1260,2300)
		::oReport:line(nRow2+1330,1800,nRow2+1330,2300)
		::oReport:line(nRow2+1400, 100,nRow2+1400,2300)
		::oReport:line(nRow2+1640, 100,nRow2+1640,2300)
		
		&& Conversão de Pixels para CM
		&& Fator = 0,0084682	cm/pixel
		&& Exemplo => 75 pixel = 0.63 cm; 1645 pixel = 24.60 cm
	
		&& Imprime o Código de Barra - ATENÇÃO! Dimensões podem variar dependendo da Impressora Selecionada
		&& Sintaxe: MSBAR3(cTypeBar,nRow,nCol,cCode,::oReport,lCheck,Color,lHorz,nWidth,nHeigth,lBanner,cFont,cMode)
		&& Padrão FEBRABAN => 2 de 5 Intercalado -> INT25		
		MSBAR3("INT25",14,1.1,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)
		
		/******************/
		/* TERCEIRA PARTE */
		/******************/
		
		nRow3 := 0
		
		&& Pontilhado Separador
		For nI := 100 to 2300 step 50
			::oReport:Line(nRow3+1880, nI, nRow3+1880, nI+30)
		Next nI
		
		::oReport:line(nRow3+2000,100,nRow3+2000,2300) && Linha Horizontal
		::oReport:line(nRow3+2000,500,nRow3+1920,0500) && Linha Vertical
		::oReport:line(nRow3+2000,710,nRow3+1920,0710) && Linha Vertical
		
		::oReport:sayBitMap(nRow1+1925,94,aBitMap[1],0400,0072) 	   && Logotipo do Banco

		if ::aDadosBanco[1] == "655"
		::oReport:say(nRow3+1925,513,"341",oFont21)
		elseif ::aDadosBanco[1] == "422"
		::oReport:say(nRow3+1925,513,"237-2",oFont21)
		else
		::oReport:say(nRow3+1925,513,::aDadosBanco[1]+"-9",oFont21)	&& [1]Numero do Banco
		endif
		::oReport:say(nRow3+1934,755,::cLinhaDig,oFont15n)		   && Linha Digitavel do Codigo de Barras
		
		::oReport:line(nRow3+2100,100,nRow3+2100,2300) && Linha Horizontal
		::oReport:line(nRow3+2200,100,nRow3+2200,2300) && Linha Horizontal
		::oReport:line(nRow3+2270,100,nRow3+2270,2300) && Linha Horizontal
		::oReport:line(nRow3+2340,100,nRow3+2340,2300) && Linha Horizontal
		
		::oReport:line(nRow3+2200, 500,nRow3+2340, 500) && Linha Vertical
		::oReport:line(nRow3+2270, 750,nRow3+2340, 750) && Linha Vertical
		::oReport:line(nRow3+2200,1000,nRow3+2340,1000) && Linha Vertical
		::oReport:line(nRow3+2200,1300,nRow3+2270,1300) && Linha Vertical
		::oReport:line(nRow3+2200,1480,nRow3+2340,1480) && Linha Vertical
		
		::oReport:say(nRow3+2000, 100,"local de Pagamento",oFont8)
		::oReport:say(nRow3+2055, 100,"QUALQUER BANCO ATE O VENCIMENTO",oFont10)
		           
		::oReport:say(nRow3+2000,1810,"Vencimento",oFont8)
		cString  := strZero(Day(::aDadosTit[4]),2) +"/"+ strZero(Month(::aDadosTit[4]),2) +"/"+ Right(Str(Year(::aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		::oReport:say(nRow3+2040,nCol,cString,oFont11c)
		
		::oReport:say(nRow3+2100, 100,"Cedente",oFont8)
		::oReport:say(nRow3+2140, 100,::aDadosEmp[1],oFont10) && Nome da Empresa
		
		::oReport:say(nRow3+2100,1810,"Agência/Código Cedente",oFont8)
		cString  := alltrim(Subs(::aDadosBanco[3],1,4)+"-"+Subs(::aDadosBanco[3],5,1)+"/"+::aDadosBanco[4]+"-"+::aDadosBanco[5])
		nCol 	 := 1810+(374-(len(cString)*22))+40
		::oReport:say(nRow3+2140,nCol,cString ,oFont11c)
			
		::oReport:say(nRow3+2200, 100,"Data do Documento",oFont8)
		::oReport:say(nRow3+2230, 100, strZero(Day(::aDadosTit[2]),2) +"/"+ strZero(Month(::aDadosTit[2]),2) +"/"+ Right(Str(Year(::aDadosTit[2])),4), oFont10)
			
		::oReport:say(nRow3+2200, 505,"Nro.Documento",oFont8)
		::oReport:say(nRow3+2230, 605,::aDadosTit[6]+::aDadosTit[1],oFont10) && Prefixo+Numero+Parcela
		
		::oReport:say(nRow3+2200,1005,"Espécie Doc.",oFont8)
		::oReport:say(nRow3+2230,1050,::aDadosTit[7],oFont10) && Tipo do Titulo
		
		::oReport:say(nRow3+2200,1305,"Aceite",oFont8)
		::oReport:say(nRow3+2230,1400,"N",oFont10)
		
		::oReport:say(nRow3+2200,1485,"Data do Processamento",oFont8)
		::oReport:say(nRow3+2230,1550,strZero(Day(::aDadosTit[3]),2) +"/"+ strZero(Month(::aDadosTit[3]),2) +"/"+ Right(Str(Year(::aDadosTit[3])),4),oFont10) && Data impressao
			
		::oReport:say(nRow3+2200,1810,"Nosso Número",oFont8)
		cString  := ::RetNossoNro() && Retorna o Nosso Número Formatado
		nCol 	 := 1850+(374-(len(cString)*22))
		::oReport:say(nRow3+2230,nCol,cString,oFont11c)	
		
		::oReport:say(nRow3+2270, 100,"Uso do Banco",oFont8)
		if ::cBanco == "422"
		::oReport:say(nRow3+2300, 155,"CIP130",oFont10)
		endif
		
		::oReport:say(nRow3+2270, 505,"Carteira",oFont8)
		::oReport:say(nRow3+2300, 555,::aDadosBanco[7],oFont10)
		
		::oReport:say(nRow3+2270, 755,"Espécie",oFont8)
		::oReport:say(nRow3+2300, 805,"R$",oFont10)
		
		::oReport:say(nRow3+2270,1005,"Quantidade",oFont8)
		::oReport:say(nRow3+2270,1485,"Valor",oFont8)
		
		::oReport:say(nRow3+2270,1810,"Valor do Documento",oFont8)
		cString  := Transform(::aDadosTit[5],"@E 99,999,999.99")
		nCol 	 := 1810+(374-(len(cString)*22))
		::oReport:say(nRow3+2300,nCol,cString,oFont11c)
		
		::oReport:say(nRow3+2340, 100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		If !Empty(::aFrases)
			::oReport:say(nRow2+2440, 100,::aFrases[1],oFont10)
			::oReport:say(nRow2+2490, 100,::aFrases[2],oFont10)
			::oReport:say(nRow2+2540, 100,::aFrases[3],oFont10)
			::oReport:say(nRow2+2590, 100,::aFrases[4],oFont10)
		EndIf
		::oReport:say(nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
		::oReport:say(nRow3+2410,1810,"(-)Outras Deduções",oFont8)
		::oReport:say(nRow3+2480,1810,"(+)Mora/Multa",oFont8)
		::oReport:say(nRow3+2550,1810,"(+)Outros Acréscimos",oFont8)
		::oReport:say(nRow3+2620,1810,"(=)Valor Cobrado",oFont8)
		
		::oReport:say(nRow3+2690, 100,"Sacado",oFont8)
		::oReport:say(nRow3+2700, 400,::aDadosSac[1]+" ("+::aDadosSac[2]+")",oFont10)
		
		::oReport:say(nRow3+2753, 400,::aDadosSac[3],oFont10)
		::oReport:say(nRow3+2806, 400,::aDadosSac[4]+" - "+::aDadosSac[5]+" - "+::aDadosSac[6],oFont10) && Cidade+Estado+CEP
		
		/*if ::aDadosSac[8] = "J"
			::oReport:say(nRow3+2859, 400,"CNPJ: "+TRANSFORM(::aDadosSac[7],"@R 99.999.999/9999-99"),oFont10) && CNPJ
		else
			::oReport:say(nRow3+2859, 400,"CPF: "+TRANSFORM(::aDadosSac[7],"@R 999.999.999-99"),oFont10) 	&& CPF
		endif*/
		
		::oReport:say(nRow3+2868, 100,"Sacador/Avalista " + ::aDadosBanco[11],oFont8)
		::oReport:say(nRow3+2908,1810,"Autenticação Mecânica",oFont8)
		
		::oReport:line(nRow3+2000,1800,nRow3+2690,1800) && Linha Vertical
		::oReport:line(nRow3+2410,1800,nRow3+2410,2300) && Linha Horizontal
		::oReport:line(nRow3+2480,1800,nRow3+2480,2300) && Linha Horizontal
		::oReport:line(nRow3+2550,1800,nRow3+2550,2300) && Linha Horizontal
		::oReport:line(nRow3+2620,1800,nRow3+2620,2300) && Linha Horizontal
		::oReport:line(nRow3+2690, 100,nRow3+2690,2300) && Linha Horizontal
		
		::oReport:line(nRow3+2905, 100,nRow3+2905,2300) && Linha Horizontal
		    
		::oReport:say(nRow3+3060,1800,"FICHA DE COMPENSAÇÃO",oFont10)
	
		/*	
		| Parametros do MSBAR                                              |
		+------------------------------------------------------------------+
		| 01 cTypeBar String com o tipo do codigo de barras                |
		|    "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"                    |
		|    "INT25","MAT25,"IND25","CODABAR","CODE3_9"                    |
		| 02 nRow           Numero da Linha em centimentros                |
		| 03 nCol           Numero da coluna em centimentros               |
		| 04 cCode          String com o conteudo do codigo                |
		| 05 oPr            Objeto Printer                                 |
		| 06 lcheck         Se calcula o digito de controle                |
		| 07 Cor            Numero da Cor, utilize a "common.ch"           |
		| 08 lHort          Se imprime na Horizontal                       |
		| 09 nWidth         Numero do Tamanho da barra em centimetros      |
		| 10 nHeigth        Numero da Altura da barra em milimetros        |
		| 11 lBanner        Se imprime o linha em baixo do codigo          |
		| 12 cFont          String com o tipo de fonte                     |
		| 13 cMode          String com o modo do codigo de barras CODE128  |
		*/
		
		&& Conversão de Pixels para CM
		&& Fator = 0,0084682	cm/pixel
		&& Exemplo => 75 pixel = 0.63 cm; 2905 pixel = 24.60 cm; 3035 pixel = 25.70cm
	
		&& Imprime o Código de Barra - ATENÇÃO! Dimensões podem variar dependendo da Impressora Selecionada
		&& Sintaxe: MSBAR3(cTypeBar,nRow,nCol,cCode,::oReport,lCheck,Color,lHorz,nWidth,nHeigth,lBanner,cFont,cMode)
		&& Padrão FEBRABAN => 2 de 5 Intercalado -> INT25
		&& MSBAR3("INT25",25.3,1.4,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)
		MSBAR3("INT25",24.7,1.1,::cCodBarra,::oReport,.F.,Nil,Nil,0.0308,1.3,Nil,Nil,"A",.F.)		
	endif
				
	&& Finaliza a página
	::oReport:EndPage()
//	::oReport:Setup()       && Apresenta o Seletor para Escolha da Impressora a Utilizar na Impressão
//	::oReport:Preview()     && Visualiza antes de imprimir	
return

&& #########################################################################
&& FUNÇÕES AUXILIARES
&& #########################################################################

&& Função de Modulo10 para retorno do dígito verificador de Partes da Linha Digitável
&& Baseada no Cálculo do Banco do Brasil e na Função Modulo11
User Function Modulo10(cStr,nMultIni,nMultFim,cTipo)

	local nCont	  := 0 
	local nSoma	  := 0 
	local nRes	  := 0
	local cChar   := ""
	local nMult   := nMultIni
	local cRet	  := ""
	
	default nMultIni:= 2
	default nMultFim:= 1
	default cTipo   := "Dezena" && Tipo de Subtração Final "Dezena" ou "Divisor"
	
	&& Prepara a String
	cStr := alltrim(cStr)
	
	&& Percorre da Direita para a Esquerda
	For nCont := Len(cStr) to 1 Step -1
		&& Avalia se o Item é um número
		cChar := subStr(cStr,nCont,1)
		if isAlpha( cChar )
			Help(" ", 1, "ONLYNUM")
			return .f.
		End
		
		&& Calcula a multiplicação e se for maior que 9 soma os 2 algarismos para sempre retornar 1 dígito 
		nRes:= val(cChar) * nMult
		if nRes > 9
			nRes:= val(left(Str(nRes,2),1)) + val(Right(Str(nRes,2),1))
		endif
		
		&& Acumula a Soma da Multiplicação dos Elementos pelo Multiplicador
		nSoma += nRes 
		
		&& Redefine o Novo Multiplicador
		nMult:= IIf(nMult==nMultfim,nMultIni,If(nMultIni>nMultfim,--nMult,++nMult))
	Next
	
	&& Calcula a Dezena imediatamente posterior a Soma Calculada	
	nDezena := alltrim(Str(nSoma,12))
	nDezena := val(alltrim(Str(val(subStr(nDezena,1,1))+1,12))+"0")	
	
	&& Calcula o Resto da Divisão
	nRest := Mod(nSoma,10)
	
	&& Calcula o DV Final
	if cTipo == "Dezena"
		cRet  := Right(Str(nDezena - nRest),1)
	elseif cTipo == "Divisor"
		if nRest == 0
			cRet := "0"
		else
			cRet := Right(Str(10 - nRest),1)
		endif
	endif
	
return (cRet)

&& Função de Modulo11 do Padrão do Sistema (Fonte SM1M150) modificada para retorno do dígito verificador de diversos bancos	
&& Uso de Exemplo:  Alert(U_Modulo11("28398200001",9,2,"001"))
User Function Modulo11(cStr,nMultIni,nMultFim,cBanco,nTipo)

	local nCont	  := 0 
	local nSoma	  := 0
	local cChar   := ""
	local nMult   := nMultIni
	local cRet	  := ""
	
	default nMultIni:= 9
	default nMultFim:= 2
	default nTipo   := 1 && 1=Nosso Número / 2=Codigo de Barras
	
	&& Prepara a String
	cStr := alltrim(cStr)
	
	&& Percorre da Direita para a Esquerda
	For nCont := Len(cStr) to 1 Step -1
		&& Avalia se o Item é um número
		cChar := subStr(cStr,nCont,1)
		if isAlpha( cChar )
			Help(" ", 1, "ONLYNUM")
			return .f.
		End
		
		&& Acumula a Soma da Multiplicação dos Elementos pelo Multiplicador
		nSoma += val(cChar) * nMult
		
		&& Redefine o Novo Multiplicador
		nMult:= IIf(nMult==nMultfim,nMultIni,If(nMultIni>nMultfim,--nMult,++nMult))
	Next
	
	&& Calcula o Resto da Divisão
	nRest := Mod(nSoma,11)
	
	&& Define Como será o Resultado do Dígito Verificador

	&& Se for Banco do Brasil
	if cBanco == "001"
		if nTipo == 1 && Para Nosso Número
			if nRest < 10
				cRet:= Str(nRest,1)
			elseif nRest == 10
				cRet:= "X"
			endif 
		
		elseif nTipo == 2 && Para Código de Barras
			nRest:= 11 - nRest
			if nRest == 0 .Or. nRest == 10 .Or. nRest == 11
				cRet:= "1"
			else
				cRet:= Str(nRest,1)
			endif
		endif
	
	&& Se for Bradesco
	elseif cBanco == "237" .or. (cBanco == "422" .and. nTipo == 2)
		&&if nRest == 0
		&&	cRet := "0"
		&&elseif nRest == 1 && 11 - 1 = 10 => P
		&&	cRet := "P"
		&&else
			nRest := 11-nRest
			cRet  := Str(nRest,1)					
		&&endif
		
	&& Se for Safra
	elseif cBanco == "422" .and. nTipo == 1
		if nRest == 0
			cRet := "1"
		elseif nRest == 1 && 11 - 1 = 10 => P
			cRet := "0"
		else
			nRest := 11-nRest
			cRet  := Str(nRest,1)					
		endif

	&& Se for Itau ou Votorantim
	elseif cBanco == "341" .or. cBanco == "655"
		nRest := 11-nRest
		nRest := Iif (nRest == 0 .Or. nRest == 1 .Or. nRest == 10 .Or. nRest == 11, 1 , nRest)
		cRet  := Str(nRest,1)
	
	&& Se for Caixa Econômica Federal
	elseif cBanco == "104"
		nRest := 11-nRest
		nRest := Iif (nRest > 9, 0 , nRest)
		cRet  := Str(nRest,1)

	&& Se Banco não Especificado ou não constar tratamento para o banco - Considera o Cálculo Padrão
	else
		nRest := IIf(nRest==0 .or. nRest==1, 0 , 11-nRest)
		cRet  := Str(nRest,1)					
	
	endif	
	
return cRet
  
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçã     ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                  	  		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

	local _sAlias	:= Alias()
	local aCposSX1	:= {}
	local nX 		:= 0
	local lAltera	:= .F.
	local nCondicao := nil
	local cKey		:= ""
	local nJ		:= 0

	aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
				"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
				"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
				"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
				"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
				"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
				"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
				"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For nX:=1 to Len(aPergs)
		lAltera := .F.
		if MsSeek(PADR(cPerg,10)+Right(aPergs[nX][11], 2))
			if (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
				 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
				aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
				lAltera := .T.
			endif
		endif
		
		if ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
	 		lAltera := .T.		&& Garanto que o tipo da pergunta esteja correto
	 	endif	
		
		if ! Found() .Or. lAltera
			RecLock("SX1",If(lAltera, .F., .T.))
			Replace X1_GRUPO with cPerg
			Replace X1_ORDEM with Right(aPergs[nX][11], 2)
			For nj:=1 to Len(aCposSX1)
				if 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
					FieldPos(alltrim(aCposSX1[nJ])) > 0
					Replace &(alltrim(aCposSX1[nJ])) With aPergs[nx][nj]
				endif
			Next nj
			MsUnlock()
			cKey := "P."+alltrim(X1_GRUPO)+alltrim(X1_ORDEM)+"."
	
			if ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
				aHelpSpa := aPergs[nx][Len(aPergs[nx])]
			else
				aHelpSpa := {}
			endif
			
			if ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
				aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
			else
				aHelpEng := {}
			endif
	
			if ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
				aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
			else
				aHelpPor := {}
			endif
	
			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		endif
	Next nX

return

&& Soma determinada quantidade de dias uteis a uma data
&& Retorna a data valida
Method SomaUtil(dData,nDias) Class Boleto
	
	For nX := 1 to nDias
		//::cProtesto := DataValida(Soma1(dData),.T.)
		::cProtesto := DataValida(dData+1,.T.)
	Next nX

return (::cProtesto)