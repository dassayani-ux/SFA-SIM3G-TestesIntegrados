*** Settings ***

Resource    ../../../querysDB/operacao/tabelaOperacaoSegmento.robot
Resource    ../../../querysDB/pedido/tabelaPedidoImposto.robot
Resource    ../../../querysDB/pedido/tabelaPedido.robot
Resource    ../../../querysDB/pedido/tabelaPedidoProduto.robot

*** Keywords ***

Desfazer vinculo com operação que faz o calculo de imposto automaticamente
    [Arguments]    ${CODIGO_SEGMENTO}

    ${status}    Run Keyword And Return Status    Consultar idOperacaoSegmento na tabela operacaoSegmento, buscando pelo idSegmento e idOperacao   ${CODIGO_SEGMENTO}    CALCIMCAUT 
    Run Keyword If    ${status}==True    Deletar registro da tabela operacaoSegmento    ${CODIGO_SEGMENTO}    CALCIMCAUT


Inserir o vinculo com operação que faz o calculo de imposto automaticamente
    [Arguments]    ${CODIGO_SEGMENTO}

    ${status}    Run Keyword And Return Status    Consultar idOperacaoSegmento na tabela operacaoSegmento, buscando pelo idSegmento e idOperacao   ${CODIGO_SEGMENTO}    CALCIMCAUT 
    Run Keyword If    ${status}==False    Inserir registro na tabela operacaoSegmento    ${CODIGO_SEGMENTO}    CALCIMCAUT



Deletar vinculo entre um produto de um pedido na tabela pedidoImposto 
    [Arguments]    ${NUMERO_PEDIDO}    ${CODIGO_PRODUTO}

    ${ID_PEDIDO}    Consultar idPedido na tabela pedido, buscando pelo numero pedido    ${NUMERO_PEDIDO}   
    Log     ${ID_PEDIDO}
    Run Keyword If    ${ID_PEDIDO}!=${None}   Deletar os registros de impostos diferente dos de fachada da tabela pedidoImposto    ${ID_PEDIDO}   ${CODIGO_PRODUTO} 