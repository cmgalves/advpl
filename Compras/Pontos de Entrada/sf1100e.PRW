#include "Protheus.ch"
#include "rwmake.ch"

User Function sf1100e()
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SF1100E   � Autor � Cassiano G. Ribeiro   � Data �15/06/10  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ponto entrada disparado na confirmacao da nota de entrada,  ���
���          �antes da exclusao dos arquivos. Esta rotina tem por objetivo���
���          �deletar as mensagens do SZZ geradas pelo ponto de entrada   ���
���          �GQREENTR.                                                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SigaCom                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Salva areas abertas                                          �
//����������������������������������������������������������������
Local _aArea    := GetArea()
Local _aAreaSZZ := SZZ -> (GetArea ())

dbSelectArea("SZZ")
dbSetOrder(1)
dbSeek (xFilial ("SZZ") + "E" + SF1 -> F1_DOC + SF1 -> F1_SERIE + SF1 -> F1_FORNECE + SF1 -> F1_LOJA)
If Found()
	While SZZ->(!eof()) .and. SZZ -> ZZ_FILIAL   == xFilial("SZZ");
				  .and. SZZ -> ZZ_TIPODOC == "E";
	              .and. SF1 -> F1_DOC     == SZZ -> ZZ_DOC ;
                  .and. SF1 -> F1_SERIE   == SZZ -> ZZ_SERIE ;
	              .and. SF1 -> F1_FORNECE == SZZ -> ZZ_CLIFOR ;
	              .and. SF1 -> F1_LOJA    == SZZ -> ZZ_LOJA 
 		RecLock("SZZ",.F.)
			SZZ->(dbDelete()) 
		MsUnlock()
		SZZ->(dbSkip())
	End
EndIf

//��������������������������������������������������������������Ŀ
//� Restaura Areas Abertas                                       �
//����������������������������������������������������������������
RestArea (_aAreaSZZ)
RestArea (_aArea)

Return .T.

//��������������������������������������������������������������Ŀ
//�                             F I M                            �
//����������������������������������������������������������������

