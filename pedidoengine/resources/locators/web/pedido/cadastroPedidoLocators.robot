*** Settings ***
Documentation    Arquivo utilizado para armazenar os localizadores de elementos necessários no processo de cadastro de pedido.

*** Variables ***
${loading}    minimalist-loading-background    #class — overlay geral de loading
${loadingDiv}    minimalist-loading-div    #class — overlay específico do formulário de pedido (cobre botões do cabeçalho)
${msgCarregandoItemPedido}    /html/body/div[4]/div/div[2]/span    #class

${botaoGravarPedio}    btnGravar    #id
${botaoFinalizarPedido}    btnFinalizar    #id

&{cabecalhoPedido}
...    idCabecalho=panelCabecalho    #id
...    pesquisaProfissional=select2-cmbProfissional-container    #id — select2 do campo Profissional
...    pesquisaCliente=//a[contains(@id,'btnPesquisarCLIENTEShortcut_')]    #xpath — lupa do campo Cliente (ID parcial estável, sufixo dinâmico ignorado)
...    limpaPesquisaCLiente=//a[contains(@id,'btnLimparCLIENTEShortcut_')]    #xpath — botão limpar do campo Cliente
...    comboboxLocal=select2-cmbLocal-container    #id
...    comboboxFilial=select2-cmbFilial-container    #id
...    comboboxTipoPedido=select2-cmbTipoPedido-container    #id
...    comboboxTabelaPreco=select2-cmbTabelaPreco-container    #id
...    comboboxCondicaoPagamento=select2-cmbCondicaoPagamento-container    #id
...    comboboxTipoCobranca=select2-cmbTipoCobranca-container    #id
...    comboboxLocal=select2-cmbLocal-container    #id
...    numeroPedido=//*[@id="principal"]/div[1]/div/div[1]/h1    #xpath
...    msgCarregando=//*[@class="jGrowl-message"][contains(text(),'Carregando...')]    #xpath
...    campoDataVencimento=dtCabecalhoDataPrevistaFaturamento    #id

&{pesquisaProfissionalPedido}
...    input=termSelection_NOME_PROFISSIONAL    #id — popup do campo PROFISSIONAL no cabeçalho do pedido
...    btnPesquisar=//*[@id="btnPesquisarSelection_PROFISSIONAL"]/span    #xpath

&{pesquisaCliente}
...    headerGridPedidos=//*[@id="popup0"]/div/div/div[2]/div/div/div/div[1]    #xpath
...    input=termSelection_TERMO    #id
...    pesquisaAvancada=btnExibePesquisaAvancada    #class
...    camposAtivos=panelPesquisa    #id
...    razaoSocial=termSelection_NOME_CLIENTE    #id
...    matricula=termSelection_MATRICULA_CLIENTE    #id
...    btnPesquisar=//*[@id="btnPesquisarSelection_CLIENTE"]/span    #xpath
...    primeiraLinhaGrid=(//*[@id="popup0"]//div[contains(@class,'slick-cell') and contains(@class,'l0')])[1]    #xpath — 1ª célula da 1ª linha do resultado
...    btnConfirmar=//*[@id="popup0"]//*[@id="btnConfirmar"]    #xpath — botão Confirmar dentro do popup0

&{pesquisaFilial}
...    idComboboxFilial=select2-cmbFilial-results    #id
...    itensFilial=//*[@id="select2-cmbFilial-results"]/li    #xpath

&{pesquisaLocalParceiroPedido}
...    idComboboxLocal=select2-cmbLocal-results    #id
...    itensLocal=//*[@id="select2-cmbLocal-results"]/li    #xpath

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
...    selecionarTodos=//*[@id="panelGridCarrinho"]/div/div[1]/div/div[1]/span    #xpath
...    removerProdutos=btnRemoverSelecao    #id
...    confirmarRemocaoProduto=/html/body/div[4]/div/div[3]/button[2]    #xpath

&{pesquisaProdutosCarrinho}
...    telaPesquisa=//*[@id="popup0"]/div/div    #xpath
...    codigoProduto=txtCodigoPesquisa    #id
...    pesquisaProduto=btnPesquisar    #id
...    adicionarProduto=btnAdicionar    #id
...    confirmarProdutos=btnConfirmar    #id
...    selecionarProduto=//*[@id="pesquisaProdutos"]/div[2]/div[4]/div/div/div[1]/input    #xpath
...    campoQuantidade=//*[@id="pesquisaProdutos"]/div[2]/div[4]/div/div/div[7]    #xpath
...    inputCampoQuantidade=//*[@id="pesquisaProdutos"]/div[2]/div[4]/div/div/div[7]/input    #xpath

&{popUpPedidoGravado}
...    divPopUp=/html/body/div[4]    #xpath
...    msgGravadoSucesso=/html/body/div[4]/div/div[2]/div[contains(text(),'Pedido gravado com sucesso!')]    #xpath
...    btnOk=/html/body/div[4]/div/div[3]/button    #xpath

&{popUpFinalizarPedido}
...    divPopUp=/html/body/div[4]/div    #xpath
...    btnSim=/html/body/div[4]/div/div[3]/button[2]    #xpath
...    msgFinalizadoSucesso=/html/body/div[4]/div/div[2]/div[contains(text(),'Pedido finalizado com sucesso')]    #xpath
...    btnOk=/html/body/div[4]/div/div[3]/button    #xpath