*** Settings ***
  
Library    DatabaseLibrary
Library    SeleniumLibrary
Library    String

Resource    ../basicas/sqlsBasicas.robot

*** Keywords ***


Consultar usuarios aprovadores
    [Arguments]     ${idParceiro}
    Connect
    
    # ${Query}      Set Variable      select * from localemail where idparceiro in (select idparceiro from parceiro where nomeparceiro like '%PHV/MONACO EMPREENDIMENTOS IMOBILIARIOS LTDA%') 
    ${Query}      Catenate     select idUsuario from tipoaprovacaoControle where idpedidoAprovacao in    ${idParceiro}    );

    # Check If Exists In Database    ${Query}
    
    ${responseQuery}    Query    selectStatement=${Query}

    [Return]    ${responseQuery[0][0]} 

    Disconnect