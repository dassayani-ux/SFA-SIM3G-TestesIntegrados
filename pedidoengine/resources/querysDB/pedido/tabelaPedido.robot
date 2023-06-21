*** Settings ***
  
Library    DatabaseLibrary
Library    String

Resource    ../basicas/sqlsBasicas.robot

*** Keywords ***


Consultar idPedido na tabela pedido, buscando pelo numero pedido usuario
    [Arguments]     ${numeroPedido} 
    Connect
    ${Query}      Catenate     select idPedido from pedido where numeropedidousuario = '${numeroPedido}';
    ${responseQuery}    Query    selectStatement=${Query}
    [Return]    ${responseQuery[0][0]} 
    Disconnect

Consultar idPedido na tabela pedido, buscando pelo numero pedido
    [Arguments]     ${numeroPedido} 
    Connect
    ${Query}      Catenate     select idPedido from pedido where numeropedido = '${numeroPedido}';
    ${responseQuery}    Query    selectStatement=${Query}
    [Return]    ${responseQuery[0][0]} 
    Disconnect