#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PMBCADTR � Autor � Cassiano G. Ribeiro� Data �  01/06/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de tributacao do Lucro Liquido.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P10-PMB                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PMBCADTR()

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Tributa��o do LL",cVldExc,cVldAlt)

Return