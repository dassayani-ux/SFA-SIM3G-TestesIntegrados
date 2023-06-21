*** Settings ***
  
Library    DatabaseLibrary
Library    String

Resource    basic.robot

*** Keywords ***


Consultar idPedido na tabela pedido, buscando pelo numero pedido
    [Arguments]     ${numeroPedido} 
    Connect
    
    ${Query}      Catenate     select idPedido from pedido where numeropedidousuario = '${numeroPedido}';
    
    ${responseQuery}    Query    selectStatement=${Query}

    [Return]    ${responseQuery[0][0]} 

    Disconnect