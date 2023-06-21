*** Settings ***
Resource    ../../../querysDB/parceiro/tabelaParceiro.robot

*** Keywords ***
Renomear parceiros cadastrados
    [Arguments]    ${NOME_PARCEIRO}    ${NOVO_NOME_PARCEIRO}

    ${STATUS}    Run Keyword And Return Status    Consultar parceiro pelo nome    ${NOME_PARCEIRO} 
    Run Keyword If    ${status}==False      Renomear parceiro    ${NOME_PARCEIRO}    ${NOVO_NOME_PARCEIRO}

