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

Retornar preco de tabela do produto
    [Documentation]    Utilizada para retornar o preço de tabela do produto.
    ...    \nPara obter o preço deve ser passado a tabelaPreco(id) e o código ou id do produto.

    [Arguments]    ${tabelaPreco}=${EMPTY}    ${codigoProduto}=${EMPTY}    ${idProduto}=${EMPTY}

    IF  '${tabelaPreco}' == '${EMPTY}'
        BuiltIn.Log To Console    Nenhuma tabela de preço passada como argumento.
        BuiltIn.Fail
    END

    IF  '${codigoProduto}' == '${EMPTY}' and '${idProduto}' == '${EMPTY}'
        BuiltIn.Log To Console    Nenhum produto foi passado de argumento.
        BuiltIn.Fail
    ELSE IF  '${codigoProduto}' != '${EMPTY}' and '${idProduto}' != '${EMPTY}'
        BuiltIn.Log To Console    [ERRO] Você informou o código e também o ID do produto, por favor informe apenas 1 dos argumentos.
        BuiltIn.Fail
    ELSE IF  '${idProduto}' != '${EMPTY}'
        ${sql}=    Catenate    SEPARATOR=\n
        ...    select round(t.preco, 4) 
        ...    from tabelaprecoproduto t 
        ...    where t.idtabelapreco = ${tabelaPreco} and t.idproduto = ${idProduto};
    ELSE IF  '${codigoProduto}' != '${EMPTY}'
        ${sql}=    Catenate    SEPARATOR=\n
        ...    select round(t.preco, 4) 
        ...    from tabelaprecoproduto t
        ...    inner join produto p on p.idproduto = t.idproduto
        ...    where t.idtabelapreco = ${tabelaPreco} and p.codigo = '${codigoProduto}';
    END
    
    ${preco}=    DatabaseLibrary.Query    ${sql}
    IF  '${idProduto}' != '${EMPTY}'
        BuiltIn.Log To Console    Preço para o produto de ID ${idProduto} = R$${preco[0][0]}
    ELSE IF  '${codigoProduto}' != '${EMPTY}'
        BuiltIn.Log To Console    Preço para o produto de código ${codigoProduto} = R$${preco[0][0]}
    END
    
    BuiltIn.Return From Keyword    ${preco[0][0]}