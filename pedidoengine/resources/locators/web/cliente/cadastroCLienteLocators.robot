*** Settings ***
Documentation    Arquivo utilizado para armazenar a localização dos componentes utilizados no processo de cadastro de cliente.

*** Variables ***
${tituloPaginaCadastroCLiente}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Cadastro de cliente')]    #xpath

&{cabecalhoCliente}
...    idCabecalho=cabecalhoCliente    #id

&{geralCliente}
...    pessoaFisica=//*[@id="abaGeralParceiro"]/ul/li[3]/label[contains(text(),'Física')]    #xpath
...    pessoajuridica=//*[@id="abaGeralParceiro"]/ul/li[3]/label[contains(text(),'Jurídica')]    #xpath
...    contribuinte=//*[@id="abaGeralParceiro"]/ul/li[4]/label[contains(text(),'Sim')]    #xpath
...    naoContribuinte=//*[@id="abaGeralParceiro"]/ul/li[4]/label[contains(text(),'Não')]    #xpath
...    nomeCliente=parceiro_nomeparceiro    #name
...    fantasiaCliente=parceiro_nomeparceirofantasia    #name
...    numeroMatricula=parceiro_numeromatricula    #name
...    expandeClassificacao=parceiro_classificacaoparceiro    #name
...    classificacaoConsumidorFinal=//*[@id="abaGeralParceiro"]/ul/li[8]/select/option[contains(text(),'Consumidor Final')]    #xpath
...    homepage=parceiro_homepage    #name

&{complementoClienteJuridico}
...    cnpj=pessoajuridica_documentoidentificacao    #name
...    numeroFuncionarios=pessoajuridica_numerofuncionarios    #name
...    dataFundacao=pessoajuridica_datafundacao    #name
...    valorFaturamento=pessoajuridica_valorfaturamento    #name
...    valorCapitalSocial=pessoajuridica_valorcapitalsocial    #name
...    valorCapitalSubscrito=pessoajuridica_valorcapitalsubscrito    #name
...    valorCapitalIntegral=pessoajuridica_valorcapitalintegral    #name

&{localGeralClienteJuridico}
...    descricao=local_descricao    #name
...    logradouro=local_logradouro    #name
...    numero=local_numero    #name
...    bairro=local_bairro    #name
...    cep=local_cep    #name
...    uf=cmbUF    #id
...    comboCidade=cmbCidade    #id    
...    limteCredito=local_limitesugerido    #id
...    telefone=txtTelefoneLocal    #id
...    email=txtEmailLocal    #id

${btnGravarCadastro}    btnGravar    #id
${btnCancelarCadastro}    btnCancelar    #id

&{dadosIdentificacao}
...    inscricaoEstadual=inscricao-estadual-input     #id
...    inscricaoMunicipal=tipoidentificacao_local_inscricaomunicipal    #name
...    inscricaoSuframa=tipoidentificacao_local_inscricaosuframa    #name

&{localComplemento}
...    tipoLocal=cmbTipoLocal    #id
...    tipologia=cmbTipologia    #id
...    regiao=cmbRegiao    #id 
...    segmento=cmbSegmento    #id
...    tabelaPreco=cmbTabelaPreco    #id
...    condicaoPagamento=cmbCondicaoPagamento    #id
...    tipoCobranca=cmbTipoCobranca    #id
...    precoBase=local_precobase    #id
...    observacao=local_observacao    #name

${cadastroBemSucedido}    jGrowl    #id 

&{popUpAcoes}
...    popUp=//*[@id="principal"]/div[2]/div/div[2]/div   #xpath 
...    listaClientes=//*[@id="principal"]/div[2]/div/div[2]/div/div/div[2]/div/div/ul/li[5]   #xpath

&{edicaoCliente}
...    edicaoLocal=//*[@id="grid_local"]/div[5]/div/div[3]/div[4]/a/img    #xpath