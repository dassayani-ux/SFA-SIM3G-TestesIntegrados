*** Settings ***
Documentation    Arquivo utilizado para armazenar keywords utilizadas nos testes que envolvem a tela de consulta no Mobile.

Resource    ${EXECDIR}/resources/lib/android/lib.robot
Resource    ${EXECDIR}/resources/locators/android/consulta/telaConsultaPedidoLocators.robot
Resource    ${EXECDIR}/resources/locators/android/consulta/telaGeralConsultaAndroidLocators.robot

*** Keywords ***
Acessar a consulta de pedidos
    [Documentation]    Utilizada para clicar e acessar a guia de consulta de pedidos.

    AppiumLibrary.Click Element    xpath=${opcoesConsulta.pedidos}
    BuiltIn.Sleep    0.5s
    AppiumLibrary.Wait Until Page Does Not Contain Element    id=${painelMsgCarregando}    timeout=60s
    AppiumLibrary.Wait Until Page Contains Element    xpath=${telaConsultaPedidos.quantidadePedidosListados}