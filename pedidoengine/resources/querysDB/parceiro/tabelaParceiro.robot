*** Settings ***
  
Library    DatabaseLibrary
Library    SeleniumLibrary
Library    String

Resource    ../basicas/sqlsBasicas.robot

*** Keywords ***

Consultar parceiro pelo nome
    [Arguments]    ${NOME_PARCEIRO} 
    Connect  
    ${Query}      Catenate     select * from parceiro where nomeparceiro = '${NOME_PARCEIRO}'; 
    ${responseQuery}    Query    selectStatement=${Query}
    [Return]    ${responseQuery[0][0]} 
    Disconnect


Renomear parceiro   
    [Arguments]     ${NOME_PARCEIRO}     ${NOVO_NOME_PARCEIRO}

    Connect
    ${Query}      Catenate     update parceiro set nomeparceiro = '${NOVO_NOME_PARCEIRO}' where nomeparceiro = '${NOME_PARCEIRO}';
    Execute Sql String    ${Query}
    Disconnect