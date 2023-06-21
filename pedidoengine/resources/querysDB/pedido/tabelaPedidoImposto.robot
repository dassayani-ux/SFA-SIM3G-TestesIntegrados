*** Settings ***
  
Library    DatabaseLibrary
Library    String

Resource    ../basicas/sqlsBasicas.robot
Resource    tabelaPedidoProduto.robot

*** Keywords ***


Deletar os registros de impostos diferente dos de fachada da tabela pedidoImposto
    [Arguments]     ${ID_PEDIDO}    ${CODIGO_PRODUTO}
    
    ${ID_PEDIDO_PRODUTO}    Consultar idPedidoProduto na tabela pedidoProduto, buscando pelo codigo do produto e idpedido    ${ID_PEDIDO}    ${CODIGO_PRODUTO}    
    Connect
    ${Query}      Catenate     delete from pedidoimposto where idpedido = ${ID_PEDIDO} and idpedidoproduto = ${ID_PEDIDO_PRODUTO} 
                            ...    and idimposto not in (select idimposto from imposto where sglimposto in ('VLMERCLIQ', 'VLTOTITEM'));
    Execute Sql String    ${Query}
    Disconnect