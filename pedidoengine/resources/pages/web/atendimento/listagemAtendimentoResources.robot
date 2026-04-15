*** Settings ***
Documentation    Arquivo utilizado para armazenar as keywords utilizadas no proesso de listagem de atendimento.

Resource    ${EXECDIR}/pedidoengine/resources/lib/web/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/atendimento/listagemAtendimentoLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/atendimento/cadastroAtendimentoLocators.robot

*** Keywords ***
Acessar listagem de atendimentos
    [Documentation]    Irá acessar a tela de listagem de atendimentos.

    SeleniumLibrary.Click Element    id=${menuAtendimento.menuAtendimento}
    SeleniumLibrary.Wait Until Element Is Visible    id=${menuAtendimento.listarAtendimento}
    SeleniumLibrary.Click Element    id=${menuAtendimento.listarAtendimento}    
    SeleniumLibrary.Wait Until Page Contains Element    xpath=${tituloListagemAtendimento}    20
    SeleniumLibrary.Wait Until Element Is Visible    id=${listagem.gridListagem}    10s
    sfa_lib_web.Fechar guia de Dashboard
    SeleniumLibrary.Switch Window    TOTVS CRM SFA | Atendimento

Editar Atendimento
    [Documentation]    Irá acionar a edição do primeiro registro listado no grid.

    Sleep    1s
    ${countListagem}    SeleniumLibrary.Get Element Count    xpath=//*[@id="grid_atendimento"]/div[5]/div/div[1]
    IF  '${countListagem}' == '${1}'
        SeleniumLibrary.Click Element    id=${btnPesquisa}
    END
    SeleniumLibrary.Wait Until Page Does Not Contain    Carregando...    15s
    #title="Editar"
    ${coutCamposGrid}    SeleniumLibrary.Get Element Count    ${listagem.campos}
    @{campos}    BuiltIn.Create List
    FOR  ${I}  IN RANGE    ${1}    ${coutCamposGrid}+1
        ${locatorCampos}    BuiltIn.Catenate    ${listagem.campos}    [${I}]
        ${e}=    SeleniumLibrary.Get Element Attribute    xpath=${locatorCampos}    attribute=title
        Collections.Append To List    ${campos}    ${e}
    END
    ${index}=    Collections.Get Index From List    ${campos}    Editar
    ${index}=    BuiltIn.Evaluate    ${index}+1
    BuiltIn.Set Test Variable    ${listagem.editarAtendimento}    //*[@id="grid_atendimento"]/div[5]/div/div[3]/div[${index}]
    SeleniumLibrary.Scroll Element Into View    xpath=${listagem.editarAtendimento}
    SeleniumLibrary.Click Element    xpath=${listagem.editarAtendimento}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.idCabecalho}    ${10}