*** Settings ***

Library     AppiumLibrary
Resource    ../variables/loginAndroidVariables.robot

*** Keywords ***

login

    Wait Until Page Contains Element    ${PROFISSIONAL}     timeout=1200

    Element Should Contain Text     ${PROFISSIONAL}     01000016

    Input Text      ${SENHA}  12

    Click Element   ${ENTRAR} 


