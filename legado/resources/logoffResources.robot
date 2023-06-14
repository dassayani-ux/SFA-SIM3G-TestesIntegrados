*** Settings ***

Library     SeleniumLibrary
Resource    ../variables/logoffVariables.robot

*** Keywords ***

realizar logoff
    Wait Until Page Contains Element       id=${NOME USUARIO}    timeout=50

    Click Element   id=${NOME USUARIO}

    Click Element   Xpath=${BOTÂO SAIR}