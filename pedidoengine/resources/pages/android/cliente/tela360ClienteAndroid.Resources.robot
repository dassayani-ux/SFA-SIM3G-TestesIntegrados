*** Settings ***
Documentation    Arquivo destinado a armazenar keywords utilizadas em testes na tela 360° do cliente no ambiente Mobile.

Resource    ${EXECDIR}/resources/lib/android/lib.robot
Resource    ${EXECDIR}/resources/locators/android/cliente/tela360clienteLocators.robot
Resource    ${EXECDIR}/resources/locators/android/pedido/cadastroPedidoAndroidLocators.robot
Resource    ${EXECDIR}/resources/variables/android/pedido/cadastroPedidoAndroidVariables.robot
Resource    ${EXECDIR}/resources/locators/android/cliente/listagemclienteandroidLocators.robot

*** Keywords ***
Iniciar atendimento tela 360
    [Documentation]    Utilizada para iniciar atendimento via tela 360° do ckiente.

    ##Valida se há local selecionado antes de clicar em iniciar.
    ${local}=    AppiumLibrary.Get Text    xpath=${cabecalhoAtendimento.comboboxLocal}
    IF  '${local}' == '--Selecione--'
        Selecionar local atendimento
    ELSE
        BuiltIn.Log To Console    Local selecionado: ${local}
    END

    AppiumLibrary.Click Element    xpath=${cabecalhoAtendimento.botaoIniciar}
    AppiumLibrary.Wait Until Element Is Visible    xpath=${cabecalhoAtendimento.contagemTempoAtendimento}

Selecionar local atendimento
    [Documentation]    Utilizada para selecionar um local na tela 360° do cliente.

    AppiumLibrary.Click Element    xpath=${cabecalhoAtendimento.comboboxLocal}
    AppiumLibrary.Wait Until Element Is Visible    id=${popUpLocalAtendimento.idPopUp}
    ${countOpcoes}=    AppiumLibrary.Get Matching Xpath Count    ${popUpLocalAtendimento.itens}
    IF  ${countOpcoes} == ${1}
        BuiltIn.Fail    Não há locais disponíveis para seleção.
    END
    ${opcao}=    BuiltIn.Evaluate    random.randint(2, ${countOpcoes})    random
    ${xpath}    BuiltIn.Set Variable
    ${xpath}    BuiltIn.Catenate    ${popUpLocalAtendimento.itens}    [${opcao}]
    AppiumLibrary.Click Element    xpath=${xpath}
    ${local}=    AppiumLibrary.Get Text    xpath=${cabecalhoAtendimento.comboboxLocal}
    BuiltIn.Log To Console    Local selecionado: ${local}

Iniciar novo pedido tela 360
    [Documentation]    Inicia um novo pedido de venda a partir da tela 360° do cliente no Android.

    AppiumLibrary.Click Element    xpath=${secaoPedido.btnNovoPedido}
    BuiltIn.Sleep    0.7s
    AppiumLibrary.Wait Until Page Does Not Contain Element    id=${painelMsgCarregando}    timeout=20s

Finalizar atendimento tela 360
    [Documentation]    Finaliza um atendimento pela tela 360° do cliente.

    AppiumLibrary.Wait Until Element Is Visible    xpath=${cabecalhoAtendimento.botaoIniciar}
    AppiumLibrary.Click Element    xpath=${cabecalhoAtendimento.botaoIniciar}
    AppiumLibrary.Wait Until Element Is Visible    xpath=${telaListagemClientes.titulo}