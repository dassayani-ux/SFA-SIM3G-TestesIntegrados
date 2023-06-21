*** Settings ***
  
Library    DatabaseLibrary
Library    SeleniumLibrary
Library    String

Resource    ../basicas/sqlsBasicas.robot

*** Keywords ***

Consultar email na tabelaLocalEmail
    [Arguments]     ${idParceiro}
    Connect  
    ${Query}      Catenate     select email from localemail where idparceiro in (select idparceiro from parceiro where idparceiro =    ${idParceiro}    ); 
    ${responseQuery}    Query    selectStatement=${Query}
    [Return]    ${responseQuery[0][0]} 
    Disconnect

    