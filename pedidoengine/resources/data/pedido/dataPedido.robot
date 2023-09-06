*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar pedido.

Resource    ${EXECDIR}/resources/lib/web/lib.robot

*** Variables ***
${itensTabelaPreco_SQL}    select p.idproduto, p.codigo, p.descricao, tpp.preco 
    ...    from tabelaprecoproduto tpp 
    ...    join tabelapreco tp on tp.idtabelapreco = tpp.idtabelapreco and tp.idnativo = 1
    ...    join produto p on p.idproduto = tpp.idproduto and p.idnativo = 1
    ...    where tp.idtabelapreco = 

${sqlPesquisaCabecalhoTipoCobranca}    select nivel.idwsconfigpedidonivel, nivel.idnativo
    ...    from wsconfigpedidocampo campo
    ...    inner join wsconfigpedidonivel nivel on nivel.idwsconfigpedidocampo = campo.idwsconfigpedidocampo
    ...    where campo.contexto = 'CABECALHO' 
    ...    and campo.nomeentidade = 'TIPO_COBRANCA' 
    ...    and campo.idnativo = 1

${sqlUltimoPedidoNF}    select cast(p.numeropedido as integer) from pedido p
    ...    inner join tiposituacaopedido tp on tp.idtiposituacaopedido = p.idtiposituacaopedido
    ...    where tp.sgltiposituacaopedido = 'NF'
    ...    order by p.datapedido desc, cast(p.numeropedido as integer) desc
    ...    limit 1

${sqlUltimoPedido}    select cast(p.numeropedido as integer)
    ...    from pedido p
    ...    order by p.datapedido desc, cast(p.numeropedido as integer) desc
    ...    limit 1

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

    Return From Keyword    @{lista}

Validar parceiro do pedido
    [Documentation]    Irá validar se o parceiro do pedido salvo no banco de dados está de acordo com o argumento *idParceiro*.
    [Arguments]    ${numeroPedido}    ${idParceiro}

    ${data}    Query    select idparceiro from pedido where numeropedido = '${numeroPedido}'

    IF  '${data[0][0]}' == '${idParceiro}'
        Log To Console    Parceiro do pedido coincide com o banco de dados.
    ELSE    
        Log To Console    Parceiro passado é diferente do parceiro salvo no database para o pedido número ${numeroPedido}. (Argumento: ${idParceiro} / Database: ${data[0][0]})
        Fail
    END

Validar local do pedido
    [Documentation]    Irá validar se o localParceiro do pedido salvo no banco de dados está de acordo com o argumento *idLocal*.
    [Arguments]    ${numeroPedido}    ${idLocal}

    ${data}    Query    select idlocal from pedido where numeropedido = '${numeroPedido}'

    IF  '${data[0][0]}' == '${idlocal}'
        Log To Console    Local do parceiro no pedido coincide com o banco de dados.
    ELSE    
        Log To Console    Local passado é diferente do local salvo no database para o pedido número ${numeroPedido}. (Argumento: ${idlocal} / Database: ${data[0][0]})
        Fail
    END

Validar se o pedido consta no banco de dados
    [Documentation]    Verifica se o pedido consta no banco de dados.
    [Arguments]    ${numeroPedido}=None

    IF  '${numeroPedido}' != 'None'
        ${result}    DatabaseLibrary.Check If Exists In Database    select * from pedido where numeropedido = '${numeroPedido}'
        IF  '${result}' == 'None'
            Log To Console    Registro do pedido número ${numeroPedido} encontrado no banco de dados.
        ELSE
            Log To Console    Registro do pedido número ${numeroPedido} não foi encontrado no banco de dados.
            Fail
        END
        
    END

Validar filial do pedido
    [Documentation]    Irá validar se a filial do pedido salva no banco de dados está de acordo com o argumento *idFilial*.
    [Arguments]    ${numeroPedido}    ${idFilial}

    ${data}    Query    select idlocalfilialvenda from pedido where numeropedido = '${numeroPedido}'

    IF  '${data[0][0]}' == '${idFilial}'
        Log To Console    Filial do pedido coincide com o banco de dados.
    ELSE    
        Log To Console    Filial passada é diferente da filial salva no database para o pedido número ${numeroPedido}. (Argumento: ${idFilial} / Database: ${data[0][0]})
        Fail
    END

Validar tipo do pedido
    [Documentation]    Irá validar se o Tipo do pedido salvo no banco de dados está de acordo com o argumento *idTipoPedido*.
    [Arguments]    ${numeroPedido}    ${idTipoPedido}

    ${data}    Query    select idtipopedido from pedido where numeropedido = '${numeroPedido}'

    IF  '${data[0][0]}' == '${idTipoPedido}'
        Log To Console    Tipo do pedido coincide com o banco de dados.
    ELSE    
        Log To Console    Tipo do pedido é diferente do Tipo salvo no database para o pedido número ${numeroPedido}. (Argumento: ${idTipoPedido} / Database: ${data[0][0]})
        Fail
    END

