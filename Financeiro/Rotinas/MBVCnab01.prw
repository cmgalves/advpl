#include "rwmake.ch"     
 

/*
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������͹��
���Programa �MBVCNAB01 �Autor� Leandro P. Cama�ari Gomes �Data � 04/10/2010.                                                                                                           ���
��������������������������������������������������������������������������������������������������������������͹��
��Desc.     �   Programa: Envio do Arquivo Cnab para o Banco, fazendo o tratamento do Valor do 'T�tulo          ��                                                  ���
���============================================================================================================���
���          �   01 - Rotina Respons�vel por Acrescentar R$1,50 ao Valor do T�tulo enviado ao Banco                                                                                    ���    
���============================================================================================================���
���          �                                                                                                                                                                                                                                                   ���
��������������������������������������������������������������������������������������������������������������͹��
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
*/


User Function MBVCNAB01()

    //Se cobrar a taxa do boleto do Cliente o ZZTXBOL = "1"
    //Neste caso o valor era fixo colocando 1.50, mas depois criamos um Campo EE_ZZTXBOL para buscar o valor desse campo. 
	IF SA1->A1_ZZTXBOL="1"
	   //_ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC+1.50)*100),13)          
	  _ret := STRZERO(INT((SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC)+SEE->EE_ZZTXBOL)*100),13)      
	  
	  //Ap�s fazer o processo acima, ele ir� gravar o valor do Campo EE_ZZTXBOL no campo E1_ZZTXBOL
		//AS LINHAS ABAIXO FORAM COMENTADAS POIS O CAMPO SEE->EE_ZZTXBOL NUNCA � PREENCHIDO AUTOMATICAMENTE
		//PARA O CORRETO FUNCIONAMENTO DA QUEST�O, FOI CRIADO O P.E. M040SE1
	  //RecLock("SE1",.F.)
      //SE1->E1_ZZTXBOL := SEE->EE_ZZTXBOL
      //MsUnlock()    
	                                                                                                                                                                                                                            	  
	ELSE
		_ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC)*100),13)       
	ENDIF          
	

Return _ret

