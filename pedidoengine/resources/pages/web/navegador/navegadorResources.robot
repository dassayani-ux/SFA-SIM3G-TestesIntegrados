*** Settings ***
Documentation    Arquivo utilizado para realizar a abertura da aplicação web no navegador configurado.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Variables    ${EXECDIR}/libraries/variables/sfa_variables.py

*** Keywords ***
Abre navegador
    [Documentation]    Irá abrir a aplicação web no navegador previamente informado.
    
    ${variables}  Get variables
    ${status}  Run Keyword And Return Status  Evaluate   $ENVIRONMENT in $variables
    ${ENVIRONMENT}  Set variable if  ${status}==${FALSE}  local  ${ENVIRONMENT}

    IF    "${ENVIRONMENT}" == "pipeline" 
        Start Virtual Display 1920 1080
        Open Browser    ${url_ms}    ${aplicacao_web.urlWeb}    ${aplicacao_web.navegadorWeb}
        Set Window Size 1920 1080
    ELSE
        Open Browser    ${aplicacao_web.urlWeb}    ${aplicacao_web.navegadorWeb}
    END

    Maximize Browser Window