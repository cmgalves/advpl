#INCLUDE "PROTHEUS.CH"

User Function F010CQTA()
    Local cQuery := paramixb [1]

    cQuery := 'SELECT * FROM VW_FINANCEIRORECEBERTITULOSABERTOS'

    /*
    cQuery := "SELECT E1_FILIAL, E1_FILORIG, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_EMISSAO,
    cQuery += "E1_VENCTO, E1_BAIXA, E1_VENCREA, E1_VALOR, E1_VLCRUZ, E1_SDACRES, E1_SDDECRE,
    cQuery += "E1_VALJUR, E1_SALDO, E1_NATUREZ, E1_PORTADO, E1_NUMBCO, E1_NUMLIQ, E1_HIST,
    cQuery += "E1_CHQDEV, E1_PORCJUR, E1_MOEDA, E1_VALOR, E1_TXMOEDA, E1_NFELETR, E1_SITUACA, SE1.R_E_C_N_O_ SE1RECNO, SX5.X5_DESCRI

    cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
    cQuery += RetSqlName("SX5")+" SX5 "
    cQuery += "WHERE SE1.E1_FILIAL = '01' AND "
    cQuery += "SE1.E1_CLIENTE = '1 'AND "
    cQuery += "SE1.E1_EMISSAO >= '20130101'AND "
    cQuery += "SE1.E1_EMISSAO <= '20131231'AND "
    cQuery += "SE1.E1_VENCREA >= '20130101'AND "
    cQuery += "SE1.E1_VENCREA <= '20131231'AND "
    cQuery += "SE1.E1_TIPO <> 'PR ' AND "
    cQuery += "SE1.E1_TIPO <> 'RA ' AND "
    cQuery += "SE1.E1_PREFIXO >= ' ' AND "
    cQuery += "SE1.E1_PREFIXO <= 'ZZZ' AND "
    cQuery += "SE1.E1_SALDO > 0 AND "
    cQuery += "SE1.E1_TIPOLIQ = ' ' AND "
    cQuery += "SE1.E1_NUMLIQ = ' ' AND "
    cQuery += "SE1.D_E_L_E_T_ <> '*'AND "
    cQuery += "SX5.X5_FILIAL = ' ' AND "
    cQuery += "SX5.X5_TABELA = '07' AND "
    cQuery += "SX5.X5_CHAVE = SE1.E1_SITUACA AND "
    cQuery += "SX5.D_E_L_E_T_ <> '*' AND "
    cQuery += "SE1.E1_TIPO NOT LIKE '__-' "
    Alert ("Seguem as informações que são levadas para Query"+cQuery)
    */
Return cQuery