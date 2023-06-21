*** Settings ***

Library    SeleniumLibrary

Resource    ../../variables/web/globalVariables.robot
Resource    ../../variables/web/menuLateralVariables.robot
Resource    ../../variables/web/listaPedidosVariables.robot
Resource    ../../variables/web/pedidoAprovacaoVariables.robot

*** Keywords ***
Abrir listagem

    Wait Until Page Contains Element       ${venda.menu_venda}    timeout=50

    Click Element   ${venda.menu_venda}

    Wait Until Element Is Visible    ${venda.menu_pedido}    timeout=5s

    Click Element   ${venda.menu_pedido}

    Wait Until Element Is Visible    ${venda.pedido_listar}

    Click Element   ${venda.pedido_listar}

    Wait Until Page Contains Element   ${tituloPagina}    40s


Localizar pedido pelo campo pesquisa rápida 
    [Arguments]     ${PEDIDO}
    
    Set Selenium Speed    2s

    Clear Element Text    ${pesquisa_rapida.input_pesquisa} 
    
    Press keys    ${pesquisa_rapida.input_pesquisa}    ${PEDIDO}
    
    Click Element    ${pesquisa_rapida.button_pesquisar}

    Wait Until Element Contains     ${grid_pedidos.campo_numero_pedido}   ${PEDIDO}   timeout=50s
    
Editar Pedido
    Set Selenium Speed    2s

    Wait Until Element Is Visible    ${grid_pedidos.button_editar}
    
    Click Element    ${grid_pedidos.button_editar}


Verificar se gerou aprovação

    Abrir dialog de aprovacao


Abrir dialog de aprovacao

    Set Selenium Speed    1s

    Sleep     2s

    Wait Until Page Contains Element    xpath=${grid_pedidos.btn_aprovacao}    timeout=50s

    # Element Should Contain    ${grid_pedidos.btn_aprovacao}    /aa_testes_nova/ID_1661372862866/images/sim3g/minimalist/icons/16x16/alerta.png

    Wait For Condition        return document.readyState=="complete"

    Wait Until Element Is Enabled        ${grid_pedidos.btn_aprovacao}    20s

    Click Element    ${grid_pedidos.btn_aprovacao}


Verificar tipo Aprovação
    [Arguments]    ${tipoAprovacao}

    Element Should Contain    ${grid_pedidos.aprovacao_pendente}     ${tipoAprovacao}

    Click Element    ${aprovacao.btn_fechar}

Aprovar pedido
    [Arguments]     ${PEDIDO}

    Set Selenium Speed    1.5s

    Localizar pedido pelo campo pesquisa rápida    ${PEDIDO}

    Abrir dialog de aprovacao

    Click Element    ${aprovacao.btn_aprovar}
    
    Wait Until Element Is Enabled    ${aprovacao.btn_voltar}

    Click Element    ${aprovacao.btn_voltar}
