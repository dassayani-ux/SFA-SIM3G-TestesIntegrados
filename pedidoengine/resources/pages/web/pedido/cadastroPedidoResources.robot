*** Settings ***
Documentation    Arquivo utilizado para armazenar as keywords utilizadas no processo de cadastro de pedido de venda.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/data/pedido/dataPedido.robot
Resource    ${EXECDIR}/resources/data/cliente/dataCliente.robot
Resource    ${EXECDIR}/resources/data/produto/dataProduto.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/locators/web/pedido/cadastroPedidoLocators.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/listagemClientesResource.robot
Resource    ${EXECDIR}/resources/variables/web/pedido/cadastroPedidoVariables.robot
Resource    ${EXECDIR}/resources/pages/web/pedido/listagemPedidoResources.robot

*** Keywords ***
Inativar pesquisa de Tipo Cobraca
    [Documentation]    Esta keyword é apenas temporária e tem por objetivo inativar a busca de cabeçalho no campo de _*Tipo Cobrança*_.
    ...    \n Esta keyword será utilizada até que seja encontrada/implementada uma forma de utilizar as pesquisas de cabeçalho nos testes automatizados.

    ${situacaoPesquisa}    Query    ${sqlPesquisaCabecalhoTipoCobranca}
    IF  '${situacaoPesquisa[0][1]}' == '${1}'
        DatabaseLibrary.Execute Sql String    update wsconfigpedidonivel set idnativo = 0 where idwsconfigpedidonivel = ${situacaoPesquisa[0][0]}
        Log To Console    Setado para inativa a pesquisa de tipo cobrança no cabeçalho do pedido.
    END

Acessar cadastro de novo pedido
    [Documentation]    Keyword utilizada para acessar a tela de novo pedido na web.

    SeleniumLibrary.Wait Until Element Is Enabled    id=${venda.menuVenda}
    SeleniumLibrary.Click Element    id=${venda.menuVenda}
    SeleniumLibrary.Wait Until Element Is Visible    id=${venda.subMenuPedido}
    SeleniumLibrary.Click Element    id=${venda.subMenuPedido}
    SeleniumLibrary.Wait Until Element Is Visible    id=${venda.novoPedido}
    SeleniumLibrary.Click Element    id=${venda.novoPedido}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalhoPedido.idCabecalho}

Preenche cabecalho pedido
    [Documentation]    Keyword responsável por preencher os dados de cabeçalho do pedido de venda.
    Cabecalho - Parceiro
    Cabecalho - Local Parceiro
    Cabecalho - Filial
    Cabecalho - Tipo pedido
    Cabecalho - Tabela de preco
    ${campoCondicaoPagamento}=    BuiltIn.Run Keyword And Ignore Error    SeleniumLibrary.Page Should Contain Element    id=${cabecalhoPedido.comboboxCondicaoPagamento}
    BuiltIn.Run Keyword If    '${campoCondicaoPagamento[0]}' == 'PASS'    Cabecalho - Condicao Pagamento
    #Cabecalho - Tipo Cobranca    --Comentado por hora pois na base utilizada o campo está ativo mas não editável.
    Cabecalho - Data de vencimento
    Popula dicionario de dados do pedido

Cabecalho - Parceiro
    [Documentation]    Preenche a infomação de *Parceiro* no cabeçalho do pedido
    [Tags]    Pedido-Cabecalho

    ${parceiro}=    Retornar razao, matricula e id de parceiro aleatorio
    SeleniumLibrary.Click Element    xpath=${cabecalhoPedido.pesquisaCliente}
    SeleniumLibrary.Wait Until Element Does Not Contain    xpath=${pesquisaCliente.headerGridPedidos}    (0) Registros
    SeleniumLibrary.Click Element    class=${pesquisaCliente.pesquisaAvancada}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaCliente.camposAtivos}
    SeleniumLibrary.Input Text    id=${pesquisaCliente.razaoSocial}    ${parceiro[0]}
    SeleniumLibrary.Input Text    id=${pesquisaCliente.matricula}    ${parceiro[1]}
    SeleniumLibrary.Click Element    xpath=${pesquisaCliente.btnPesquisar}
    ${dadosPedido.idParceiro}=    Set Variable    ${parceiro[2]}
    BuiltIn.Sleep    2s

