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
...    matricula=matricula    #name
...    tipoPessoaFisica=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[2]/label[2]   #xpath
...    tipoPessoaJuridica=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[2]/label[3]    #xpath
...    situacaoAtivo=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[4]/label[2]   #xpath
...    situacaoInativo=//*[@id="principal"]/div[2]/div/div/div[1]/fieldset/div[1]/ul/div/form/ul/li[4]/label[3]    #xpath

${cerregandoRegistros}    //*[@class="carregando-only-message"][contains(text(),'Carregando...')]    #xpath