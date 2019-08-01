//058779
#Include "Topconn.ch"
#INCLUDE "RWMAKE.CH"

//NUMERAÇÃO AUTOMÁTICA DO CLIENTE
User Function numSa1()
local retProced	:=	{}


//GETSXENUM("SA1","A1_COD")                                                                                                       
retProced := TCSPEXEC("sp_numeracaoClientes",  'OK')

Return(retProced[1])

//NUMERAÇÃO AUTOMÁTICA DA TRASNPORTADORA
User Function numSA4()
local retProced	:=	{}


//GETSXENUM("SA4","A4_COD")                                                                                                                                                                                                         
retProced := TCSPEXEC("sp_numeracaoTransp",  'OK')

Return(retProced[1])



User Function numAob()
local retProced	:=	{}


//GETSXENUM("SA1","A1_COD")                                                                                                       
retProced := TCSPEXEC("sp_numeracaoAnotacoes",  'OK')

Return(retProced[1])



//função para retornar o último numero do RH
User Function numSra()
local retProced	:=	{}


//GETSXENUM("SA1","A1_COD")                                                                                                       
retProced := TCSPEXEC("sp_numeracaoFuncionarios",  'OK')

Return(retProced[1])

