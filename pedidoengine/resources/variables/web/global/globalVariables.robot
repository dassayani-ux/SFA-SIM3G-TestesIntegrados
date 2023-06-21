#### seção de dados de teste || cabeçalho de seção   ####
*** Settings ***
Documentation     Resources do processo de Login
Library           SeleniumLibrary

*** Variables ***
${CHROME}               Chrome
${URL}                  http://localhost:8080/automacao
# ${URL}                  https://homologa.mastersales.assaabloybrasil.com.br:9898/hml_onda21_pedidolog/ID_1672173820617/login.form.ws
#${URL}                    http://10.171.217.166:9001/totvscrmsfa/
# ${URL}                    http://qa01.sfa.wssim.com.br:9003/totvscrmsfa/


${CENTRO DE LOGIN}          login_center

*** Keywords ***
Abrir navegador chrome
    [Documentation]                 Abre uma página do chrome na página de login
    Open Browser                    ${URL}     ${CHROME}  options=add_argument("--detach")    
    # options=add_argument("--headless") 
    maximize browser window
    Wait Until Page Contains Element       id=${CENTRO DE LOGIN}    timeout=50

Fechar navegador
    Close Browser




    