Cabecalho - Local Parceiro
    [Documentation]    Preenche a informação de *local* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    SeleniumLibrary.Wait Until Element Is Enabled    id=${cabecalhoPedido.comboboxLocal}
    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxLocal}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaLocalParceiroPedido.idComboboxLocal}
    ${countLocal}    Get Element Count    xpath=${pesquisaLocalParceiroPedido.itensLocal}
    IF  ${countLocal} == ${1}
        BuiltIn.Fail    Não há local disponível para seleção!
    END
    FOR  ${I}  IN RANGE    ${2}    ${countLocal}+1
        ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaLocalParceiroPedido.idComboboxLocal}"]/li[${I}]    
        Collections.Append To List    ${listaLocais}    ${valor}
    END
    ${listaLocais}=    Remove itens duplicados    @{listaLocais}

    ${lenght}=    BuiltIn.Get Length    ${listaLocais}
    ${index}=    BuiltIn.Evaluate    random.sample(range(0, ${lenght}),1)    random
    ${local}=    BuiltIn.Set Variable    ${listaLocais[${index[0]}]}
    BuiltIn.Log To Console    Local selecionado: ${local}
    SeleniumLibrary.Input Text    class=select2-search__field    ${local}
    SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaLocalParceiroPedido.idComboboxLocal}"]/li[contains(text(),'${local}')]

Cabecalho - Filial
    [Documentation]    Preenche a informação de *Filial* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    SeleniumLibrary.Wait Until Element Is Enabled    id=${cabecalhoPedido.comboboxFilial}
    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxFilial}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaFilial.idComboboxFilial}
    ${countFilial}    Get Element Count    xpath=${pesquisaFilial.itensFilial}
    IF  ${countFilial} == ${1} 
        BuiltIn.Fail    Não há filial disponível para seleção!
    END
    FOR  ${I}  IN RANGE    ${2}    ${countFilial}+1
        ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaFilial.idComboboxFilial}"]/li[${I}]    
        Collections.Append To List    ${listaFiliais}    ${valor}
    END
    ${listaFiliais}=    Remove itens duplicados    @{listaFiliais}

    ${lenght}=    BuiltIn.Get Length    ${listaFiliais}
    ${index}=    BuiltIn.Evaluate    random.sample(range(0, ${lenght}),1)    random
    ${filial}=    BuiltIn.Set Variable    ${listaFiliais[${index[0]}]}
    Log To Console    Filial selecionada: ${filial}
    SeleniumLibrary.Input Text    class=select2-search__field    ${filial}
    SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaFilial.idComboboxFilial}"]/li[contains(text(),'${filial}')]

Cabecalho - Tipo pedido
    [Documentation]    Preenche a informação de *Tipo pedido* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxTipoPedido}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaTipoPedido.idComboboxTipoPedido}
    ${countTipoPedido}    Get Element Count    xpath=${pesquisaTipoPedido.itensTipoPedido}
    IF  ${countTipoPedido} == ${1} 
        BuiltIn.Fail    Não há tipo pedido disponível para seleção!
    END
    FOR  ${I}  IN RANGE    ${2}    ${countTipoPedido}+1
        ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaTipoPedido.idComboboxTipoPedido}"]/li[${I}]    
        Collections.Append To List    ${listaTipoPedido}    ${valor}
    END
    
    ${listaTipoPedido}=    Remove itens duplicados    @{listaTipoPedido}

    ${lenght}=    Get Length    ${listaTipoPedido}
    ${opcao}=    Set Variable    --Selecione--
    WHILE  '${opcao}' == '--Selecione--'
        ${index}=    BuiltIn.Evaluate    random.sample(range(0, ${lenght}),1)    random
        ${opcao}=    BuiltIn.Set Variable    ${listaTipoPedido[${index[0]}]}
    END
    ${tipoPedido}=    Set Variable    ${listaTipoPedido[${index[0]}]}
    Log To Console    Tipo pedido selecionado: ${tipoPedido}
    SeleniumLibrary.Input Text    class=select2-search__field    ${tipoPedido}
    SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaTipoPedido.idComboboxTipoPedido}"]/li[contains(text(),'${tipoPedido}')]

