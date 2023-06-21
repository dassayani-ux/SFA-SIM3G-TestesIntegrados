*** Settings ***
Documentation    Arquivo utilizado para realizar a abertura da aplicação web no navegador configurado.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/variables/web/global/newGlobalVariables.robot

*** Keywords ***
Abre navegador
    [Documentation]    Irá abrir a aplicação web no navegador previamente informado.
    Open Browser    ${WEB_URL}    ${NAVEGADOR}
    Maximize Browser Window