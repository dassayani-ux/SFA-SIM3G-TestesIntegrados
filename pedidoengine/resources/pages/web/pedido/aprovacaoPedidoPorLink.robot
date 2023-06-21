*** Settings ***

Library    SeleniumLibrary
Library    ImageHorizonLibrary
    
Resource    ../../../querysDB/pedido/tabelaPedidoAprovacao.robot
Resource    ../../../querysDB/pedido/tabelaPedido.robot
Resource    ../../../variables/web/pedido/pedidoAprovacaoVariables.robot
Resource    ../../../variables/web/global/globalVariables.robot

*** Keywords ***

Gerar link aprovação
    [Arguments]    ${siglaAprovacao}    ${numeroPedido}    ${idUsuario}
    [Documentation]    keyword reponsavel por montar o link de aprovação ou reprovação 

    ${idPedido}          Consultar idPedido na tabela pedido, buscando pelo numero pedido usuario     ${numeroPedido} 

    ${chaveAprovacao}    Consultar chave de aprovacão na tabelaPedidoAprovacao    ${idPedido}

    ${Link}    Catenate     ${URL}
    ${Link}    Catenate     ${Link}consulta/pedido.mudaStatus.ws?status=
    ${Link}    Catenate     ${Link}${siglaAprovacao}
    ${Link}    Catenate     ${Link}&usuario=
    ${Link}    Catenate     ${Link}${idUsuario}    
    ${Link}    Catenate     ${Link}&chave=    
    ${Link}    Catenate     ${Link}${chaveAprovacao}    
    ${Link}    Catenate     ${Link}&idPedido=    
    ${Link}    Catenate     ${Link}${idPedido} 

    [Return]    ${Link}

Acessar link de aprovacao do pedido
    [Arguments]    ${siglaAprovacao}    ${numeroPedido}    ${idUsuario}    

    ${Link}    Gerar link aprovação    ${siglaAprovacao}    ${numeroPedido}    ${idUsuario}
    # Press Combination    Key.CTRL    Key.T 
    Execute Javascript    window.open('')
    ${handles}=  Get Window Handles
    Sleep     10s
    Switch Window   ${handles}[1]    10s
    Go To    ${Link}
    Verificar se o status que aparece no link é o esperado     ${siglaAprovacao} 


Verificar se o status que aparece no link é o esperado 
    [Arguments]    ${siglaAprovacao} 
    
    Scroll Element Into View    xpath=${linkAprovacao.status}
    Wait Until Page Contains Element    xpath=${linkAprovacao.status}    timeout=60s
    ${statusPedido}    Get Text    xpath=${linkAprovacao.status} 
    
    IF    '${siglaAprovacao}' == 'AP'
        Run Keyword If    '${statusPedido}' != 'Situação: APROVADO'
        ...    Fail
    END

    IF    '${siglaAprovacao}' == 'RP'
        Run Keyword If    '${statusPedido}' != 'Situação: REPROVADO'
        ...    Fail
    END