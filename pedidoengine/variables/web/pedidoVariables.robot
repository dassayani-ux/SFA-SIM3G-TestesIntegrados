***Settings ***
Documentation   Pedido Variables

***Variables ***

&{cabecalho}
...    combo_estabelecimento=select2-cmbFilial-container
...    estabelecimento=//li[contains(text(), '{Estabelecimento}')]
...    combo_profissional=select2-cmbProfissional-container
...    profissional=//li[contains(text(),'{Profissional}')]
...    combo_unidade=select2-cmbSegmento-container
...    unidade=//li[contains(text(),'{Unidade}')]
...    lupa_cliente=//span[@class='ui-button-icon-primary ui-icon ui-sim3g-icon-search']
...    campo_pesquisa_rapida=termSelection_TERMO
...    combo_tipo_frete=select2-cmbCabecalhoTipoFrete-container
...    tipo_frete=//li[@class='select2-results__option' and contains(text(),'{Frete}')]
...    combo_vertical=select2-cmbVertical-container
...    vertical=//li[@class='select2-results__option' and contains(text(),'{Vertical}')]

&{grid_produto}
...    primeira_coluna=//*[@id="panelGridCarrinho"]/div/div[4]/div/div/div[3]
...    lupa=//*[@id="panelGridCarrinho"]/div/div[4]/div/div/div[3]/a/span

&{cesta}
...    cesta_lupa=//*[@id="btnPesquisaRapidaProduto"]/span
...    cesta_confimar=//*[@id="btnConfirmarItemAdicaoRapida"]/span

&{relatorio}
...    selecionar_btn_relatorio=//*[@id="idRelatorioBI"]/span

&{email}
...    selecionar_btn_email=//*[@id="btnEnviarEmail"]/span

&{dialog_busca_produto}
...    listagem=//*[@id="popup0"]/div/div/div[2]/div
...    campo_codigo=txtCodigoPesquisa
...    campo_descricao=//*[@id="txtDescricaoPesquisa"]
...    btn_pesquisar=//*[@id="btnPesquisar"]/span
...    produto=//*[@id="pesquisaProdutos"]/div[1]/div[4]/div/div/div[3]
...    qntd=(//div[contains(@class,'slick-cell lr l5 r5 ui-state-highlight')])[2]
...    preco_venda=//*[@id="pesquisaProdutos"]/div[1]/div[4]/div/div/div[7]
...    btn_adicionar=btnAdicionar
...    selecionar_primeiro_produto_cesta=//*[@id="pesquisaRapidaProdutos"]/div[1]/div[4]/div/div/div[3]
...    selecionar_produto_cesta2=//*[@id="pesquisaRapidaProdutos"]/div[1]/div[4]/div/div[6]/div[3]
&{entrega}
...    combo_transportadora=select2-cmbParceiroTransportador-container
...    opcao_transporte=//*[@id="select2-cmbParceiroTransportador-results"]/li[contains(text(),'{Transporte}')]
...    valor_frete=//*[@id="txtValorFrete"]

&{validar}
...    txt_informacao_produto_configurado=//*[@id="swal2-content"]/div/div/div and contains(text(),'É necessário configurar os seguintes produtos para que os impostos sejam calculados:')
...    btn_ok=/html/body/div[4]/div/div[3]/button[1]
...    sem_impostos=//*[@id="gridImpostos"]/div[4]/div

&{complemento}
...    obs_pedido=//*[@id="id-5"]/textarea

&{icone_imposto}
#produto 1 que refere ao primeiro item do carrinho
...    selecionar_icone_imposto_produto1=//*[@id="panelGridCarrinho"]/div/div[4]/div/div[1]/div[15]/a/img
...    icone_calculado=//div[1]/div[15]/a/img[contains(@src,'/totvscrmsfa/ID_1669635401965/images/sim3g/minimalist/icons/16x16/mix_valor_verde.png')]
...    selecionar_icone_imposto_produto2=//*[@id="panelGridCarrinho"]/div/div[4]/div/div[2]/div[15]/a/img
...    icone_nao_calculado=//div[2]/div[15]/a/img[contains(@src,'/totvscrmsfa/ID_1669635401965/images/sim3g/minimalist/icons/16x16/mix_valor.png')]
...    btn_atualizar_impostos=//span[@class='ui-button-content']
...    btn_voltar=//a[2]/span[@class='ui-button-content']
...    selecionar_icone_imposto_resumo=btnVisualizarImpostos

&{finalizacao}
...    btn_confirmar=btnConfirmar
...    btn_calcular_imposto=//*[@id="btnCalcularImposto"]/span
...    btn_gravar=btnGravarOrcamento
...    btn_finalizar=btnFinalizarOrcamento
...    btn_gerar_pedido=btnGerarPedido
...    msg_aprovacao=

&{dialog_finalizacao}
...    txt_informacao=//*[@id="swal2-content" and contains(text(),'Um pedido finalizado não pode ser alterado. Tem certeza que deseja finalizar o pedido?')]
...    btn_sim=/html/body/div[4]/div/div[3]/button[2]

&{dialog_aprovacao}
...    txt_informacao=//*[@id="swal2-content"]/ul/li/span[2]
...    btn_sim=/html/body/div[4]/div/div[3]/button[2]


${NUMERO PEDIDO}    //*[@id="principal"]/div[1]/div/div[1]
