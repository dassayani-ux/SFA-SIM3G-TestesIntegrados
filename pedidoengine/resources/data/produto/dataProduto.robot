*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar produtos.

Library    DatabaseLibrary

*** Keywords ***
Retornar quantidade apresentacao produto
    [Documentation]    Retorna o valor do campo *_quantidadeapresentacao_* para o produto filtrado.
    [Arguments]    ${idProduto}=${EMPTY}    ${codigoProduto}=${EMPTY}

    IF  '${idProduto}' != '${EMPTY}' and '${codigoProduto}' == '${EMPTY}'
        ${sql}=    BuiltIn.Set Variable    select quantidadeapresentacao from produto where idproduto = ${idProduto}
    ELSE IF  '${codigoProduto}' != '${EMPTY}' and '${idProduto}' == '${EMPTY}'
        ${sql}=    BuiltIn.Set Variable    select quantidadeapresentacao from produto where codigo = '${codigoProduto}'
    ELSE IF  '${codigoProduto}' != '${EMPTY}' and '${idProduto}' != '${EMPTY}'
        ${sql}=    BuiltIn.Set Variable    select quantidadeapresentacao from produto where codigo = '${codigoProduto}' and idproduto = ${idProduto}
    ELSE
        BuiltIn.Fail    Nenhum produto informado.
    END
    
    ${count}=    DatabaseLibrary.Row Count    ${sql}
    IF  ${count} >= ${1}
        ${quantidadeApresentacao}=    DatabaseLibrary.Query    ${sql}
    ELSE
        BuiltIn.Fail    O produto informado não existe no banco de dados.
    END

    BuiltIn.Return From Keyword    ${quantidadeApresentacao[0][0]}