Cabecalho - Tabela de preco
    [Documentation]    Preenche a informação de *Tabela de preço* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxTabelaPreco}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaTabelaPreco.idComboboxTabelaPreco}
    ${countTabelaPreco}    Get Element Count    xpath=${pesquisaTabelaPreco.itensTabelaPreco}
    IF  ${countTabelaPreco} == ${1} 
        BuiltIn.Fail    Não há tabela de preço disponível para seleção!
    END
    FOR  ${I}  IN RANGE    ${2}    ${countTabelaPreco}+1
        ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaTabelaPreco.idComboboxTabelaPreco}"]/li[${I}]    
        Collections.Append To List    ${listaTabelaPreco}    ${valor}
    END

    ${listaTabelaPreco}=    Remove itens duplicados    @{listaTabelaPreco}

    ${lenght}=    BuiltIn.Get Length    ${listaTabelaPreco}
    ${index}=    BuiltIn.Evaluate    random.sample(range(0, ${lenght}),1)    random
    ${idTabela}=    Retorna idTabelaPreco    ${listaTabelaPreco[${index[0]}]}
    ${qtdProdutos}=    Retorna quantidade de itens da tabela    ${idTabela}

    WHILE  ${qtdProdutos} < ${quantideItensPedido}
        ${index}=    BuiltIn.Evaluate    random.sample(range(0, ${lenght}),1)    random
        ${idTabela}=    Retorna idTabelaPreco    ${listaTabelaPreco[${index[0]}]}
        ${qtdProdutos}=    Retorna quantidade de itens da tabela    ${idTabela}
    END

    ${tabelaPreco}=    Set Variable    ${listaTabelaPreco[${index[0]}]}
    Log To Console    Tabela de preço selecionada: ${tabelaPreco}
    SeleniumLibrary.Input Text    class=select2-search__field    ${tabelaPreco}
    SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaTabelaPreco.idComboboxTabelaPreco}"]/li[contains(text(),'${tabelaPreco}')]
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s

Cabecalho - Condicao Pagamento
    [Documentation]    Preenche a informação de *Condição de Pagamento* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxCondicaoPagamento}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaCondicaoPagamento.idComboboxCondicaoPagamento}
    ${countCondicaoPagamento}    Get Element Count    xpath=${pesquisaCondicaoPagamento.itensCondicaoPagamento}
    IF  ${countCondicaoPagamento} == ${1} 
        BuiltIn.Fail    Não há condição de pagamento disponível para seleção!
    END
    FOR  ${I}  IN RANGE    ${2}    ${countCondicaoPagamento}+1
        ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaCondicaoPagamento.idComboboxCondicaoPagamento}"]/li[${I}]    
        Collections.Append To List    ${listaCondicaoPagamento}    ${valor}
    END

    ${listaCondicaoPagamento}=    Remove itens duplicados    @{listaCondicaoPagamento}

    ${lenght}=    BuiltIn.Get Length    ${listaCondicaoPagamento}
    ${index}=    BuiltIn.Evaluate    random.sample(range(0, ${lenght}),1)    random
    ${condicaoPagamento}=    BuiltIn.Set Variable    ${listaCondicaoPagamento[${index[0]}]}
    Log To Console    Condição de pagamento selecionada: ${condicaoPagamento}
    SeleniumLibrary.Input Text    class=select2-search__field    ${condicaoPagamento}
    SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaCondicaoPagamento.idComboboxCondicaoPagamento}"]/li[contains(text(),'${condicaoPagamento}')]
    BuiltIn.Sleep    1s

Cabecalho - Tipo Cobranca
    [Documentation]    Preenche a informação de *Tipo Cobrança* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho
    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxTipoCobranca}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaTipoCobranca.idComboboxTipoCobranca}
    ${countTipoCobranca}    Get Element Count    xpath=${pesquisaTipoCobranca.itensTipoCobranca}
    IF  ${countTipoCobranca} > ${2}
        FOR  ${I}  IN RANGE    ${2}    ${countTipoCobranca}+1
            ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaTipoCobranca.idComboboxTipoCobranca}"]/li[${I}]    
            Collections.Append To List    ${listaTipoCobranca}    ${valor}
        END

        ${listaTipoCobranca}=    Remove itens duplicados    @{listaTipoCobranca}

        ${lenght}=    BuiltIn.Get Length    ${listaTipoCobranca}
        ${index}=    BuiltIn.Evaluate    random.sample(range(0, ${lenght}),1)    random
        ${tipoCobranca}=    BuiltIn.Set Variable    ${listaTipoCobranca[${index[0]}]}
        Log To Console    Tipo de Cobrança selecionado: ${tipoCobranca}
        SeleniumLibrary.Input Text    class=select2-search__field    ${tipoCobranca}
        SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaTipoCobranca.idComboboxTipoCobranca}"]/li[contains(text(),'${tipoCobranca}')]
    END

