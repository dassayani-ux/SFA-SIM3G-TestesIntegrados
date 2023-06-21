*** Settings ***
  
Library    DatabaseLibrary
Library    SeleniumLibrary
Library    String

Resource    ../basicas/sqlsBasicas.robot

*** Keywords ***


Consultar registros vinculados a um idlocal 
    [Arguments]     ${ID_LOCAL}
    Connect
    ${Query}            Catenate     select * from localfilial l where idlocal = ${ID_LOCAL};    
    ${responseQuery}    Query        selectStatement=${Query}
    [Return]            ${responseQuery[0][0]} 
    Disconnect


Deletar registros vinculados a um idlocal
    [Arguments]     ${ID_LOCAL}

    Connect
    ${Query}      Catenate     delete from localfilial where idlocal = ${ID_LOCAL};
    Execute Sql String    ${Query}
    Disconnect