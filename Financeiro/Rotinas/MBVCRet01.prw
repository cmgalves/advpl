#include "rwmake.ch"     
 

/*
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������͹��
���Programa �MBVCRET01 �Autor� Leandro P. Cama�ari Gomes �Data � 04/10/2010.                                   ���                                                                       ���
��������������������������������������������������������������������������������������������������������������͹��
��Desc.     �   Programa: Retorno do Arquivo Cnab do Banco, fazendo o tratamento do Valor do T�tulo             ��                                                  ���
���============================================================================================================���
���          �   01 - Rotina Respons�vel por Subtrair R$1,50 ao Valor do T�tulo retornado do Banco             ���                                                                           ���    
���============================================================================================================���
���          �                                                                                                 ���                                                                                                                                                  ���
��������������������������������������������������������������������������������������������������������������͹��
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
*/


User Function MBVCRET01()   

	IF SA1->A1_ZZTXBOL="1"
	   _ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC-1.51)*100),13)     
	ELSE
		_ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC)*100),13)   
	ENDIF
		

Return _ret