Cabecalho - Data de vencimento
    [Documentation]    Preenche a informação de *Data de vencimento* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    ${currentdate}=    Get Current Date    result_format=%d-%m-%Y
    SeleniumLibrary.Input Text    id=${cabecalhoPedido.campoDataVencimento}    ${currentdate}
    SeleniumLibrary.Press Keys    None    TAB

Popula dicionario de dados do pedido
    [Documentation]    Está keyword irá popular o dicionário *\&{dadosPedido}* com informações úteis para a manipulação do pedido.
    [Tags]    Pedido-Dados

    ${txtNumeroPedido}=    SeleniumLibrary.Get Text    xpath=${cabecalhoPedido.numeroPedido}
    ${remove}=    String.Remove String    ${txtNumeroPedido}    [    ]    Pedido
    ${dadosPedido.numeroPedido}    Set Variable    ${remove[1:]}

    IF  '${dadosPedido.idParceiro}' == ''    # Esse if existe pois quando o pedido está sendo lançado, é setado o id parceiro já, mas em edições não passa pelo processo do cabeçalho, então nesses casos esse IF preenche o idparceiro.
        ${dadosPedido.idParceiro}=    Retornar id parceiro do Pedido    ${dadosPedido.numeroPedido}
    END

    ${txtParceiroLocal}=    SeleniumLibrary.Get Text    id=${cabecalhoPedido.comboboxLocal}
    ${dadosPedido.idLocalParceiro}=    Retorna idlocal    ${txtParceiroLocal}    ${dadosPedido.idParceiro}

    ${txtFilial}=    SeleniumLibrary.Get Text    id=${cabecalhoPedido.comboboxFilial}
    ${dadosPedido.idLocalFilial}=    Retorna idLocalFilial    ${txtFilial}

    ${txtTipoPedido}=    SeleniumLibrary.Get Text    id=${cabecalhoPedido.comboboxTipoPedido}
    ${dadosPedido.idTipoPedido}=    Retorna idTipoPedido    ${txtTipoPedido}   

    ${txtTabelaPreco}=    SeleniumLibrary.Get Text    id=${cabecalhoPedido.comboboxTabelaPreco}
    ${dadosPedido.idTabelaPreco}=    Retorna idTabelaPreco    ${txtTabelaPreco}

    ${txtCondicaoPagamento}=    SeleniumLibrary.Get Text    id=${cabecalhoPedido.comboboxCondicaoPagamento}
    ${dadosPedido.idCondicaoPagamento}=    Retorna idCondicaoPagamento    ${txtCondicaoPagamento}

    ${txtTipoCobranca}=    SeleniumLibrary.Get Text    id=${cabecalhoPedido.comboboxTipoCobranca}
    ${dadosPedido.idTipoCobranca}=    Retorna idTipoCobranca    ${txtTipoCobranca}
    
Remove itens duplicados
    [Documentation]    Esta keyword irá remover todos os itens da lista que possuem mais de uma ocorrência.
    [Arguments]    @{lista}
    [Tags]    Keyword-Auxiliar
    
    ${controlador}=    Set Variable    ${0}
    WHILE  ${controlador} != ${1}
        ${lenght}=    Get Length    ${lista}
        FOR  ${I}  IN RANGE    ${lenght}
            ${countOcorrencia}    Collections.Get Match Count    ${lista}    ${lista[${I}]}
            IF  ${countOcorrencia} > 1
                Remove Values From List    ${lista}    ${lista[${I}]}
                BREAK
            END    
            ${lenght2}=    Get Length    ${lista}
            ${ultimo}=    Set Variable    ${lenght2}
            ${ultimo}=    Evaluate    ${ultimo} - 1
            IF  ${lenght2} == ${lenght} and '${lista[${I}]}' == '${lista[${ultimo}]}'
                ${controlador}=    Set Variable    ${1}
            END       
        END      
    END

    Return From Keyword    ${lista}

