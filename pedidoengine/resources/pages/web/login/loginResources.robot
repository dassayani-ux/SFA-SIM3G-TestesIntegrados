*** Settings ***

Library     SeleniumLibrary
Resource    ${EXECDIR}/variables/web/loginVariables.robot

*** Keywords ***

Realizar login    
    [Arguments]    ${Login}
    Input Text      id=${LOGIN PROFISSIONAL}   ${Login}
    Input Text      id=${SENHA PROFISSIONAL}    12
    Click Element   id=${BOTÂO ENTRAR}

    