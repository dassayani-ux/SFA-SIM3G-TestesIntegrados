*** Settings ***
  
Library    DatabaseLibrary
Library    String

Resource    basic.robot

*** Keywords ***


Consultar chave de aprovacão na tabelaPedidoAprovacao
    [Arguments]     ${idPedido}
    Connect
    
    ${Query}      Catenate     select chave from pedidoaprovacao where idPedido =    ${idPedido}    ;
    
    ${responseQuery}    Query    selectStatement=${Query}

    [Return]    ${responseQuery[0][0]} 

    Disconnect