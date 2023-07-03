*** Variables ***

${tituloPaginaListagemCliente}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Listagem de clientes')]    #xpath

&{pesquisaRapida}
...        inputPesquisa=termo    #name
...        btnPesquisar=//*[@id="btnPesquisar"]/span    #xpath

&{gridClientes}
...    labelQtdeRegsitros=header-content    #class
...    campoRazaoSocial=//*[@id="grid_parceiro"]/div[5]/div/div[3]/div[1]    #xpath
...    btnEditar=//*[@id="grid_parceiro"]/div[5]/div/div[3]/div[6]/a/img    #xpath

&{pesquisaAvancada}
...    exibePesquisa=btnExibePesquisaAvancada    #class
...    camposAtivos=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset    #xpath
...    razaoSocial=parceiro    #name
...    fantasia=fantasia    #name
...    matricula=matricula    #name
...    tipoPessoaFisica=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[2]/label[2]   #xpath
...    tipoPessoaJuridica=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[2]/label[3]    #xpath
...    situacaoAtivo=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[4]/label[2]   #xpath
...    situacaoInativo=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[4]/label[3]    #xpath
...    btnPesquisaSituacaoAprovacao=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[6]/div/a[1]/span    #xpath
...    btnLimpaBuscaSituacaoAprovacao=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[6]/div/a[2]/span    #xpath
...    btnPesquisarLocal=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[12]/div/a[1]/span    #xpath
...    btnLimpaPesquisaLocal=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[12]/div/a[2]/span    #xpath
...    documento=documento    #name
...    matricula=matricula    #name
...    bairro=bairro    #name
...    logradouro=logradouro    #name
...    btnPesquisaUF=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[17]/div/a[1]/span    #xpath
...    btnLimpaPesquisaUF=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[17]/div/a[2]/span    #xpath
...    btnPesquisaCidade=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[18]/div/a[1]/span    #xpath
...    btnLimpaPesquisaCidade=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[18]/div/a[2]/span    #xpath
...    btnPesquisaProfissional=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[20]/div/a[1]/span    #xpath
...    btnLimpaPesquisaProfissional=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[20]/div/a[2]/span    #xpath
...    btnPesquisaClassificacao=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[22]/div/a[1]/span    #xpath
...    btnLimpaPesquisaClassificacao=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[22]/div/a[2]/span    #xpath
...    btnPesquisaSituacaoCadastro=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[25]/div/a[1]/span    #xpath
...    btnLimpaPesquisaSituacaoCadastro=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[25]/div/a[2]/span    #xpath

&{pesquisaSituacaoAprovacao}
...    input=termSelection_TIPOSITUACAOAPROVACAO    #id

&{pesquisaLocal}
...    input=termSelection_LOCAL    #id

&{pesquisaUnidadeFederativa}
...    input=termSelection_UNIDADEFEDERATIVA    #id

&{pesquisaCidade}
...    input=termSelection_CIDADE    #id

&{pesquisaProfissional}
...    input=termSelection_NOME_USUARIO    #id

&{pesquisaClassificacao}
...    input=termSelection_CLASSIFICACAOPARCEIRO    #id

&{pesquisaSituacaoCadastro}
...    input=termSelection_TIPOSITUACAOCADASTRO    #id

${cerregandoRegistros}    //*[@class="carregando-only-message"][contains(text(),'Carregando...')]    #xpath