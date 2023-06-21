*** Settings ***
Resource    ../../../querysDB/local/tabelaLocalFilial.robot
Resource    ../../../querysDB/local/tabelaLocalIdentificacao.robot

*** Keywords ***
Apagar vinculo entre local e filial e documento Identificacao
    [Arguments]    ${CNPJ}
      
    ${ID_LOCAL}    Consultar local buscando pelo documento identificacao     ${CNPJ}
    IF    ${ID_LOCAL}!=${None}  
        Deletar registros vinculados a um idlocal                ${ID_LOCAL}
        Deletar registro vinculado ao documento identificacao    ${CNPJ}
    END  
    