*** Settings ***
Documentation    Arquivo utilizado para armazenar keywords utilizadas para realizar consultas de pedido no App mobile.

Resource    ${EXECDIR}/pedidoengine/resources/lib/android/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/android/pedido/cadastroPedidoAndroidLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/android/consulta/telaConsultaPedidoLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/android/consulta/telaGeralConsultaAndroidLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/variables/android/pedido/cadastroPedidoAndroidVariables.robot

*** Keywords ***
Abrir a pesquisa avancada na consulta de pedidos
    [Documentation]    Utilizada para abrir a janela de pesquisa acançada na tela de consulta de pedidos.

    AppiumLibrary.Wait Until Page Does Not Contain Element    id=${painelMsgCarregando}    timeout=60s
    AppiumLibrary.Click Element    accessibility_id=${pesquisaAvancadaConsultaPedido.ativaPesquisaAvancada}
    AppiumLibrary.Wait Until Element Is Visible    id=${pesquisaAvancadaConsultaPedido.btnPesquisar}

Filtrar pedido por numero
    [Documentation]    Utilizada para filtrar um pedido por número via tela de pesquisa avançada na tela de consulta de pedidos.
    [Arguments]    ${numeroPedido}=${EMPTY}

    IF  '${numeroPedido}' == '${EMPTY}'
        BuiltIn.Log To Console    [ERRO] Nenhum valor passado para o argumento numeroPedido.
        BuiltIn.Fail
    END

    AppiumLibrary.Clear Text    xpath=${pesquisaAvancadaConsultaPedido.campoNumeroPedido}
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

Clonar pedido de venda
    [Documentation]    Utilizada para acessar o menu de contexto do pedido e acionar a clonagem de pedido com a configuracao padrão de clonagem.

    Abrir menu de contexto do pedido
    AppiumLibrary.Wait Until Element Is Visible    xpath=${menuContextoCardConsultaPedidoAndroid.clonarPedido}
    AppiumLibrary.Click Element    xpath=${menuContextoCardConsultaPedidoAndroid.clonarPedido}
    AppiumLibrary.Wait Until Page Contains Element    id=${painelClonagemPedido.idPainel}

    ##Valida se há local selecionado antes de clicar em confirmar.
    ${local}=    AppiumLibrary.Get Text    xpath=${painelClonagemPedido.comboboxLocal}
    IF  '${local}' == '--Selecione--'
        Selecionar local para clonagem
    ELSE
        BuiltIn.Log To Console    Local selecionado: ${local}
    END

    AppiumLibrary.Click Element    id=${painelClonagemPedido.btnConfirmar}
    AppiumLibrary.Wait Until Page Contains Element     xpath=${cabecalhoPedidoAndroid.numeroPedido}

Selecionar local para clonagem
    [Documentation]    Utilizada para selecionar um local na tela de clonagem de pedido.

    AppiumLibrary.Click Element    xpath=${painelClonagemPedido.comboboxLocal}
    AppiumLibrary.Wait Until Element Is Visible    id=${painelClonagemPedido.idPopUpLocal}
    ${local}    Retornar dados de local especifico    ${dadosPedidoAndroid.idLocalParceiro}
    AppiumLibrary.Input Text    xpath=${painelClonagemPedido.campoPesquisaLocal}    ${local['descricao']}
    AppiumLibrary.Click Element    xpath=${painelClonagemPedido.itensPopUpLocal}
    BuiltIn.Log To Console    Local selecionado: ${local['descricao']}