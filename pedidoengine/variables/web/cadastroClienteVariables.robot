***Settings ***
Documentation   Cadastro de Clientes Variables

***Variables ***

&{infoAdicionais}
...    tituloTela=cabecalhoCliente
...    cmbEstabelecimento=//*[@id="CAMPO_ADICIONAL_1"]
...    opcEstabelecimento=//*[@id="CAMPO_ADICIONAL_1"]/option[contains(text(),'{Estabelecimento}')]
...    cmbMarca=//*[@id="CAMPO_ADICIONAL_2"]
...    opcMarca=//*[@id="CAMPO_ADICIONAL_2"]/option[contains(text(),'{Marca}')]
...    cmbCanalVendas=//*[@id="CAMPO_ADICIONAL_3"]
...    opcCanalVendas=//*[@id="CAMPO_ADICIONAL_3"]/option[contains(text(),'{CanalVendas}')]
...    cmbRegimeST=//*[@id="CAMPO_ADICIONAL_4"]
...    opcRegimeST=//*[@id="CAMPO_ADICIONAL_4"]/option[contains(text(),'{RegimeST}')]
...    produtoST=//*[@id="CAMPO_ADICIONAL_5"]
...    opcProdutoST=//*[@id="CAMPO_ADICIONAL_5"]/option[contains(text(),'{ProdutoST}')]
...    dtVencimento=//*[@id="CAMPO_ADICIONAL_6"]
...    cmbCondicaoPagamento=//*[@id="CAMPO_ADICIONAL_7"]
...    opcCondicaoPagamento=//*[@id="CAMPO_ADICIONAL_7"]/option[contains(text(),'{CondicaoPag}')]
...    desconto=//*[@id="CAMPO_ADICIONAL_8"]
...    cmbTabelaPreco=//*[@id="CAMPO_ADICIONAL_9"]
...    opcTabelaPreco=//*[@id="CAMPO_ADICIONAL_9"]/option[contains(text(),'{TabelaPreco}')]
...    cmbTransportador=//*[@id="CAMPO_ADICIONAL_10"]
...    opcTransporte=//*[@id="CAMPO_ADICIONAL_10"]/option[contains(text(),'{Transporte}')]
...    cmbRepresentante=//*[@id="CAMPO_ADICIONAL_11"]
...    opcRepresentante=//*[@id="CAMPO_ADICIONAL_11"]/option[contains(text(),'{Representante}')]
...    cmbRegiao=//*[@id="CAMPO_ADICIONAL_12"]
...    opcRegiao=//*[@id="CAMPO_ADICIONAL_12"]/option[contains(text(),'{Regiao}')]
...    cmbGerente=//*[@id="CAMPO_ADICIONAL_13"]
...    opcGerente=//*[@id="CAMPO_ADICIONAL_13"]/option[contains(text(),'{Gerente}')]
...    cmbGrupoCliente=//*[@id="CAMPO_ADICIONAL_14"]
...    opcGrupoCliente=//*[@id="CAMPO_ADICIONAL_14"]/option[contains(text(),'{GrupoCliente}')]


&{logotipo}
...    btnLogotipo=//*[@id="btnUpload"]/span

&{geral}
...    optSituacao=
...    optTipoPessoa=//*[@id="abaGeralParceiro"]/ul/li[3]/label[2]
...    optContribuinte=//*[@id="abaGeralParceiro"]/ul/li[4]/label[3]
...    cnpj=//*[@id="abaConsultaCliente"]/div/ul/li[1]/input
...    btnConsulta=//*[@id="btnConsultarSintegra"]/span
...    dialogConsultaCNPJ=/html/body/div[4]/div/div[2]/span
...    inscEstadual=//*[@id="sintegra-inscricao-estadual-input"]
...    optInsento=//*[@id="abaConsultaCliente"]/div/ul/li[3]/label[2]
...    inscMunicipal=//*[@id="sintegra-inscricao-municipal-input"]
...    cnae=//*[@id="sintegra-cnae-input"]
...    inscSuframa=//*[@id="sintegra-inscr-suframa-input"]
...    nome=//*[@id="abaGeralParceiro"]/ul/li[6]/input
...    fantasia=//*[@id="nomeparceirofantasia"]/input
...    codCliente=//*[@id="abaGeralParceiro"]/ul/li[8]/input
...    homepage=//*[@id="abaGeralParceiro"]/ul/li[9]/input
...    cmbSitCadastro=//*[@id="tiposituacaocadastro"]


&{geralComplemento}
...    numFunc=//*[@id="panelComplementoPessoaJuridico"]/ul/li[1]/input
...    dataFundacao=/html/body/div[1]/div[2]/div/main/div/div[2]/div/div/div/div[6]/form/div[4]/div[2]/div[1]/ul/li[2]/input
...    vlrFatura=//*[@id="panelComplementoPessoaJuridico"]/ul/li[3]/input
...    vlrCapSocial=//*[@id="panelComplementoPessoaJuridico"]/ul/li[4]/input
...    vlrCapSubs=//*[@id="panelComplementoPessoaJuridico"]/ul/li[5]/input
...    vlrCapIntegral=//*[@id="panelComplementoPessoaJuridico"]/ul/li[6]/input


&{local}
...    descricao=local_descricao
...    cnpj=local_documentoidentificacao
...    logradouro=local_logradouro
...    numero=local_numero
...    bairro=local_bairro
...    complemento=local_complemento
...    cep=local_cep
...    caixaPostal=local_caixapostal
...    uf=cmbUF
...    cidade=cmbCidade
...    limiteCredito=local_limitesugerido
...    telefone=txtTelefoneLocal
...    email=txtEmailLocal


&{docIdentificacao}
...    cartProdutor=tipoidentificacao_local_cartaoprodutor
...    inscEstadual=inscricao-estadual-input
...    inscMunicipal=tipoidentificacao_local_inscricaomunicipal
...    inscSuframa=tipoidentificacao_local_inscricaosuframa


&{compLocal}
...    tipoLocal=cmbTipoLocal
...    cmbPraca=//*[@id="cmbRegiao"]
...    observacao=local_observacao

&{gravar}
...    btnGravar=btnGravar
...    validacao=//*[@id="jGrowl"]
...    msgSucesso=Cadastrado com sucesso.

#elementos do menu que aparece após gravar com sucesso 
&{menuGravar}
...    btnContinuarEdt=//*[@id="popup0"]/div/div/div[2]/div/div/ul/li[1]/a/span