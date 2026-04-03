*** Settings ***
Documentation    Arquivo utilizado para realizar a abertura da aplicação web no navegador configurado.

# Subimos 3 pastas (até chegar na resources) e entramos na lib
Resource         ../../../lib/web/lib.robot

# Subimos 4 pastas (até chegar na pedidoengine) e entramos nas libraries
Variables        ../../../../libraries/variables/sfa_variables.py

*** Keywords ***
Abre navegador
    [Documentation]    Irá abrir a aplicação web no navegador previamente informado.
    Open Browser       ${aplicacao_web.urlWeb}    ${aplicacao_web.navegadorWeb}
    Maximize Browser Window