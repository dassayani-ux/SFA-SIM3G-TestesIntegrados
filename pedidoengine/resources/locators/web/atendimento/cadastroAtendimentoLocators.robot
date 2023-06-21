*** Variables ***

${tituloPaginaAtendimento}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Atendimento')]

#CABEÇALHO
&{cabecalho}
...    idCabecalho=cabecalhoAtendimento    #id
...    pesquisaCliente=//*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[3]/div/a[1]    #xpath
...    pesquisaRapidaCliente=termSelection_TERMO    #id
...    pesquisaLocal=//*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[4]/div/a[1]    #xpath
...    pesquisaRapidaLocal=termSelection_LOCAL    #id
...    pesquisaTipoAtendimento=//*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[5]/div/a[1]    #xpath
...    pesquisaRapidaTipoAtendimento=termSelection_TIPOATENDIMENTO    #id
...    pesquisajustificativa=//*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[10]/div/a[1]    #xpath
...    pesquisaRapidaJustificativa=termSelection_TIPOJUSTIFICATIVA    #id
...    horaFim=txtHoraFim    #id
...    dataFim=txtDataFim    #id

${iniciarAtendimento}    btnIniciar    #id

${gravarAtendimento}    btnGravar    #id

${finalizarAtendimento}    btnFinalizar    #id

&{imagem}
...    guiaImagens=imagem-a    #id
...    incluirImagem=adicionarImagem    #id