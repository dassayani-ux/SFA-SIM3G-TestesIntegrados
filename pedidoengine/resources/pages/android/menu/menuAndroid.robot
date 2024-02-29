*** Settings ***
Documentation    Arquivo utilizado para armazenar keywords utilizadas para realizar ações no menu do App mobile.

Resource    ${EXECDIR}/resources/lib/android/lib.robot
Resource    ${EXECDIR}/resources/locators/android/cliente/listagemclienteandroidLocators.robot
Resource    ${EXECDIR}/resources/locators/android/menu/menuLateralLocators.robot


*** Keywords ***
Acessar a guia de clientes no menu
    [Documentation]    Utilizada para acessar a tela de listagem de clientes por meio do menu lateral.
    ${ordenacaoMenu}=    sfa_lib_mobile.Retornar ordem menu mobile
    
    ${index}=    Get Index From List    ${ordenacaoMenu}    Cliente
    ${index}=    Evaluate    ${index}+1
    ${locator}=    Catenate    ${menu.opcaoGeral}    [${index}]
    ${statusMenu}=    BuiltIn.Run Keyword And Return Status    AppiumLibrary.Element Should Be Visible    id=${menu.labelProfissional}
    BuiltIn.Run Keyword If    '${statusMenu}' == 'False'    Exibir/recolher menu lateral
    AppiumLibrary.Click Element    xpath=${locator}
    AppiumLibrary.Wait Until Element Is Visible    xpath=${telaListagemClientes.titulo}

Exibir/recolher menu lateral
    [Documentation]    Keyword utilizada para exibir ou recolher o menu lateral do app Android quando necessário.

    AppiumLibrary.Click Element    accessibility_id=${menu.acessoMenu}