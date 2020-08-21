//058779
#Include "Topconn.ch"
#INCLUDE "RWMAKE.CH"

//NUMERAÇÃO AUTOMÁTICA DO CLIENTE
User Function numSa1()
local retProced	:=	{}


//GETSXENUM("SA1","A1_COD") 
retProced := TCSPEXEC("sp_numeracaoClientes", 'OK')

Return(retProced[1])

//NUMERAÇÃO AUTOMÁTICA DA TRASNPORTADORA
User Function numSA4()
local retProced	:=	{}


//GETSXENUM("SA4","A4_COD") 
retProced := TCSPEXEC("sp_numeracaoTransp", 'OK')

Return(retProced[1])



User Function numAob()
local retProced	:=	{}


//GETSXENUM("SA1","A1_COD") 
retProced := TCSPEXEC("sp_numeracaoAnotacoes", 'OK')

Return(retProced[1])



//função para retornar o último numero do RH
User Function numSra()
local retProced	:=	{}


//GETSXENUM("SA1","A1_COD") 
retProced := TCSPEXEC("sp_numeracaoFuncionarios", 'OK')

Return(retProced[1])


//NUMERAÇÃO AUTOMÁTICA DO CLIENTE
User Function numSa2()
local retProced	:=	{}


//GETSXENUM("SA2","A2_COD") 
retProced := TCSPEXEC("sp_numeracaoFornecedores", 'OK')

Return(retProced[1])

//NUMERAÇÃO AUTOMÁTICA DO PEDIDO
User Function numSC5()
local retProced	:=	{}


//GetSXENum("SC5","C5_NUM") 
retProced := TCSPEXEC("sp_numeracaoPedidos", 'OK')

Return(retProced[1])