Gravar pedido de venda
    [Documentation]    Esta keyword é responsável por gravar o pedido de venda.

    SeleniumLibrary.Scroll Element Into View    id=${botaoGravarPedio}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${botaoGravarPedio}
    SeleniumLibrary.Click Element    id=${botaoGravarPedio}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpPedidoGravado.divPopUp}
    SeleniumLibrary.Wait Until Page Contains Element    xpath=${popUpPedidoGravado.msgGravadoSucesso}
    SeleniumLibrary.Click Element    xpath=${popUpPedidoGravado.btnOk}

Finalizar pedido de venda
    [Documentation]    Esta keyword é responsável por finalizar o pedido de venda na tela de cadastro de pedido.

    SeleniumLibrary.Scroll Element Into View    id=${botaoFinalizarPedido}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${botaoFinalizarPedido}
    SeleniumLibrary.Click Element    id=${botaoFinalizarPedido}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpFinalizarPedido.divPopUp}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${popUpFinalizarPedido.btnSim}
    SeleniumLibrary.Click Element    xpath=${popUpFinalizarPedido.btnSim}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpFinalizarPedido.msgFinalizadoSucesso}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${popUpFinalizarPedido.btnOk}
    SeleniumLibrary.Click Element    xpath=${popUpFinalizarPedido.btnOk}

    ${situacao}=    Retornar situacao do pedido    numeroPedido=${dadosPedido.numeroPedido}
    IF  '${situacao}' == 'PP'
        Log To Console    Pedido finalizado com sucesso.
    ELSE
        Log To Console    Pedido não encontra-se finalizado no banco de dados.
        Fail
    END

Incluir itens no pedido
    [Documentation]    Keyword utilizada para realizar a inclusão de itens no pedido de venda.
    ...    \nA quantidade de itens inclusos irá respeitar a variável *quantideItensPedido*.
    [Tags]    Pedido-Itens
    [Arguments]    ${edicao}=False

    BuiltIn.Sleep    1s
    SeleniumLibrary.Click Element    xpath=${carrinhoPedido.campoProduto}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${carrinhoPedido.pesquisarProdutos}
    SeleniumLibrary.Click Element    xpath=${carrinhoPedido.pesquisarProdutos}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${pesquisaProdutosCarrinho.telaPesquisa}    10s
    SeleniumLibrary.Wait Until Page Does Not Contain Element    class=${loading}

    ${countProdutos}=    Retorna quantidade de itens da tabela    ${dadosPedido.idTabelaPreco}
    ${randomProdutos}=    Evaluate    random.sample(range(0, ${countProdutos}), ${quantideItensPedido})    random
    ${produtos}=    Retorna produtos    @{randomProdutos}    tabelaPreco=${dadosPedido.idTabelaPreco}
    ${controlador}=    Set Variable    ${1}

    IF  '${edicao}' == 'True'    # Verifica se a inclusão de itens será feita em uma edição de pedido, caso sim, executará os passos presentes nesse bloco.
        WHILE  ${controlador} == ${1}    # Dentro desse laço de repetição será verificado se os novos produtos são idênticos aos informados no pedido original, caso sejam serão sorteados novos produtos.
            FOR    ${produto}    IN    @{produtos}    # Verifica se os produtos novos são idênticos aos produtos originais excluídos.
                ${result}    Collections.Count Values In List    ${produtosOriginais}    ${produto}
                IF  ${result} != ${0}    # Será executado caso o novo produto seja encontrado na lista dos produtos excluídos, caso seja verdadeiro irá sortear os produtos novamente.
                    ${randomProdutos}=    Evaluate    random.sample(range(0, ${countProdutos}), ${quantideItensPedido})    random
                    ${produtos}=    Retorna produtos    @{randomProdutos}    tabelaPreco=${dadosPedido.idTabelaPreco}
                ELSE
                    ${controlador}=    Set Variable    ${0}
                END
            END
        END
    END

    Log To Console    Produtos selecionados: ${produtos}
    
    FOR  ${I}  IN RANGE    ${quantideItensPedido}
        SeleniumLibrary.Input Text    id=${pesquisaProdutosCarrinho.codigoProduto}    ${produtos[${I}]}
        SeleniumLibrary.Click Element    id=${pesquisaProdutosCarrinho.pesquisaProduto}
        #SeleniumLibrary.Wait Until Element Is Enabled    xpath=${pesquisaProdutosCarrinho.selecionarProduto}
        #SeleniumLibrary.Click Element    xpath=${pesquisaProdutosCarrinho.selecionarProduto}
        ${qtdApresentacao}=    Retornar quantidade apresentacao produto    codigoProduto=${produtos[${I}]}
        ${qtdApresentacao}=    BuiltIn.Convert To Integer    ${qtdApresentacao}
        ${qtde}=    Evaluate    round(random.randint(1, round(${quantidadeMaximaProduto}/${qtdApresentacao})) * ${qtdApresentacao})    random    #Randomiza uma quantidade múltipla da quantidade de apresentação do produto, em um intervalor de 1 a ${quantidadeMaximaProduto}.
        SeleniumLibrary.Wait Until Element Is Enabled    xpath=${pesquisaProdutosCarrinho.campoQuantidade}
        SeleniumLibrary.Click Element    ${pesquisaProdutosCarrinho.campoQuantidade}
        SeleniumLibrary.Wait Until Element Is Visible   ${pesquisaProdutosCarrinho.inputCampoQuantidade}
        SeleniumLibrary.Clear Element Text    ${pesquisaProdutosCarrinho.inputCampoQuantidade}
        SeleniumLibrary.Press Keys    ${pesquisaProdutosCarrinho.inputCampoQuantidade}    ${qtde}
        SeleniumLibrary.Click Element    id=${pesquisaProdutosCarrinho.adicionarProduto}
        BuiltIn.Sleep    1s
        SeleniumLibrary.Wait Until Page Does Not Contain Element    xpath=${msgCarregandoItemPedido}    60s
        SeleniumLibrary.Clear Element Text    id=${pesquisaProdutosCarrinho.codigoProduto}
    END
    
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaProdutosCarrinho.confirmarProdutos}
    SeleniumLibrary.Click Element    id=${pesquisaProdutosCarrinho.confirmarProdutos}

