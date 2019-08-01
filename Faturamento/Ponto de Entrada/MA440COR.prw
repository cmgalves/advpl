#Include "Protheus.ch"
User Function MA440COR
Local aCores := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'ENABLE' },;		//Pedido em Aberto
			{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE'},;		   	//Pedido Encerrado
			{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)",'BR_AMARELO'},;
			{ "C5_BLQ == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
			{ "C5_BLQ == '2'",'BR_LARANJA'},; //Pedido Bloquedo por verba
			{ "C5_BLQ == '3'",'BR_PRETO'}}	//Pedido Bloquedo por Doação Bonificação
			
Return(aCores)
