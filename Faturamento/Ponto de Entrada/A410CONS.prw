#include "RWMAKE.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A410CONS  �Autor  �Claudio Alves       � Data �  20/03/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     �Libera��o de Pedidos                                        ���
���          �                                                            ���	
�������������������������������������������������������������������������͹��
���Uso       �SIGAFAT                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function A410CONS()

Local aBotoes:={}

AAdd(aBotoes,{ "NOTE", {|| Processa({|| U_MBRFAT01("DIRETO")},"Dados do Pedido","Processando...") }, "Impress�o Pedido" } )
AAdd(aBotoes,{ "NOTE", {|| Processa({|| U_xfItemPed('REFAZ','')},"Dados do Pedido","Processando...") }, "Refaz Valores" } )
//--AAdd(aBotoes,{ "NOTE", {|| Processa({|| U_MBRFAT01("DIRETO")},"Dados do Pedido","Processando...") }, "Impress�o Pedido 2" } )

Return(aBotoes)	