Validar pedido no banco de dados
    [Documentation]    Esta keyword irá validar se os dados do pedido armazenados no banco de dados estão de acordo. Para isso, será utilizado o dicionário criado *_dadosPedido_*.
    
    Log To Console    ...::: INÍCIO DA VALIDAÇÃO DO PEDIDO NO BANCO DE DADOS :::...
    Validar se o pedido consta no banco de dados    ${dadosPedido.numeroPedido}
    Validar parceiro do pedido    ${dadosPedido.numeroPedido}    ${dadosPedido.idParceiro}
    Validar local do pedido    ${dadosPedido.numeroPedido}    ${dadosPedido.idLocalParceiro}
    Validar filial do pedido    ${dadosPedido.numeroPedido}    ${dadosPedido.idLocalFilial}
    Validar tipo do pedido    ${dadosPedido.numeroPedido}    ${dadosPedido.idTipoPedido}
    Validar tabela de preço    ${dadosPedido.numeroPedido}    ${dadosPedido.idTabelaPreco}
    Validar condicao de pagamento    ${dadosPedido.numeroPedido}    ${dadosPedido.idCondicaoPagamento}
    Validar tipo cobranca    ${dadosPedido.numeroPedido}    ${dadosPedido.idTipoCobranca}
    Log To Console    ...::: FIM DA VALIDAÇÃO DO PEDIDO NO BANCO DE DADOS :::...

Excluir itens originais e incluir novos
    [Documentation]    Esta keyword remove todos os produtos atuais do pedido de venda e inclui novos.

    ${dadosProdutos}    Retornar informações dos produtos do pedido    ${dadosPedido.numeroPedido}
    FOR    ${produto}    IN    @{dadosProdutos}
        Append To List    ${produtosOriginais}    ${produto['codigo']}
    END
    Log To Console    Produtos orginais do pedido: ${produtosOriginais}.

    SeleniumLibrary.Click Element    xpath=${carrinhoPedido.selecionarTodos}
    SeleniumLibrary.Click Element    id=${carrinhoPedido.removerProdutos}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${carrinhoPedido.confirmarRemocaoProduto}
    SeleniumLibrary.Click Element    xpath=${carrinhoPedido.confirmarRemocaoProduto}
    Sleep    0.5s

    Incluir itens no pedido    edicao=True
    Gravar pedido de venda

    ${dadosProdutosedicao}    Retornar informações dos produtos do pedido    ${dadosPedido.numeroPedido}
    FOR    ${produto}    IN    @{dadosProdutosedicao}
        Append To List    ${produtosAlterados}    ${produto['codigo']}
    END

    Sleep    1s

