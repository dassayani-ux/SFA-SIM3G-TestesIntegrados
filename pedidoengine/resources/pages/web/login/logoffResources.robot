*** Settings ***

Library     SeleniumLibrary
Resource    ../../variables/web/logoffVariables.robot

*** Keywords ***

realizar logoff
    Wait Until Page Contains Element       ${NOME USUARIO}    timeout=50

    Click Element    id=${NOME USUARIO}

    Click Element   Xpath=${BOTÂO SAIR}