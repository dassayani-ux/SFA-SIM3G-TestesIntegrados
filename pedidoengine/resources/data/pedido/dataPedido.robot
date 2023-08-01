*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar pedido.

Resource    ${EXECDIR}/resources/lib/web/lib.robot

*** Variables ***
${itensTabelaPreco_SQL}    select p.idproduto, p.codigo, p.descricao, tpp.preco 
    ...    from tabelaprecoproduto tpp 
    ...    join tabelapreco tp on tp.idtabelapreco = tpp.idtabelapreco and tp.idnativo = 1
    ...    join produto p on p.idproduto = tpp.idproduto and p.idnativo = 1
    ...    where tp.idtabelapreco = 

*** Keywords ***
Retorna idTipoPedido
    [Documentation]    Irá retornar o ID do Tipo Pedido utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idTipoPedido}=    Query    select t.idtipopedido from tipopedido t where t.descricao = '${descricao}'

    Return From Keyword    ${idTipoPedido[0][0]}

Retorna idTabelaPreco
    [Documentation]    Irá retornar o ID da Tabela de Preço utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idTabelaPreco}=    Query    select t.idtabelapreco from tabelapreco t where t.descricao = '${descricao}'

    Return From Keyword    ${idTabelaPreco[0][0]}

Retorna idCondicaoPagamento
    [Documentation]    Irá retornar o ID da Condição de Pagamento utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idCondicaoPagamento}=    Query    select c.idcondicaopagamento from condicaopagamento c where c.descricao = '${descricao}' and c.idnativo = 1

    Return From Keyword    ${idCondicaoPagamento[0][0]}

Retorna idTipoCobranca
    [Documentation]    Irá retornar o ID do Tipo de Cobrança utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idTipoCobranca}=    Query    select t.idtipocobranca from tipocobranca t where t.idnativo = 1 and t.descricao = '${descricao}'

    Return From Keyword    ${idTipoCobranca[0][0]}

Retorna quantidade de itens da tabela
    [Documentation]    Irá retornar a quantidade de produtos presentes na tabela de preço passada no argumento *tabelaPreco*;
    [Arguments]    ${tabelaPreco}

    ${countTabela}=    Row Count    ${itensTabelaPreco_SQL}${tabelaPreco}

    Return From Keyword    ${countTabela}

Retorna produtos
    [Documentation]    Irá retornar o(s) código(s) do(s) produto(s) presente(s) na lista \@{lista}.
    ...    \nEspera-se que seja passada uma lista como argumento.
    [Arguments]    @{lista}    ${tabelaPreco}

    @{listaAux}=    Set Variable    @{lista}
    FOR  ${element}  IN    @{lista}
        Remove Values From List    ${lista}    ${element}
    END
    ${lenght}=    Get Length    ${listaAux}
    ${produtos}=    Query    ${itensTabelaPreco_SQL}${tabelaPreco}

    FOR  ${I}  IN RANGE    ${lenght}
        Append To List    ${lista}    ${produtos[${listaAux[${I}]}][1]}
    END

    Log To Console    Produtos selecionados: ${lista}
    Return From Keyword    @{lista}
    