Verificar informações do pedido clonado
    [Documentation]    Esta keyword verifica se os dados do pedido clonado estão de acordo com os dados do pedido original.
    ...    \nO argumento *numeroPedidoOriginal* deve receber o valor do número do pedido original.
    [Arguments]    ${numeroPedidoOriginal}

    ${dadosPedidoOriginal}=    Retornar dados do pedido    ${numeroPedidoOriginal}    # Pedido original
    Popula dicionario de dados do pedido    # Pedido clonado
    
    Log To Console    ...::: INÍCIO DA COMPARAÇÃO DOS DADOS DO PEDIDO CLONADO :::...
    Verificar parceiro do pedido clonado    ${dadosPedidoOriginal[0]['parceiro']}
    Verificar local do pedido clonado    ${dadosPedidoOriginal[0]['local']}
    Verificar filial do pedido clonado    ${dadosPedidoOriginal[0]['filial']}
    Verificar tipo do pedido clonado    ${dadosPedidoOriginal[0]['tipopedido']}
    Verificar tabela de preco do pedido clonado    ${dadosPedidoOriginal[0]['tabelapreco']}
    Verificar condicao de pagamento do pedido clonado    ${dadosPedidoOriginal[0]['condicaopagamento']}
    Verificar tipo cobranca do pedido clonado    ${dadosPedidoOriginal[0]['tipocobranca']}
    Log To Console    ...::: FIM DA COMPARAÇÃO DOS DADOS DO PEDIDO CLONADO :::...
    
    Validar pedido no banco de dados

    Log To Console    ...::: INÍCIO DA COMPARAÇÃO DOS PRODUTOS DO PEDIDO CLONADO :::...
    ${dadosProdutoOriginal}    Retornar informações dos produtos do pedido    ${numeroPedidoOriginal}
    ${dadosProdutoClonado}    Retornar informações dos produtos do pedido    ${dadosPedido.numeroPedido}

    Verificar código dos produtos no pedido clonado    produtosOriginais=${dadosProdutoOriginal}    produtosClonados=${dadosProdutoClonado}
    Verificar quantidades dos produtos no pedido clonado    produtosOriginais=${dadosProdutoOriginal}    produtosClonados=${dadosProdutoClonado}
    Verificar precos dos produtos no pedido clonado    produtosOriginais=${dadosProdutoOriginal}    produtosClonados=${dadosProdutoClonado}
    Log To Console    ...::: FIM DA COMPARAÇÃO DOS PRODUTOS DO PEDIDO CLONADO :::...

Verificar parceiro do pedido clonado
    [Documentation]    Verifica se o parceiro do pedido clonado é o mesmo que o do pedido original.
    [Tags]    Pedido-clonado-cabecalho
    [Arguments]    ${parceiro}

    IF  ${dadosPedido.idParceiro} == ${parceiro}
        Log To Console    Parceiro do pedido clonado é o mesmo que o do pedido original.
    ELSE
        Log To Console    Parceiro selecionado no pedido clonado está diferente do parceiro informado no pedido original.
        Fail 
    END

Verificar local do pedido clonado
    [Documentation]    Verifica se o local do parceiro do pedido clonado é o mesmo que o do pedido original.
    [Tags]    Pedido-clonado-cabecalho
    [Arguments]    ${local}

    IF  ${dadosPedido.idLocalParceiro} == ${local}
        Log To Console    Local do pedido clonado é o mesmo que o do pedido original.
    ELSE
        Log To Console    Local selecionado no pedido clonado está diferente do local informado no pedido original.
        Fail 
    END

Verificar filial do pedido clonado
    [Documentation]    Verifica se a filial do pedido clonado é a mesma que a do pedido original.
    [Tags]    Pedido-clonado-cabecalho
    [Arguments]    ${filial}

    IF  ${dadosPedido.idLocalFilial} == ${filial}
        Log To Console    Filial do pedido clonado é a mesma que a do pedido original.
    ELSE
        Log To Console    Filial selecionada no pedido clonado está diferente da filial informada no pedido original.
        Fail 
    END

Verificar tipo do pedido clonado
    [Documentation]    Verifica se o tipo do pedido clonado é o mesmo que o do pedido original.
    [Tags]    Pedido-clonado-cabecalho
    [Arguments]    ${tipoPedido}

    IF  ${dadosPedido.idTipoPedido} == ${tipoPedido}
        Log To Console    Tipo do pedido clonado é o mesmo que o do pedido original.
    ELSE
        Log To Console    Tipo de pedido clonado está diferente do tipo de pedido informado no pedido original.
        Fail 
    END

