***Settings ***
Documentation   Pedido Variables

***Variables ***

${dialogCarregando}    //span[@class='carregando-only-message']

&{dialogMsg}
...    caixa=
...    btnSim=/div/div/div[3]/button[1]

&{cabecalho}
...    comboEstabelecimento=select2-cmbFilial-container
...    estabelecimento=//li[contains(text(), '{Estabelecimento}')]
...    comboProfissional=select2-cmbProfissional-container
...    profissional=//li[contains(text(),'{Profissional}')]
...    comboUnidade=select2-cmbSegmento-container
...    unidade=//li[contains(text(),'{Unidade}')]
...    lupaCliente=//span[@class='ui-button-icon-primary ui-icon ui-sim3g-icon-search']
...    campoPesquisaRapidaCliente=termSelection_TERMO
...    campoReplicarDesconto=//*[@id="txtAplicarDesconto"]
...    btnAplicarDesconto=//*[@id="btnAplicarDesconto"]/span
...    btnSimDesconto=//button[@type='button'][contains(.,'Sim')]
...    comboTipoFrete=select2-cmbCabecalhoTipoFrete-container
...    tipoFrete=//li[contains(text(),'{Frete}')]
...    comboVertical=select2-cmbVertical-container
...    vertical=//li[@class='select2-results__option' and contains(text(),'{Vertical}')]
...    btnPesquisaProjetos=//*[@id="btnPesquisaProjetos"]/span/span
...    primeiroProjetoGrid=//*[@id="popup0"]/div/div/div[2]/div/div/div/div[2]/div[4]/div/div/div[1]
...    btnConfirmar=//*[@id="btnConfirmar"]
...    campoDescricaoProjeto=//*[@id="txtDescricaoProjeto"]

&{gridCarrinho}
...    primeiraColuna=//*[@id="panelGridCarrinho"]/div/div[4]/div/div/div[3]
...    lupa=//*[@id="panelGridCarrinho"]/div/div[4]/div/div/div[3]/a/span


&{carrinhoColunas}
...    tituloProduto=//*[@title="Produto"]/span[1] 
...    dtEntrega=//*[@id="panelGridCarrinho"]/div/div[4]/div/div/div[14]
...    checkEntrega=//*[@id="columnpicker_21"]
...    tituloImposto=//*[@title="Valor impostos (ST + IPI)"]/span[1]

&{iconeImposto}
...    btnAtualizarImpostos=//span[@class='ui-button-content']
...    valorTotal=//*[@id="gridImpostos"]/div[4]/div/div[8]/div[3]
...    btnVoltar=//a[2]/span[@class='ui-button-content']
...    gridImpostos=//*[@id="gridImpostos"]/div[4]/div


# INICIO de variaveis que são de xpath das grids de produtos do carrinho do pedido, visto são dinâmicas e por enquanto é uma solução para funcionar
&{primeiroItem}
...    campoQtnd=//*[@id="panelGridCarrinho"]/div/div[4]/div/div[1]/div[4]
...    campoValorImposto=//*[@id="panelGridCarrinho"]/div/div[4]/div/div/div[12]
...    campoValorTotalComImposto=//*[@id="panelGridCarrinho"]/div/div[4]/div/div/div[13]
...    campoDesconto=//*[@id="panelGridCarrinho"]/div/div[4]/div/div[1]/div[8]
...    inputDesconto=//*[@id="panelGridCarrinho"]/div/div[4]/div/div[1]/div[8]/
...    iconeImposto=//*[@id="panelGridCarrinho"]/div/div[4]/div/div[1]/div[15]/a/img
...    iconeCalculado=//div[1]/div[15]/a/img[contains(@src,'/images/sim3g/minimalist/icons/16x16/mix_valor_verde.png')]
...    iconeImpostoNaoCalculado=//div[1]/div[15]/a/img[contains(@src,'/images/sim3g/minimalist/icons/16x16/mix_valor.png')]

