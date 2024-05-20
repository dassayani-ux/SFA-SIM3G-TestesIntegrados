*** Settings ***
Documentation    Arquivo utilizado para realizar a abertura da aplicação web no navegador configurado.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Variables    ${EXECDIR}/libraries/variables/sfa_variables.py

*** Keywords ***
Abre navegador
    [Documentation]    Irá abrir a aplicação web no navegador previamente informado.
    Start Virtual Display    1920    1080
    Open Browser    ${aplicacao_web.urlWeb}
    Maximize Browser Window