Verificar tabela de preco do pedido clonado
    [Documentation]    Verifica se a tabela de preço do pedido clonado é a mesma que a do pedido original.
    [Tags]    Pedido-clonado-cabecalho
    [Arguments]    ${tabelaPreco}

    IF  ${dadosPedido.idTabelaPreco} == ${tabelaPreco}
        Log To Console    Tabela de preço do pedido clonado é a mesma que a do pedido original.
    ELSE
        Log To Console    Tabela de preço selecionada no pedido clonado está diferente da tabela de preço informada no pedido original.
        Fail 
    END

Verificar condicao de pagamento do pedido clonado
    [Documentation]    Verifica se a condição de pagamento do pedido clonado é a mesma que a do pedido original.
    [Tags]    Pedido-clonado-cabecalho
    [Arguments]    ${condicaoPagamento}

    IF  ${dadosPedido.idCondicaoPagamento} == ${condicaoPagamento}
        Log To Console    Condição de pagamento do pedido clonado é a mesma que a do pedido original.
    ELSE
        Log To Console    Condição de pagamento selecionada no pedido clonado está diferente da condição de pagamento informada no pedido original.
        Fail 
    END

Verificar tipo cobranca do pedido clonado
    [Documentation]    Verifica se o tipo de cobrança do pedido clonado é o mesmo que o do pedido original.
    [Tags]    Pedido-clonado-cabecalho
    [Arguments]    ${tipoCobranca}

    IF  ${dadosPedido.idTipoCobranca} == ${tipoCobranca}
        Log To Console    Tipo de cobrança do pedido clonado é o mesmo que o do pedido original.
    ELSE
        Log To Console    Tipo de cobrança selecionado no pedido clonado está diferente do tipo de cobrança informado no pedido original.
        Fail 
    END

Verificar código dos produtos no pedido clonado
    [Documentation]    Valida se os códigos dos produtos presentes no pedido clonado são os mesmos que o do pedido original.
    [Tags]    Pedido-clonado-produtos
    [Arguments]    ${produtosOriginais}    ${produtosClonados}

    ${lenght}=    Get Length    ${produtosOriginais}

    FOR  ${I}  IN RANGE    ${lenght}
        IF  '${produtosOriginais[${I}]['codigo']}' == '${produtosClonados[${I}]['codigo']}'
            Log To Console    Produto ${produtosClonados[${I}]['codigo']} está presente no pedido clonado.
        ELSE
            Log To Console    Produto ${produtosOriginais[${I}]['codigo']} não foi encontrado no pedido clonado.
            Fail
        END
    END

Verificar quantidades dos produtos no pedido clonado
    [Documentation]    Valida se as quantidades dos produtos presentes no pedido clonado são as mesmas que o do pedido original.
    [Tags]    Pedido-clonado-produtos
    [Arguments]    ${produtosOriginais}    ${produtosClonados}

    ${lenght}=    Get Length    ${produtosOriginais}

    FOR  ${I}  IN RANGE    ${lenght}
        IF  '${produtosOriginais[${I}]['quantidade']}' == '${produtosClonados[${I}]['quantidade']}'
            Log To Console    Produto ${produtosClonados[${I}]['codigo']} está com a quantidade correta no pedido clonado.
        ELSE
            Log To Console    Produto ${produtosOriginais[${I}]['codigo']} não está com a quantidade correta no pedido clonado.
            Fail
        END
    END

Verificar precos dos produtos no pedido clonado
    [Documentation]    Valida se os preços dos produtos presentes no pedido clonado são os mesmos que o do pedido original.
    [Tags]    Pedido-clonado-produtos
    [Arguments]    ${produtosOriginais}    ${produtosClonados}

    ${lenght}=    Get Length    ${produtosOriginais}

    FOR  ${I}  IN RANGE    ${lenght}
        IF  '${produtosOriginais[${I}]['precovenda']}' == '${produtosClonados[${I}]['precovenda']}'
            Log To Console    Produto ${produtosClonados[${I}]['codigo']} está com o preço correto no pedido clonado.
        ELSE
            Log To Console    Produto ${produtosOriginais[${I}]['codigo']} não está com o preço correto no pedido clonado.
            Fail
        END
    END