#include "rwmake.ch"     
 

/*
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯屯凸北
北篜rograma 矼BVCRET01 篈utor� Leandro P. Cama鏰ri Gomes 篋ata � 04/10/2010.                                   贡�                                                                       罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯屯凸北
焙Desc.     �   Programa: Retorno do Arquivo Cnab do Banco, fazendo o tratamento do Valor do T韙ulo             北                                                  罕�
北�============================================================================================================罕�
北�          �   01 - Rotina Respons醰el por Subtrair R$1,50 ao Valor do T韙ulo retornado do Banco             罕�                                                                           罕�    
北�============================================================================================================罕�
北�          �                                                                                                 罕�                                                                                                                                                  罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯贤贤屯屯屯凸北
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
*/


User Function MBVCRET01()   

	IF SA1->A1_ZZTXBOL="1"
	   _ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC-1.51)*100),13)     
	ELSE
		_ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC)*100),13)   
	ENDIF
		

Return _ret

