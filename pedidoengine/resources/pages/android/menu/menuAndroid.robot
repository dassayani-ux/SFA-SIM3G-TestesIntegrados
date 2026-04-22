*** Settings ***
Documentation    Arquivo utilizado para armazenar keywords utilizadas para realizar ações no menu do App mobile.

Resource    ${EXECDIR}/pedidoengine/resources/lib/android/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/android/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/android/cliente/listagemclienteandroidLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/android/consulta/telaGeralConsultaAndroidLocators.robot


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

Voltar para tela principal se necessario
    [Documentation]    Pressiona Back até chegar na PrincipalActivity e garante
    ...                que o menu lateral esteja aberto (após login fica aberto;
    ...                após navegar via Back fica fechado — abre por swipe).

    FOR    ${i}    IN RANGE    10
        ${activity}=    AppiumLibrary.Get Activity
        IF    '${activity}' == '${activityMenuPrincipal}'    BREAK
        AppiumLibrary.Press Keycode    4
        Sleep    0.8s
    END

    # Abre o drawer deslizando da borda esquerda se estiver fechado
    ${menu_visivel}=    Run Keyword And Return Status
    ...    AppiumLibrary.Element Should Be Visible    id=${menu.labelProfissional}
    IF    not ${menu_visivel}
        sfa_lib_mobile.Abrir drawer menu lateral
        Sleep    0.8s
    END
    Log To Console    \n✅ App na tela principal com menu aberto.

Exibir/recolher menu lateral
    [Documentation]    Keyword utilizada para exibir ou recolher o menu lateral do app Android quando necessário.

    AppiumLibrary.Click Element    accessibility_id=${menu.acessoMenu}

Acessar a guia de consulta no menu
    [Documentation]    Utilizada para acessar a tela de listagem de clientes por meio do menu lateral.
    ${ordenacaoMenu}=    sfa_lib_mobile.Retornar ordem menu mobile
    
    ${index}=    Collections.Get Index From List    ${ordenacaoMenu}    Consulta
    ${index}=    BuiltIn.Evaluate    ${index}+1

    #Quando o menu lateral é acessado de uma tela que não é a tela inicial do app, o xpath dos elementos do menu muda, por isso é necessária essa validação abaixo.
    ${activity}=    AppiumLibrary.Get Activity
    IF  '${activity}' == '${activityMenuPrincipal}'
        ${locator}    BuiltIn.Catenate    ${menu.opcaoGeral}    [${index}]
    ELSE
        ${locator}    BuiltIn.Catenate    ${menu.opcaoGeral2}    [${index}]
    END

    ${statusMenu}=    BuiltIn.Run Keyword And Return Status    AppiumLibrary.Element Should Be Visible    id=${menu.labelProfissional}
    BuiltIn.Run Keyword If    '${statusMenu}' == 'False'    Exibir/recolher menu lateral
    AppiumLibrary.Click Element    xpath=${locator}
    ${statusMenu}=    BuiltIn.Run Keyword And Return Status    AppiumLibrary.Element Should Be Visible    id=${menu.labelProfissional}
    BuiltIn.Run Keyword If    '${statusMenu}' == 'True'    Exibir/recolher menu lateral
    AppiumLibrary.Wait Until Element Is Visible    xpath=${telaConsultaGeralAndroid.titulo}