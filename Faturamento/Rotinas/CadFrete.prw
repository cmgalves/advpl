#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CadFrete  � Autor � AP6 IDE            � Data �  16/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CadFrete()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

/*Private cCadastro := "Cadastro de Porcentagem do Frete"
Private aRotina := {	{"Pesquisar"	,"AxPesqui",0,1} ,;
		            	{"Visualizar"	,"AxVisual",0,2} ,;
       		      		{"Incluir"		,"AxInclui",0,3} ,;
           			  	{"Alterar"		,"AxAltera",0,4} ,;
             			{"Excluir"		,"AxDeleta",0,5} }
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZ1"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString)*/

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Porcentagem de Frete",cVldExc,cVldAlt)

Return
