*** Settings ***

Library    SeleniumLibrary
Library    ImageHorizonLibrary
    
Resource    ../../querysDB/tabelaPedidoAprovacao.robot
Resource    ../../querysDB/tabelaPedido.robot
Resource    ../../variables/web/pedidoAprovacaoVariables.robot

*** Keywords ***

Gerar link aprovação
    [Arguments]    ${siglaAprovacao}    ${numeroPedido}    ${idUsuario}
    [Documentation]    keyword reponsavel por montar o link de aprovação ou reprovação 

    ${idPedido}          Consultar idPedido na tabela pedido, buscando pelo numero pedido     ${numeroPedido} 

    ${chaveAprovacao}    Consultar chave de aprovacão na tabelaPedidoAprovacao    ${idPedido}

    ${Link}    Catenate     http://stack03.qasustentacao.wssim.com.br:8080/aa_old/consulta/pedido.mudaStatus.ws?status=
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

    Press Combination    Key.CTRL    Key.T 

    ${handles}=  Get Window Handles

    Sleep     10s

    Switch Window   ${handles}[1]    10s

    Go To    ${Link}

    Verificar se o status que aparece no link é o esperado     ${siglaAprovacao} 



Verificar se o status que aparece no link é o esperado 
    [Arguments]    ${siglaAprovacao} 

    Wait Until Page Contains Element    ${linkAprovacao.status}    timeout=10s

    ${statusPedido}    Get Text    ${linkAprovacao.status} 


    IF    '${siglaAprovacao}' == 'AP'
        Run Keyword If    '${statusPedido}' != 'Situação: APROVADO'
        ...    Fail
    END


    IF    '${siglaAprovacao}' == 'RP'
        Run Keyword If    '${statusPedido}' != 'Situação: REPROVADO'
        ...    Fail
    END