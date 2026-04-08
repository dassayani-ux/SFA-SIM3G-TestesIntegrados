*** Settings ***
Documentation    Arquivo utilizado para realizar a abertura da aplicação web no navegador configurado.

# Subimos 3 pastas (até chegar na resources) e entramos na lib
Resource         ../../../lib/web/lib.robot

# Subimos 4 pastas (até chegar na pedidoengine) e entramos nas libraries
Variables        ../../../../libraries/variables/sfa_variables.py

*** Variables ***
${HEADLESS}    false

*** Keywords ***
Abre navegador
    [Documentation]    Abre o navegador configurado. Em modo headless (CI/CD),
    ...                passe --variable HEADLESS:true na linha de comando do robot.
    IF    '${HEADLESS}' == 'true'
        ${options}=    Evaluate
        ...    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
        Call Method    ${options}    add_argument    --headless=new
        Call Method    ${options}    add_argument    --no-sandbox
        Call Method    ${options}    add_argument    --disable-dev-shm-usage
        Call Method    ${options}    add_argument    --window-size\=1920,1080
        Create Webdriver    Chrome    options=${options}
        Go To    ${aplicacao_web.urlWeb}
    ELSE
        Open Browser    ${aplicacao_web.urlWeb}    ${aplicacao_web.navegadorWeb}
        Maximize Browser Window
    END