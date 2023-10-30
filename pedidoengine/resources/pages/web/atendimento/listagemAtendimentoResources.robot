*** Settings ***
Documentation    Arquivo utilizado para armazenar as keywords utilizadas no proesso de listagem de atendimento.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/locators/web/atendimento/listagemAtendimentoLocators.robot
Resource    ${EXECDIR}/resources/locators/web/atendimento/cadastroAtendimentoLocators.robot

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
    SeleniumLibrary.Scroll Element Into View    xpath=${listagem.editarAtendimento}
    SeleniumLibrary.Click Element    xpath=${listagem.editarAtendimento}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.idCabecalho}    ${10}