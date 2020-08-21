#INCLUDE "XMLXFUN.CH"
#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"

#define  xcR	Char(13) + Char(10)

/*/{Protheus.doc} RGUAX001
	(long_description)
	@type  Function
	@author user
	@since 16/03/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/

User Function fxImpCli
    local aVetor        :=  {}
    local lMsErroAuto   :=  .F.


    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'


    arqTrab()
    confirma()

    RESET ENVIRONMENT
Return

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 23/03/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

static function arqTrab()
    local xcQuery		:=	''

    xcQuery := xcR + 	"SELECT "
    xcQuery += xcR + 	"	* "
    xcQuery += xcR + 	"FROM "
    xcQuery += xcR + 	"	guaraniIntegraClientesProtheus "

    MemoWrite("\sql\Clientes Nao Importados ainda.SQL",xcQuery)

    if select("CLIENTES") > 0
        CLIENTES->(dbclosearea())
    endif

    TcQuery StrTran(xcQuery,xcR,"") New Alias CLIENTES

return


/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 23/03/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
static function confirma()
    DbSelectArea("CLIENTES")
    DbGotop()

    While !CLIENTES->(Eof())
        aadd(aVetor,{"A1_LOJA"      ,'01'  									,Nil}) // Nome         C 40
        aadd(aVetor,{"A1_NOME"      ,ALLTRIM(CLIENTES->NOME)				,Nil}) // Nome         C 40
        aadd(aVetor,{"A1_PESSOA"    ,CLIENTES->PESSOA						,Nil}) // Tipo         C 01 //R Revendedor
        aadd(aVetor,{"A1_NREDUZ"    ,if(EMPTY(CLIENTES->FANTASIA),CLIENTES->NOME,CLIENTES->FANTASIA)	,Nil}) // Nome reduz.  C 20
        aadd(aVetor,{"A1_END"       ,ALLTRIM(CLIENTES->ENDERECO)+", "+cvaltochar(CLIENTES->NUMERO)		,Nil}) // Endereco     C 40
        aadd(aVetor,{"A1_TIPO"      ,'R'    								,Nil}) // Tipo         C 01 //R Revendedor
        aadd(aVetor,{"A1_EST"       ,CLIENTES->EST							,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_COD_MUN"   ,CLIENTES->CODMUN						,Nil}) // Cidade       C 15
        aadd(aVetor,{"A1_BAIRRO"    ,ALLTRIM(CLIENTES->BAIRRO)				,Nil}) // Endereco     C 40
        aadd(aVetor,{"A1_CEP"       ,STRTRAN(CLIENTES->CEP,"-","")			,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_COMPL"     ,ALLTRIM(CLIENTES->COMPLEMENTO)			,Nil}) // Endereco     C 40
        aadd(aVetor,{"A1_CGC"  	 	,CLIENTES->CGCCPF						,Nil}) // Tipo         C 01 //R Revendedor
        aadd(aVetor,{"A1_INSCR"  	,CLIENTES->INSCR						,Nil}) // Tipo         C 01 //R Revendedor
        aadd(aVetor,{"A1_EMAIL"     ,CLIENTES->EMAIL    					,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_ZZMAIL2"   ,CLIENTES->EMAIL    					,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_DDD"     	,CLIENTES->DDD							,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_TEL"     	,CLIENTES->TEL							,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_VEND"     	,ALLTRIM(CLIENTES->CLI_REPRESENTANTE)	,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_TRANSP"    ,CLIENTES->TRANSP						,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_ZZTPBOL"   ,'2'									,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_ZZTXBOL"   ,'2'									,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_CONTRIB"   ,CLIENTES->CONTNAC						,Nil})  // se ï¿½ simples nacional ou contribuinte
        aadd(aVetor,{"A1_SIMPNAC"   ,CLIENTES->CONTNAC						,Nil})  // se ï¿½ simples nacional ou contribuinte
        aadd(aVetor,{"A1_ZZSITLL"   ,'001'									,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_ZZOBS"		,CLIENTES->OBSGERAL						,Nil})  // ObservaÃ§Ãµes do guarany
        aadd(aVetor,{"A1_CALCSUF"   ,'N'									,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_TPESSOA"   ,'CI'									,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_MSBLQL"	,'2'									,Nil})  // Estado       C 02
        aadd(aVetor,{"A1_REGIAO"	,CLIENTES->REGIAO						,Nil})  // RegiÃ£o do cliente
        aadd(aVetor,{"A1_ZZPERFI"	,CLIENTES->RAMO							,Nil})  // Ramo de atividades       C 02
        aadd(aVetor,{"A1_XCODGUA"	,CLIENTES->CODGUARANI					,Nil})  // Ramo de atividades       C 02
        aadd(aVetor,{"A1_XPREDIO"	,CLIENTES->PREDIO						,Nil})  // Ramo de atividades       C 02
        aadd(aVetor,{"A1_XREDE"		,CLIENTES->REDE							,Nil})  // Ramo de atividades       C 02
        aadd(aVetor,{"A1_XQTLOJA"	,CLIENTES->LOJAS						,Nil})  // Ramo de atividades       C 02
        aadd(aVetor,{"A1_XCHOUTS"	,CLIENTES->XCOUTS						,Nil})  // Ramo de atividades       C 02
        aadd(aVetor,{"A1_XQTFUNC"	,CLIENTES->FUNCS						,Nil})  // Ramo de atividades       C 02
        MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //Inclusao

        if (!IsBlind())
            if lMsErroAuto
                MostraErro()
            endif
        else
            TCSPEXEC("guaraniIncluiReferenciasClientes")
        endif

        CLIENTES->(DbSkip())
    EndDo
    CLIENTES->(DbCloseArea())
Return

    #include "rwmake.ch"
    #include "tbiconn.ch"
User Function MostraErro()
    Local aCabec := {}
    Local aItens := {}
    Local aLinha := {}
    Local nX     := 0
    Local nY     := 0
    Local cDoc   := ""
    Local lOk    := .T.
    PRIVATE lMsErroAuto := .F.
    Private lMsHelpAuto	:= .T.
    Prepare Environment Empresa "01" Filial "01" Modulo "FAT"

    aVetor:= {
    {"B1_COD"     ,"005",Nil},;
        {"B1_DESC"    ,"Teste"        ,Nil},;
        {"B1_UM"      ,"UN"           ,Nil},;
        {"B1_LOCPAD"  ,"01"           ,Nil}}

    MATA010(aVetor,3)
    If !lMsErroAuto
        ConOut("Incluido com su cesso! "+cDoc)
    Else	// será apresentada a janela de erro, pois não foram passados todos os campos obrigatórios da tabela SB1.
        ConOut("Erro na inclusao !")
        MostraErro()
    EndIf
Return
