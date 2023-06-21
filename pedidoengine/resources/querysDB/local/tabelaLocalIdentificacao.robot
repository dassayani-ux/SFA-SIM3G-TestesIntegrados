*** Settings ***
  
Library    DatabaseLibrary
Library    SeleniumLibrary
Library    String

Resource    ../basicas/sqlsBasicas.robot

*** Keywords ***


Consultar local buscando pelo documento identificacao
    [Arguments]     ${DOC_IDENTIFICACAO}
    [Documentation]     Esta keyword consulta o local vinculado ao cnpj e retorna o idlocal
    Connect
    ${Query}            Catenate     select idlocal from localidentificacao where  documentoidentificacao = '${DOC_IDENTIFICACAO}';
    ${responseQuery}    Query        selectStatement=${Query}
    # Se 
    IF     '@{responseQuery}' == '@{EMPTY}'     RETURN    ${None}      
    [Return]            ${responseQuery[0][0]}   
    Disconnect

Deletar registro vinculado ao documento identificacao
    [Arguments]     ${DOC_IDENTIFICACAO}

    Connect
    ${Query}      Catenate     delete from localidentificacao where documentoidentificacao = '${DOC_IDENTIFICACAO}';
    Execute Sql String    ${Query}
    Disconnect