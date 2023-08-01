*** Settings ***
Documentation    Arquivo utilizado para armazenar as keywords utilizadas no processo de cadastro de pedido de venda.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/locators/web/pedido/cadastroPedidoLocators.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/listagemClientesResource.robot
Resource    ${EXECDIR}/resources/data/pedido/dataPedido.robot
Resource    ${EXECDIR}/resources/variables/web/pedido/cadastroPedidoVariables.robot
Resource    ${EXECDIR}/resources/pages/web/pedido/listagemPedidoResources.robot
Library    ${EXECDIR}/libraries/lib_auxiliar.py

*** Keywords ***
Acessar cadastro de novo pedido
    [Documentation]    Keyword utilizada para acessar a tela de novo pedido na web.

    SeleniumLibrary.Click Element    id=${venda.menuVenda}
    SeleniumLibrary.Wait Until Element Is Visible    id=${venda.subMenuPedido}
    SeleniumLibrary.Click Element    id=${venda.subMenuPedido}
    SeleniumLibrary.Wait Until Element Is Visible    id=${venda.novoPedido}
    SeleniumLibrary.Click Element    id=${venda.novoPedido}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalhoPedido.idCabecalho}

Preenche cabecalho pedido
    [Documentation]    Keyword responsável por preencher os dados de cabeçalho do pedido de venda.
    Cabecalho - Parceiro
    Cabecalho - Filial
    Cabecalho - Tipo pedido
    Cabecalho - Tabela de preco
    Cabecalho - Condicao Pagamento
    Cabecalho - Tipo Cobranca
    Popula dicionario de dados do pedido

Cabecalho - Parceiro
    [Documentation]    Preenche a infomação de *Parceiro* no cabeçalho do pedido
    [Tags]    Pedido-Cabecalho

    ${parceiro}=    Retorna razao e matricula parceiro aleatorio
    SeleniumLibrary.Click Element    xpath=${cabecalhoPedido.pesquisaCliente}
    SeleniumLibrary.Wait Until Page Contains Element    class=${pesquisaCliente.pesquisaAvancada}
    SeleniumLibrary.Click Element    class=${pesquisaCliente.pesquisaAvancada}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaCliente.camposAtivos}
    SeleniumLibrary.Input Text    id=${pesquisaCliente.razaoSocial}    ${parceiro[0]}
    SeleniumLibrary.Input Text    id=${pesquisaCliente.matricula}    ${parceiro[1]}
    SeleniumLibrary.Click Element    xpath=${pesquisaCliente.btnPesquisar}
    Sleep    2s

Cabecalho - Filial
    [Documentation]    Preenche a informação de *Filial* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxFilial}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaFilial.idComboboxFilial}
    ${countFilial}    Get Element Count    xpath=${pesquisaFilial.itensFilial}
    FOR  ${I}  IN RANGE    ${2}    ${countFilial}+1
        ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaFilial.idComboboxFilial}"]/li[${I}]    
        Collections.Append To List    ${listaFiliais}    ${valor}
    END
    
    ${listaFiliais}=    Remove itens duplicados    @{listaFiliais}

    ${lenght}=    Get Length    ${listaFiliais}
    ${index}=    Evaluate    random.sample(range(0, ${lenght}),1)    random
    ${filial}=    Set Variable    ${listaFiliais[${index[0]}]}
    Log To Console    Filial selecionada: ${filial}
    SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaFilial.idComboboxFilial}"]/li[contains(text(),'${filial}')]
    Sleep    0.3s

Cabecalho - Tipo pedido
    [Documentation]    Preenche a informação de *Tipo pedido* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxTipoPedido}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaTipoPedido.idComboboxTipoPedido}
    ${countTipoPedido}    Get Element Count    xpath=${pesquisaTipoPedido.itensTipoPedido}
    FOR  ${I}  IN RANGE    ${2}    ${countTipoPedido}+1
        ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaTipoPedido.idComboboxTipoPedido}"]/li[${I}]    
        Collections.Append To List    ${listaTipoPedido}    ${valor}
    END
    
    ${listaTipoPedido}=    Remove itens duplicados    @{listaTipoPedido}

    ${lenght}=    Get Length    ${listaTipoPedido}
    ${index}=    Evaluate    random.sample(range(0, ${lenght}),1)    random
    ${tipoPedido}=    Set Variable    ${listaTipoPedido[${index[0]}]}
    Log To Console    Tipo pedido selecionado: ${tipoPedido}
    SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaTipoPedido.idComboboxTipoPedido}"]/li[contains(text(),'${tipoPedido}')]
    Sleep    0.3s

Cabecalho - Tabela de preco
    [Documentation]    Preenche a informação de *Tabela de preço* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxTabelaPreco}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaTabelaPreco.idComboboxTabelaPreco}
    ${countTabelaPreco}    Get Element Count    xpath=${pesquisaTabelaPreco.itensTabelaPreco}
    FOR  ${I}  IN RANGE    ${2}    ${countTabelaPreco}+1
        ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaTabelaPreco.idComboboxTabelaPreco}"]/li[${I}]    
        Collections.Append To List    ${listaTabelaPreco}    ${valor}
    END

    ${listaTabelaPreco}=    Remove itens duplicados    @{listaTabelaPreco}

    ${lenght}=    Get Length    ${listaTabelaPreco}
    ${index}=    Evaluate    random.sample(range(0, ${lenght}),1)    random
    ${tabelaPreco}=    Set Variable    ${listaTabelaPreco[${index[0]}]}
    Log To Console    Tabela de preço selecionada: ${tabelaPreco}
    SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaTabelaPreco.idComboboxTabelaPreco}"]/li[contains(text(),'${tabelaPreco}')]
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s

