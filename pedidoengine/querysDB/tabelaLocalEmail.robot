*** Settings ***
  
Library    DatabaseLibrary
Library    SeleniumLibrary
Library    String

Resource    basic.robot

*** Keywords ***


Consultar email na tabelaLocalEmail
    [Arguments]     ${idParceiro}
    Connect
    
    # ${Query}      Set Variable      select * from localemail where idparceiro in (select idparceiro from parceiro where nomeparceiro like '%PHV/MONACO EMPREENDIMENTOS IMOBILIARIOS LTDA%') 
    ${Query}      Catenate     select email from localemail where idparceiro in (select idparceiro from parceiro where idparceiro =    ${idParceiro}    );

    # Check If Exists In Database    ${Query}
    
    ${responseQuery}    Query    selectStatement=${Query}

    [Return]    ${responseQuery[0][0]} 

    Disconnect

    