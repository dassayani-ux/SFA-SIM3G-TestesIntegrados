*** Settings ***
Documentation    Arquivo utilizado para armazenar keywords utilizadas para realizar consultas de pedido no App mobile.

Resource    ${EXECDIR}/resources/lib/android/lib.robot
Resource    ${EXECDIR}/resources/locators/android/pedido/cadastroPedidoAndroidLocators.robot
Resource    ${EXECDIR}/resources/locators/android/consulta/telaConsultaPedidoLocators.robot
Resource    ${EXECDIR}/resources/locators/android/consulta/telaGeralConsultaAndroidLocators.robot

*** Keywords ***
Abrir a pesquisa avancada na consulta de pedidos
    [Documentation]    Utilizada para abrir a janela de pesquisa acançada na tela de consulta de pedidos.

    AppiumLibrary.Click Element    accessibility_id=${pesquisaAvancadaConsultaPedido.ativaPesquisaAvancada}
    AppiumLibrary.Wait Until Element Is Visible    id=${pesquisaAvancadaConsultaPedido.btnPesquisar}

Filtrar pedido por numero
    [Documentation]    Utilizada para filtrar um pedido por número via tela de pesquisa avançada na tela de consulta de pedidos.
    [Arguments]    ${numeroPedido}=${EMPTY}

    IF  '${numeroPedido}' == '${EMPTY}'
        BuiltIn.Log To Console    [ERRO] Nenhum valor passado para o argumento numeroPedido.
        BuiltIn.Fail
    END

    AppiumLibrary.Input Text    xpath=${pesquisaAvancadaConsultaPedido.campoNumeroPedido}    ${numeroPedido}
    AppiumLibrary.Click Element    id=${pesquisaAvancadaConsultaPedido.btnPesquisar}
    BuiltIn.Sleep    1s
    ${quantidadePedidosListadosSTR}=    AppiumLibrary.Get Text    xpath=${telaConsultaPedidos.quantidadePedidosListados}
    ${format}=    String.Remove String    ${quantidadePedidosListadosSTR}    Pedido    (    )
    ${quantidadePedidosListadosINT}=    BuiltIn.Convert To Integer    ${format}
    IF  ${quantidadePedidosListadosINT} == ${1}
        BuiltIn.Log To Console    \nPedido número ${numeroPedido} filtrado corretamente.
    ELSE
        BuiltIn.Log To Console    Ouve um erro ao filtra o pedido número ${numeroPedido}.\n Esperava-se 1 registro e a consulta retornou ${quantidadePedidosListadosINT}.
        BuiltIn.Fail
    END

Abrir menu de contexto do pedido
    [Documentation]    Abre o menu de contexto do primeiro pedido listado na tela de consulta de pedidos.

    AppiumLibrary.Click Element    xpath=${menuContextoCardConsultaPedidoAndroid.menuContexto}

Visualizar pedido de venda
    [Documentation]    Utilizada para visualizar o primeiro pedido listado na tela de consulta de pedidos no Android.

    Abrir menu de contexto do pedido
    AppiumLibrary.Wait Until Element Is Visible    xpath=${menuContextoCardConsultaPedidoAndroid.visualizarPedido}
    AppiumLibrary.Click Element    xpath=${menuContextoCardConsultaPedidoAndroid.visualizarPedido}
    AppiumLibrary.Wait Until Page Contains Element     xpath=${cabecalhoPedidoAndroid.numeroPedido}