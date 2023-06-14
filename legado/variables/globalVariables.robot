#### seção de dados de teste || cabeçalho de seção   ####
*** Settings ***
Documentation     Resources do processo de Login
Library           SeleniumLibrary

*** Variables ***
${CHROME}               Chrome
${URL}                  http://qa03.sfa.wssim.com.br:9004/totvscrmsfa/

${CENTRO DE LOGIN}          login_center
*** Keywords ***
Abrir navegador chrome
    [Documentation]                 Abre uma página do chrome na página de login
    Open Browser                    ${URL}      ${CHROME}
    
    maximize browser window
    
    Wait Until Page Contains Element       id=${CENTRO DE LOGIN}    timeout=50

Fechar navegador
    Close Browser




    