#include "rwmake.ch"     
 

/*
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯屯凸北
北篜rograma 矼BVCNAB01 篈utor� Leandro P. Cama鏰ri Gomes 篋ata � 04/10/2010.                                                                                                           罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯屯凸北
焙Desc.     �   Programa: Envio do Arquivo Cnab para o Banco, fazendo o tratamento do Valor do 'T韙ulo          北                                                  罕�
北�============================================================================================================罕�
北�          �   01 - Rotina Respons醰el por Acrescentar R$1,50 ao Valor do T韙ulo enviado ao Banco                                                                                    罕�    
北�============================================================================================================罕�
北�          �                                                                                                                                                                                                                                                   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯屯凸北
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
*/


User Function MBVCNAB01()

    //Se cobrar a taxa do boleto do Cliente o ZZTXBOL = "1"
    //Neste caso o valor era fixo colocando 1.50, mas depois criamos um Campo EE_ZZTXBOL para buscar o valor desse campo. 
	IF SA1->A1_ZZTXBOL="1"
	   //_ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC+1.50)*100),13)          
	  _ret := STRZERO(INT((SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC)+SEE->EE_ZZTXBOL)*100),13)      
	  
	  //Ap髎 fazer o processo acima, ele ir� gravar o valor do Campo EE_ZZTXBOL no campo E1_ZZTXBOL
		//AS LINHAS ABAIXO FORAM COMENTADAS POIS O CAMPO SEE->EE_ZZTXBOL NUNCA � PREENCHIDO AUTOMATICAMENTE
		//PARA O CORRETO FUNCIONAMENTO DA QUEST肙, FOI CRIADO O P.E. M040SE1
	  //RecLock("SE1",.F.)
      //SE1->E1_ZZTXBOL := SEE->EE_ZZTXBOL
      //MsUnlock()    
	                                                                                                                                                                                                                            	  
	ELSE
		_ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC)*100),13)       
	ENDIF          
	

Return _ret

