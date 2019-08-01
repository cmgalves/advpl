#include "rwmake.ch"     
 

/*
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma ³MBVCNAB01 ºAutor³ Leandro P. Camaçari Gomes ºData ³ 04/10/2010.                                                                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±ºDesc.     ³   Programa: Envio do Arquivo Cnab para o Banco, fazendo o tratamento do Valor do 'Título          ±±                                                  º±±
±±º============================================================================================================º±±
±±º          ³   01 - Rotina Responsável por Acrescentar R$1,50 ao Valor do Título enviado ao Banco                                                                                    º±±    
±±º============================================================================================================º±±
±±º          ³                                                                                                                                                                                                                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
*/


User Function MBVCNAB01()

    //Se cobrar a taxa do boleto do Cliente o ZZTXBOL = "1"
    //Neste caso o valor era fixo colocando 1.50, mas depois criamos um Campo EE_ZZTXBOL para buscar o valor desse campo. 
	IF SA1->A1_ZZTXBOL="1"
	   //_ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC+1.50)*100),13)          
	  _ret := STRZERO(INT((SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC)+SEE->EE_ZZTXBOL)*100),13)      
	  
	  //Após fazer o processo acima, ele irá gravar o valor do Campo EE_ZZTXBOL no campo E1_ZZTXBOL
		//AS LINHAS ABAIXO FORAM COMENTADAS POIS O CAMPO SEE->EE_ZZTXBOL NUNCA É PREENCHIDO AUTOMATICAMENTE
		//PARA O CORRETO FUNCIONAMENTO DA QUESTÃO, FOI CRIADO O P.E. M040SE1
	  //RecLock("SE1",.F.)
      //SE1->E1_ZZTXBOL := SEE->EE_ZZTXBOL
      //MsUnlock()    
	                                                                                                                                                                                                                            	  
	ELSE
		_ret := STRZERO(INT(SE1->(E1_SALDO-E1_DECRESC+E1_ACRESC)*100),13)       
	ENDIF          
	

Return _ret

