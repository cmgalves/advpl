#include "rwmake.ch"

User Function MA410LEG

_aCores := {	{"ENABLE"     ,"Pedido de Venda em Aberto"},;
				{"DISABLE"    ,"Pedido de Venda Encerrado"},;
				{"BR_AMARELO" ,"Pedido de Venda Liberado"},;
				{"BR_AZUL"    ,"Pedido de Venda com Bloqueio de regra"},;
				{"BR_LARANJA" ,"Pedido de Venda com Bloqueio de verba"},;
				{"BR_PRETO"   ,"Pedido de Venda com Bloqueio de Bonif/Doação"}}

Return(_aCores)