Validar tabela de preço
    [Documentation]    Irá validar se a Tabela de preço salva no banco de dados está de acordo com o argumento *idTabelaPreco*.
    [Arguments]    ${numeroPedido}    ${idTabelaPreco}

    ${data}    Query    select idtabelapreco from pedido where numeropedido = '${numeroPedido}'

    IF  '${data[0][0]}' == '${idTabelaPreco}'
        Log To Console    Tabela de preço do pedido coincide com o banco de dados.
    ELSE    
        Log To Console    Tabela de preço do pedido é diferente da Tabela salva no database para o pedido número ${numeroPedido}. (Argumento: ${idTabelaPreco} / Database: ${data[0][0]})
        Fail
    END

Validar condicao de pagamento
    [Documentation]    Irá validar se a Condição de pagamento salva no banco de dados está de acordo com o argumento *idCondicaoPagamento*.
    [Arguments]    ${numeroPedido}    ${idCondicaoPagamento}

    ${data}    Query    select idcondicaopagamento from pedido where numeropedido = '${numeroPedido}'

    IF  '${data[0][0]}' == '${idCondicaoPagamento}'
        Log To Console    Condição de pagamento do pedido coincide com o banco de dados.
    ELSE    
        Log To Console    Condição de pagamento do pedido é diferente da Condição salva no database para o pedido número ${numeroPedido}. (Argumento: ${idCondicaoPagamento} / Database: ${data[0][0]})
        Fail
    END

Validar tipo cobranca
    [Documentation]    Irá validar se o Tipo de Cobrança salvo no banco de dados está de acordo com o argumento *idTipoCobranca*.
    [Arguments]    ${numeroPedido}    ${idTipoCobranca}

    ${data}    Query    select idtipocobranca from pedido where numeropedido = '${numeroPedido}'

    IF  '${data[0][0]}' == '${idTipoCobranca}'
        Log To Console    Tipo cobrança do pedido coincide com o banco de dados.
    ELSE    
        Log To Console    Tipo cobrança do pedido é diferente do Tipo cobrança salvo no database para o pedido número ${numeroPedido}. (Argumento: ${idTipoCobranca} / Database: ${data[0][0]})
        Fail
    END

Retornar numero ultimo pedido NF
    [Documentation]    Esta keyword retorna o número do último pedido lançado que possui situação = NÃO FINALIZADO.

    ${numeroPedido}    Query    ${sqlUltimoPedidoNF} 

    Log To Console    \nPedido número ${numeroPedido[0][0]}
    Return From Keyword    ${numeroPedido[0][0]} 

Retornar numero ultimo pedido
    [Documentation]    Esta keyword retorna o número do último pedido lançado.

    ${numeroPedido}    Query    ${sqlUltimoPedido} 

    Log To Console    \nPedido número ${numeroPedido[0][0]}
    Return From Keyword    ${numeroPedido[0][0]} 

Retornar informações dos produtos do pedido
    [Documentation]    Esta keyword retorna uma lista contendo informações do pedido de venda.
    [Arguments]    ${numeroPedido}
    
    ${sql}=    Set Variable
    ${sql}    Catenate    SEPARATOR=\n    
    ...    select pro.idproduto, pro.codigo, pp.quantidade, pp.precovenda 
    ...    from pedidoproduto pp
    ...    inner join pedido p on p.idpedido = pp.idpedido
    ...    inner join produto pro on pro.idproduto = pp.idproduto
    ...    where p.numeropedido = '${numeroPedido}'
    ...    order by pp.idproduto

    ${produtos}    Query    ${sql}    returnAsDict=True
    Return From Keyword    ${produtos}

Retornar situacao do pedido
    [Documentation]    Retorna a sigla do status do pedido passado como argumento.
    [Arguments]    ${numeroPedido}=None

    IF  '${numeroPedido}' != 'None'
        ${sql}=    Set Variable
        ${sql}    Catenate    SEPARATOR=\n
        ...    select tp.sgltiposituacaopedido from pedido p
        ...    inner join tiposituacaopedido tp on tp.idtiposituacaopedido = p.idtiposituacaopedido
        ...    where p.numeropedido = '${numeroPedido}'
    ELSE
        Log To Console    Nenhum pedido foi passado como argumento.
        Fail
    END

    ${situacaoPedido}    Query    ${sql}
    Return From Keyword    ${situacaoPedido[0][0]}

Retornar dados do pedido
    [Documentation]    Esta keyword retorna um dicionário contendo alguns dados do pedido passado como argumento.
    [Arguments]    ${numeroPedido}=None

    IF  '${numeroPedido}' != 'None'
        ${sql}=    Catenate    SEPARATOR=\n
        ...    select p.idparceiro as parceiro, p.idlocal as local, 
        ...    p.idlocalfilialvenda as filial,
        ...    p.idtipopedido as tipoPedido, p.idtabelapreco as tabelaPreco,
        ...    p.idcondicaopagamento as condicaoPagamento,
        ...    p.idtipocobranca as tipoCobranca
        ...    from pedido p where p.numeropedido = '${numeroPedido}'
    ELSE
        Log To Console    Nenhum pedido passado de argumento.
        Fail
    END
    
    ${dadosPedido}    Query    ${sql}    returnAsDict=True
    Return From Keyword    ${dadosPedido}    