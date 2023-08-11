*** Settings ***
Documentation    Arquivo utilizado para armazenar os localizadores de elementos necessários no processo de cadastro de pedido.

*** Variables ***
${botaoGravarPedio}    btnGravar    #id

&{cabecalhoPedido}
...    idCabecalho=panelCabecalho    #id
...    pesquisaCliente=//*[@id="panelCabecalho"]/div[2]/div/ul/li[@id="2"]/div/a[1]/span    #xpath
...    limpaPesquisaCLiente=//*[@id="panelCabecalho"]/div[2]/div/ul/li[@id="2"]/div/a[2]/span    #xpath
...    comboboxFilial=select2-cmbFilial-container    #id
...    comboboxTipoPedido=select2-cmbTipoPedido-container    #id
...    comboboxTabelaPreco=select2-cmbTabelaPreco-container    #id
...    comboboxCondicaoPagamento=select2-cmbCondicaoPagamento-container    #id
...    comboboxTipoCobranca=select2-cmbTipoCobranca-container    #id
...    comboboxLocal=select2-cmbLocal-container    #id
...    numeroPedido=//*[@id="principal"]/div[1]/div/div[1]/h1    #xpath
...    msgCarregando=//*[@class="jGrowl-message"][contains(text(),'Carregando...')]    #xpath

&{pesquisaCliente}
...    headerGridPedidos=//*[@id="popup0"]/div/div/div[2]/div/div/div/div[1]    #xpath
...    input=termSelection_TERMO    #id
...    pesquisaAvancada=btnExibePesquisaAvancada    #class
...    camposAtivos=panelPesquisa    #id
...    razaoSocial=termSelection_NOME_CLIENTE    #id
...    matricula=termSelection_MATRICULA_CLIENTE    #id
...    btnPesquisar=//*[@id="btnPesquisarSelection_CLIENTE"]/span    #xpath

&{pesquisaFilial}
...    idComboboxFilial=select2-cmbFilial-results    #id
...    itensFilial=//*[@id="select2-cmbFilial-results"]/li    #xpath

&{pesquisaTipoPedido}
...    idComboboxTipoPedido=select2-cmbTipoPedido-results    #id
...    itensTipoPedido=//*[@id="select2-cmbTipoPedido-results"]/li    #xpath

&{pesquisaTabelaPreco}
...    idComboboxTabelaPreco=select2-cmbTabelaPreco-results    #id
...    itensTabelaPreco=//*[@id="select2-cmbTabelaPreco-results"]/li    #xpath

&{pesquisaCondicaoPagamento}
...    idComboboxCondicaoPagamento=select2-cmbCondicaoPagamento-results    #id
...    itensCondicaoPagamento=//*[@id="select2-cmbCondicaoPagamento-results"]/li    #xpath

&{pesquisaTipoCobranca}
...    idComboboxTipoCobranca=select2-cmbTipoCobranca-results    #id
...    itensTipoCobranca=//*[@id="select2-cmbTipoCobranca-results"]/li    #xpath

${paceiroSelecionado}    //*[@id="inputPluginSearchCliente"]/div/a[1]    #xpath

&{carrinhoPedido}
...    campoProduto=//*[@id="panelGridCarrinho"]/div/div[4]/div/div/div[2]    #xpath
...    pesquisarProdutos=//*[@id="panelGridCarrinho"]/div/div[4]/div/div/div[2]/a/span    #xpath

&{pesquisaProdutosCarrinho}
...    telaPesquisa=//*[@id="popup0"]/div/div    #xpath
...    codigoProduto=txtCodigoPesquisa    #id
...    pesquisaProduto=btnPesquisar    #id
...    adicionarProduto=btnAdicionar    #id
...    confirmarProdutos=btnConfirmar    #id
...    selecionarProduto=//*[@id="pesquisaProdutos"]/div[2]/div[4]/div/div/div[1]/input    #xpath
...    campoQuantidade=//*[@id="pesquisaProdutos"]/div[2]/div[4]/div/div/div[6]    #xpath
...    inputCampoQuantidade= //*[@id="pesquisaProdutos"]/div[2]/div[4]/div/div/div[6]/input    #xpath

&{popUpPedidoGravado}
...    divPopUp=/html/body/div[3]    #xpath
...    msgGravadoSucesso=/html/body/div[3]/div/div[2]/div[contains(text(),'Pedido gravado com sucesso!')]    #xpath
...    btnOk=/html/body/div[3]/div/div[3]/button    #xpath