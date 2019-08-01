#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMBCADFX  �Autor  �Cassiano G. Ribeiro � Data �  08/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Faixas de Desconto de Vendas.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P10-MB                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PMBCADFX()
    Local aArea  := GetArea()
	Local cQry 	 := ""
	Local cAlias := "SZ2"

	Private cCadastro 	:= 	"Faixas de Desconto de Vendas"
	Private aRotina 	:= 	{}
	
	aAdd( aRotina , { "Pesquisar" 		, "PesqBrw"			, 0 , 1 } )
	aAdd( aRotina , { "Visualizar"		, "U_PMBFDESC(1)"	, 0 , 2 } )
	aAdd( aRotina , { "Incluir"  		, "U_PMBFDESC(3)"	, 0 , 3 } )
	aAdd( aRotina , { "Alterar"  		, "U_PMBFDESC(4)"	, 0 , 4 } )
	aAdd( aRotina , { "Excluir"  		, "U_PMBFDESC(5)"	, 0 , 5 } )
	
	DbSelectArea(cAlias)
	DbSetOrder(1)
	DbGotop()
	
	mBrowse(06,01,22,75,cAlias)
	
	RestArea(aArea)
Return