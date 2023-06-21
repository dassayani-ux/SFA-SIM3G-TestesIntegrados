*** Settings ***
Documentation    Arquivo utilizado para armazenar as keywords utilizadas no proesso de listagem de atendimento.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/locators/web/atendimento/listagemAtendimentoLocators.robot
Resource    ${EXECDIR}/resources/locators/web/atendimento/cadastroAtendimentoLocators.robot

*** Keywords ***
Acessa listagem de atendimentos
    [Documentation]    Irá acessar a tela de listagem de atendimentos.

    Click Element    id=${atendimento.menuAtendimento}
    Wait Until Element Is Visible    id=${atendimento.listarAtendimento}
    Click Element    id=${atendimento.listarAtendimento}    
    Wait Until Page Contains Element    xpath=${tituloListagemAtendimento}    20
    Wait Until Element Is Visible    id=${listagem.gridListagem}    10s
    Capture Page Screenshot

Edita Atendimento
    [Documentation]    Irá acionar a edição do primeiro registro listado no grid.
    SeleniumLibrary.Click Element    xpath=${listagem.editarAtendimento}
    Wait Until Element Is Visible    id=${cabecalho.idCabecalho}