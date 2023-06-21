*** Settings ***
  
Library    DatabaseLibrary
Library    String

Resource    ../basicas/sqlsBasicas.robot

*** Keywords ***

Consultar idPedidoProduto na tabela pedidoProduto, buscando pelo codigo do produto e idpedido
    [Arguments]     ${ID_PEDIDO}    ${CODIGO_PRODUTO}

    Connect
    ${Query}      Catenate     select idpedidoproduto from pedidoproduto where idpedido = ${ID_PEDIDO} and idproduto in (select idproduto from produto where codigo = '${CODIGO_PRODUTO}');
    ${responseQuery}    Query    selectStatement=${Query}
    [Return]    ${responseQuery[0][0]} 
    Disconnect
