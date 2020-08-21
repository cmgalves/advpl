#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF200VAR   บAutor  ณ Paulo Romualdo     บ Data ณ  16/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ O ponto de entrada F200VAR do CNAB a receber sera executadoบฑฑ
ฑฑบ          ณ apos carregar os dados do arquivo de recepcao bancaria e   บฑฑ
ฑฑบ          ณ sera utilizado para alterar os dados recebidos.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFIN                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  
User Function F650VAR()

    local	xcOcorren	:=	''

	xnValSolBx	:=	superGetMV("MB_SOLICBX", ,2.17)
	xcOcorren	:=	allTrim(PARAMIXB[01,14])


/*
			//?????????????????
			//?o array aValores ir? permitir ?
			//?que qualquer exce??o ou neces-?
			//?sidade seja tratado no ponto  ?
			//?de entrada em PARAMIXB        ?
			//?????????????????
			// Estrutura de aValores
			//	Numero do T?ulo	- 		01
			//	data da Baixa		- 	02
			// Tipo do T?ulo		- 	03
			// Nosso Numero		- 		04
			// Valor da Despesa	- 		05
			// Valor do Desconto	- 	06
			// Valor do Abatiment- 		07
			// Valor Recebido    - 		08
			// Juros					09
			// Multa					10
			// Valor do Credito	- 		11
			// Data Credito		- 		12
			// Ocorrencia			- 	13
			// Linha Inteira		- 	14

*/

Return