&{segundoItem}
...    iconeImposto=//*[@id="panelGridCarrinho"]/div/div[4]/div/div[2]/div[15]/a/img
...    iconeImpostoNaoCalculado=//div[2]/div[15]/a/img[contains(@src,'/images/sim3g/minimalist/icons/16x16/mix_valor.png')]
...    iconeCalculado=//div[2]/div[15]/a/img[contains(@src,'/images/sim3g/minimalist/icons/16x16/mix_valor_verde.png')]
...    campoQtnd=//*[@id="panelGridCarrinho"]/div/div[4]/div/div[2]/div[4]

&{terceiroItem}
...    iconeImpostoNaoCalculado=//div[3]/div[15]/a/img[contains(@src,'/images/sim3g/minimalist/icons/16x16/mix_valor.png')]
...    iconeCalculado=//div[3]/div[15]/a/img[contains(@src,'/images/sim3g/minimalist/icons/16x16/mix_valor_verde.png')]
...    campoQtnd=//*[@id="panelGridCarrinho"]/div/div[4]/div/div[3]/div[4]

# FIM de variaveis que são de xpath das grids de produtos do pedido, visto são dinâmicas e por enquanto é uma solução para funcionar


&{cesta}
...    btnCesta=//*[@id="btnPesquisaSelecionadosAdicaoRapida"]/span
...    btnLupa=//*[@id="btnPesquisaRapidaProduto"]/span
...    btnConfimarNaGrid=//*[@id="btnConfirmarItemAdicaoRapida"]/span
...    codigoProduto1=//*[@id="selecionadosPesquisaRapida"]/div[1]/div[4]/div/div[1]/div[2]
...    codigoProduto2=//*[@id="selecionadosPesquisaRapida"]/div[1]/div[4]/div/div[2]/div[2]
...    codigoProduto3=//*[@id="selecionadosPesquisaRapida"]/div[1]/div[4]/div/div[3]/div[2]
...    btnConfirmar=//*[@id="btnConfirmar"]/span


