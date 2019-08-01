#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"


User Function MBcalccm()
	local lCPParte := .F. 
	local lBat := .T. 
	local aListaFil := {}
	local aParAuto := {} 
	local dRet 		:=	ctod('  /  /    ')

	
	Prepare Environment EMPRESA '01' FILIAL '01' MODULO "EST" TABLES "AF9","SB1","SB2","SB3","SB8","SB9","SBD","SBF","SBJ","SBK","SC2","SC5","SC6","SD1","SD2","SD3","SD4","SD5","SD8","SDB","SDC","SF1","SF2","SF4","SF5","SG1","SI1","SI2","SI3","SI5","SI6","SI7","SM2","ZAX","SAH","SM0","STL"


	dRet := iif(dDataBase < LastDay(superGetMV('MV_ULMES')  + 1), dDataBase, LastDay(superGetMV('MV_ULMES')  + 1))

	aParAuto := {dRet, 2, 1, 1, 0, 2, "  " , "  " , 1, 3, 2, 3, 1, 2, 1, 1, 2, 1, 2, 2, 2} //21 parametros

/*
	Data Limite Final : 						"15/07/2019"  
	Mostra Lancamentos contábeis: "2" = 		Não  
	Aglutina Lancamentos contábeis: "1" = 		Sim  
	Atualizar Arq de Movimentos: "1"  = 		Sim
	% Aumento de MDO : 							"0"  
	Centro de Custo : "2"  = 					ExtraContábil
	Conta contábil a inibir de  : 				"        "  
	Conta contábil a inibir Até  : 				"        "  
	Apagar Estornos : "1"  = 					Sim
	Gerar Lançamento Contábil : "3"  = 			Manter Lançamentos
	Gerar estrutura pela movimentação : "2"  = 	Não
	Contabilização online por : "3"  = 			ambas
	Calcula MDO? : "1"  = 						Sim
	Metodo de apropriação : "2"  = 				Mensal
	Racalcula niveis na estrutura : "1"  = 		Sim
	mostra sequencia dos calculos : "1"  = 		Não Mostrar
	Seq Processamento FIFO : "2"  = 			Custo Médio
	Movimentos Internos Valorizados : "1"  = 	Antes
	Recalcula Custos dos Transportes : "2"  =	Não
	Calculo de custo por : "2"  =				Filial Corrente
	Calcular custos em partes : "2"  = 			Não
*/


	

	Conout(time() + " -- > Início da execução do MBcalccm")
	Conout('dRet, 2, 2, 1, 0, 2, "  " , "  " , 1, 3, 2, 3, 1, 2, 1, 1, 2, 1, 2, 2, 2')
	

	//-- Adiciona filial a ser processada
	Aadd(aListaFil,{.T.,'01','Matriz','00570834000132',.F.,})


	MATA330(lBat,aListaFil,lCPParte, aParAuto)

	

	ConOut(time() + " -- > Término da execução do MBcalccm")

Return