Cabecalho - Condicao Pagamento
    [Documentation]    Preenche a informação de *Condição de Pagamento* no cabeçalho do pedido.
    [Tags]    Pedido-Cabecalho

    SeleniumLibrary.Click Element    id=${cabecalhoPedido.comboboxCondicaoPagamento}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaCondicaoPagamento.idComboboxCondicaoPagamento}
    ${countCondicaoPagamento}    Get Element Count    xpath=${pesquisaCondicaoPagamento.itensCondicaoPagamento}
    FOR  ${I}  IN RANGE    ${2}    ${countCondicaoPagamento}+1
        ${valor}    SeleniumLibrary.Get Text    xpath=//*[@id="${pesquisaCondicaoPagamento.idComboboxCondicaoPagamento}"]/li[${I}]    
        Collections.Append To List    ${listaCondicaoPagamento}    ${valor}
    END

    ${listaCondicaoPagamento}=    Remove itens duplicados    @{listaCondicaoPagamento}

    ${lenght}=    Get Length    ${listaCondicaoPagamento}
    ${index}=    Evaluate    random.sample(range(0, ${lenght}),1)    random
    ${condicaoPagamento}=    Set Variable    ${listaCondicaoPagamento[${index[0]}]}
    Log To Console    Condição de pagamento selecionada: ${condicaoPagamento}
    SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaCondicaoPagamento.idComboboxCondicaoPagamento}"]/li[contains(text(),'${condicaoPagamento}')]
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s

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

        ${lenght}=    Get Length    ${listaTipoCobranca}
        ${index}=    Evaluate    random.sample(range(0, ${lenght}),1)    random
        ${tipoCobranca}=    Set Variable    ${listaTipoCobranca[${index[0]}]}
        Log To Console    Tipo de Cobrança selecionado: ${tipoCobranca}
        SeleniumLibrary.Click Element    xpath=//*[@id="${pesquisaTipoCobranca.idComboboxTipoCobranca}"]/li[contains(text(),'${tipoCobranca}')]
        Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s    
    END

Popula dicionario de dados do pedido
    [Documentation]    Está keyword irá popular o dicionário *\&{dadosPedido}* com informações úteis para a manipulação do pedido.
    [Tags]    Pedido-Dados

    ${txtNumeroPedido}=    SeleniumLibrary.Get Text    xpath=${cabecalhoPedido.numeroPedido}
    ${remove}=    String.Remove String    ${txtNumeroPedido}    [    ]    Pedido
    ${dadosPedido.numeroPedido}    Set Variable    ${remove[1:]}

    ${txtParceiro}=    SeleniumLibrary.Get Text    xpath=${paceiroSelecionado}
    ${removeVirgulaParceiro}=    String.Remove String    ${txtParceiro}    ;
    ${splitParceiro}=    String.Split String    ${removeVirgulaParceiro}    -
    ${dadosPedido.idParceiro}=    Retorna idparceiro    ${splitParceiro[0][0:-1]}    ${splitParceiro[2][1:]}

    ${txtParceiroLocal}=    SeleniumLibrary.Get Text    id=${cabecalhoPedido.comboboxLocal}
    ${dadosPedido.idLocalParceiro}=    Retorna idlocal    ${txtParceiroLocal} 

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

    SeleniumLibrary.Click Element    id=${botaoGravarPedio}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpPedidoGravado.divPopUp}
    SeleniumLibrary.Wait Until Page Contains Element    xpath=${popUpPedidoGravado.msgGravadoSucesso}
    SeleniumLibrary.Click Element    xpath=${popUpPedidoGravado.btnOk}

Incluir itens no pedido
    [Documentation]    Keyword utilizada para realizar a inclusão de itens no pedido de venda.
    ...    \nA quantidade de itens inclusos irá respeitar a variável *quantideItensPedido*.

    SeleniumLibrary.Click Element    xpath=${carrinhoPedido.campoProduto}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${carrinhoPedido.pesquisarProdutos}
    SeleniumLibrary.Click Element    xpath=${carrinhoPedido.pesquisarProdutos}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${pesquisaProdutosCarrinho.telaPesquisa}    10s

    ${countProdutos}=    Retorna quantidade de itens da tabela    ${dadosPedido.idTabelaPreco}
    ${randomProdutos}=    Evaluate    random.sample(range(0, ${countProdutos}), ${quantideItensPedido})    random
    ${produtos}=    Retorna produtos    @{randomProdutos}    tabelaPreco=${dadosPedido.idTabelaPreco}

    FOR  ${I}  IN RANGE    ${quantideItensPedido}
        SeleniumLibrary.Input Text    id=${pesquisaProdutosCarrinho.codigoProduto}    ${produtos[${I}]}
        SeleniumLibrary.Click Element    id=${pesquisaProdutosCarrinho.pesquisaProduto}
        SeleniumLibrary.Wait Until Element Is Enabled    xpath=${pesquisaProdutosCarrinho.selecionarProduto}
        SeleniumLibrary.Click Element    xpath=${pesquisaProdutosCarrinho.selecionarProduto}
        SeleniumLibrary.Click Element    id=${pesquisaProdutosCarrinho.adicionarProduto}
        SeleniumLibrary.Clear Element Text    id=${pesquisaProdutosCarrinho.codigoProduto}
    END
    
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaProdutosCarrinho.confirmarProdutos}
    SeleniumLibrary.Click Element    id=${pesquisaProdutosCarrinho.confirmarProdutos}