*** Settings ***

Library     AppiumLibrary
Resource    ../variables/primeiraConexaoAndroidVariables.robot

*** Keywords ***

primeira conexão

    Wait Until Page Contains Element    ${PROFISSIONAL}     timeout=120

    Input Text      ${PROFISSIONAL}     01000016

    Input Text  ${SENHA}    12

    Click Element      ${ENTRAR}

    Wait Until Page Contains Element    ${BOTÂO OK}     timeout=120

    Click Element   ${BOTÂO OK}  

    Wait Until Page Contains Element  ${CONEXÂO}  timeout=120

    Input Text  ${CONEXÂO}      ${SERVER}

    Click Element  ${SINCRONIZAR}

    Wait Until Page Contains Element  ${BOTÂO OK}        timeout=1000

    Element Should Contain Text     ${MENSAGEM DE CONFIRMAÇÂO}      ${TEXTO MENSAGEM DE CONFIRMAÇÂO}

    Click Element   ${BOTÂO OK}  


