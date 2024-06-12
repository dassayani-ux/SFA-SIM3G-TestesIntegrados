*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar produtos.

Library    DatabaseLibrary
Library    ${EXECDIR}/libraries/sfa_lib_mobile.py

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
    ...    \nPara obter o preço deve ser passado a tabelaPreco(id) e o código ou id do produto. O argumento *roundConfig* diz se o valor será retornado arredondado de acordo com a configuração da base ou não. (Sim - 1 | Não - 0)

    [Arguments]    ${tabelaPreco}=${EMPTY}    ${codigoProduto}=${EMPTY}    ${idProduto}=${EMPTY}    ${roundConfig}=${1}

    ${casasDecimais}=    sfa_lib_mobile.Retornar casas decimais valores monetarios

    IF  '${tabelaPreco}' == '${EMPTY}'
        BuiltIn.Log To Console    Nenhuma tabela de preço passada como argumento.
        BuiltIn.Fail
    END

    # O trecho abaixo monta a sql utilizada para retornar o preço.
    # No IF superior, é verificado se foi informado o código do produto ou o ID e se a passagem do argumentos está válida.
    # Após isso, é verificado o parâmetro ${roundConfig}, se o valor for 1, o preço será retornado já arredondado de acordo com a config de casas decimais monetárias da base.

    IF  '${codigoProduto}' == '${EMPTY}' and '${idProduto}' == '${EMPTY}'
        BuiltIn.Log To Console    Nenhum produto foi passado de argumento.
        BuiltIn.Fail
    ELSE IF  '${codigoProduto}' != '${EMPTY}' and '${idProduto}' != '${EMPTY}'
        BuiltIn.Log To Console    [ERRO] Você informou o código e também o ID do produto, por favor informe apenas 1 dos argumentos.
        BuiltIn.Fail
    ELSE IF  '${idProduto}' != '${EMPTY}'
        IF  '${roundConfig}' == '${1}'
            ${sql}=    Catenate    SEPARATOR=\n
            ...    select round(t.preco, ${casasDecimais})
            ...    from tabelaprecoproduto t 
            ...    where t.idtabelapreco = ${tabelaPreco} and t.idproduto = ${idProduto};
        ELSE IF  '${roundConfig}' == '${0}'
            ${sql}=    Catenate    SEPARATOR=\n
            ...    select t.preco
            ...    from tabelaprecoproduto t 
            ...    where t.idtabelapreco = ${tabelaPreco} and t.idproduto = ${idProduto};
        ELSE
            BuiltIn.Log To Console    [ERRO] O valor informado para ${roundConfig} não é válido.
            BuiltIn.Fail
        END
    ELSE IF  '${codigoProduto}' != '${EMPTY}'
        IF  '${roundConfig}' == '${1}'
            ${sql}=    Catenate    SEPARATOR=\n
            ...    select round(t.preco, ${casasDecimais})
            ...    from tabelaprecoproduto t
            ...    inner join produto p on p.idproduto = t.idproduto
            ...    where t.idtabelapreco = ${tabelaPreco} and p.codigo = '${codigoProduto}';
        ELSE IF  '${roundConfig}' == '${0}'
            ${sql}=    Catenate    SEPARATOR=\n
            ...    select t.preco
            ...    from tabelaprecoproduto t
            ...    inner join produto p on p.idproduto = t.idproduto
            ...    where t.idtabelapreco = ${tabelaPreco} and p.codigo = '${codigoProduto}';
        ELSE
            BuiltIn.Log To Console    [ERRO] O valor informado para ${roundConfig} não é válido.
            BuiltIn.Fail
        END
    END
    
    ${preco}=    DatabaseLibrary.Query    ${sql}
    
    BuiltIn.Return From Keyword    ${preco[0][0]}