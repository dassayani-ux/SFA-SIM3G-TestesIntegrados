*** Settings ***

Library    SeleniumLibrary

Resource    ../pedido/ListagemPedidosResource.robot
Resource    ../../../variables/web/pedido/pedidoAprovacaoVariables.robot

*** Keywords ***
Verificar se na web exibe o status de aprovação por usuario
    [Arguments]    ${NUMERO PEDIDO FINAL}    ${nomeUserAprovador}    ${siglaStatus}

    ${handles}=  Get Window Handles

    Switch Window   ${handles}[0]    10s
    
    Localizar pedido pelo campo pesquisa rápida    ${NUMERO PEDIDO FINAL}

    Verificar se gerou aprovação 

    Abrir tela de aprovadores

    Verificar o status da aprovação por usuário na web    ${nomeUserAprovador}    ${siglaStatus}



Abrir tela de aprovadores 
    Click Element    ${aprovacao.btn_aprovadores}
    
    Wait Until Page Contains Element       ${dialogAprovadores.nome}       25s



Verificar o status da aprovação por usuário na web
    [Documentation]    Keyword que verifica se o status na aplicação web aparece de acordo com o que deveria 
    [Arguments]    ${nomeUserAprovador}    ${siglaStatus}

    ${elementoNome}   Get Text    ${dialogAprovadores.nome}

    ${elementoStatus}  Get Text     ${dialogAprovadores.status}

    IF    '${siglaStatus}' == 'AP'
        Run Keyword If    '${elementoNome}' != '${nomeUserAprovador}' and '${elementoStatus}' != 'Situação: APROVADO'
        ...    Fail
    END

    IF    '${siglaStatus}' == 'RP'
        Run Keyword If    '${elementoNome}' != '${nomeUserAprovador}' and '${elementoStatus}' != 'Situação: REPROVADO'
        ...    Fail
    END

    
Verificar se o pedido está com a situação reprovado
    ${handles}=  Get Window Handles

    Switch Window   ${handles}[0]    10s

    Abrir dialog de aprovacao

    ${situacao}    Get text    ${aprovacao.campoSituacao}

    IF    '${situacao}' != 'REPROVADO'
        Fail
    END
    