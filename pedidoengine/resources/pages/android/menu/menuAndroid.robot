*** Settings ***
Documentation    Arquivo utilizado para armazenar keywords utilizadas para realizar ações no menu do App mobile.

Library    ${EXECDIR}/libraries/sfa_lib_mobile.py
Resource    ${EXECDIR}/resources/lib/android/lib.robot
Resource    ${EXECDIR}/resources/locators/android/cliente/clienteLocators.robot
Resource    ${EXECDIR}/resources/locators/android/menu/menuLateralLocators.robot


*** Keywords ***
Acessar a guia de clientes no menu
    [Documentation]    Utilizada para acessar a tela de listagem de clientes por meio do menu lateral.
    ${ordenacaoMenu}=    Retornar ordem menu mobile
    
    ${index}=    Get Index From List    ${ordenacaoMenu}    Cliente
    ${index}=    Evaluate    ${index}+1
    ${locator}=    Catenate    ${menu.opcaoGeral}    [${index}]
    AppiumLibrary.Click Element    xpath=${locator}

    AppiumLibrary.Wait Until Element Is Visible    xpath=${telaListagemClientes.titulo}