&{dialogBuscaProduto}
...    listagem=//*[@id="popup0"]/div/div/div[2]/div
...    campoFiltroCodigo=txtCodigoPesquisa
...    campoFiltroDescricao=//*[@id="txtDescricaoPesquisa"]
...    btnPesquisar=//*[@id="btnPesquisar"]/span
...    produto=//*[@id="pesquisaProdutos"]/div[1]/div[4]/div/div/div[3]
...    qntd=(//div[contains(@class,'slick-cell lr l5 r5 ui-state-highlight')])[2]
...    precoVenda=//*[@id="pesquisaProdutos"]/div[1]/div[4]/div/div/div[7]
...    btnAdicionar=btnAdicionar
...    selecionarPrimeiroProdutoCesta=//*[@id="pesquisaRapidaProdutos"]/div[1]/div[4]/div/div/div[3]
...    selecionarProdutoCestaPosicao6=//*[@id="pesquisaRapidaProdutos"]/div[1]/div[4]/div/div[6]/div[3]
...    selecionarProdutoCestaPosicao8=//*[@id="pesquisaRapidaProdutos"]/div[1]/div[4]/div/div[8]/div[1]/input


&{entrega}
...    comboTransportadora=select2-cmbParceiroTransportador-container
...    opcaoTransporte=//*[@id="select2-cmbParceiroTransportador-results"]/li[contains(text(),'{Transporte}')]
...    valorFrete=//*[@id="txtValorFrete"]

&{produtoConfigurado}
...    txtInformacaoProdutoConfigurado=//*[@id="swal2-content"]/div/div/div and contains(text(),'É necessário configurar os seguintes produtos para que os impostos sejam calculados:')
...    btnOk=/html/body/div[4]/div/div[3]/button[1]
...    semImpostos=//*[@id="gridImpostos"]/div[4]/div

&{complemento}
...    obsPedido=//*[@id="id-5"]/textarea

&{iconeCliente}
...    icone=//*[@id="imgInformacoesParceiro"]
...    informacaoTituloCliente=/html/body/div[4]/div/div[1]/h2
...    informacaoCliente=//*[@id="divLabelInformacoes"]/div[1]/div[2]/span
...    informacaoNomeFantasia=//*[@id="divLabelInformacoes"]/div[2]/div[2]/span
...    informacaoTipoPessoa=//*[@id="divLabelInformacoes"]/div[3]/div[2]/span
...    informacaoCnpj=//*[@id="divLabelInformacoes"]/div[4]/div[2]/span
...    informacaoIE=//*[@id="divLabelInformacoes"]/div[5]/div[2]/span
...    informacaoGrupoCliente=//*[@id="divLabelInformacoes"]/div[6]/div[2]/span
...    informacaoCanalVenda=//*[@id="divLabelInformacoes"]/div[7]/div[2]/span
...    informacaoLocalEntrega=//*[@id="divLabelInformacoes"]/div[8]/div[2]
...    informacaoTransportadora=//*[@id="divLabelInformacoes"]/div[9]/div[2]/span
...    informacaoTelefone=//*[@id="divLabelInformacoes"]/div[10]/div[2]/span
...    informacaoEmail=//*[@id="divLabelInformacoes"]/div[11]/div[2]/span
...    cliente=//*[@id="divLabelInformacoes"]/div[1]/div[1]/span
...    nomeFantasia=//*[@id="divLabelInformacoes"]/div[2]/div[1]/span
...    tipoPessoa=//*[@id="divLabelInformacoes"]/div[3]/div[1]/span
...    cnpj=//*[@id="divLabelInformacoes"]/div[4]/div[1]/span
...    IE=//*[@id="divLabelInformacoes"]/div[5]/div[1]/span
...    grupoCliente=//*[@id="divLabelInformacoes"]/div[6]/div[1]/span
...    canalVenda=//*[@id="divLabelInformacoes"]/div[7]/div[1]/span
...    localEntrega=//*[@id="divLabelInformacoes"]/div[8]/div[1]/span
...    transportadora=//*[@id="divLabelInformacoes"]/div[9]/div[1]/span
...    telefone=//*[@id="divLabelInformacoes"]/div[10]/div[1]/span
...    email=//*[@id="divLabelInformacoes"]/div[11]/div[1]/span
...    vazio=

&{finalizacao}
...    btnConfirmar=btnConfirmar
...    btnCalcularImposto=//*[@id="btnCalcularImposto"]/span
...    btnGravar=btnGravarOrcamento
...    btnFinalizar=btnFinalizarOrcamento
...    btnGerarPedido=//*[@id="btnGerarPedido"]/span/span
...    btnEnviarEmail=//*[@id="btnEnviarEmail"]/span
...    btnRelatorio=//*[@id="idRelatorioBI"]/span
...    msgAprovacao=

&{dialogEnviarEmail}
...    btnCancelar=/html/body/div[1]/div[2]/div/main/div[1]/div[2]/div/div[2]/div/div/div[3]/div/a[1]
...    btnConfirmar=//*[@id="btnConfirmar"]
...    btnFechar=//*[@id="popup0"]/div/div/div[1]/div/div[2]/a/span

&{resumo}
...    iconeImposto=//*[@id="btnVisualizarImpostos"]


&{dialogFinalizacao}
...    txtInformacao=//*[@id="swal2-content" and contains(text(),'Um pedido finalizado não pode ser alterado. Tem certeza que deseja finalizar o pedido?')]
...    btnSim=/html/body/div[4]/div/div[3]/button[2]
...    btnNao=/html/body/div[4]/div/div[3]/button[1]

&{dialogAprovacao}
...    txtInformacao=//*[@id="swal2-content"]/ul/li/span[2]
...    btnSim=/html/body/div[4]/div/div[3]/button[2]
...    btnNao=/html/body/div[4]/div/div[3]/button[1]


${numeroPedido}    //*[@id="principal"]/div[1]/div/div[1]


${relatorio}
...    btnVoltar=//*[@id="voltar"]
...    btnPdf=//*[@id="relatorio-pdf"]
...    btnPlanilha=//*[@id="relatorio-xlsx"]
