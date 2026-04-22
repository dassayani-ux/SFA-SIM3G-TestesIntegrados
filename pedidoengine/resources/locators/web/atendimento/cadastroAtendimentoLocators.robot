*** Variables ***

${tituloPaginaAtendimento}    //*[@id="principal"]/div[1]/div/div[1]/h1[contains(text(),'Atendimento')]
${msgCarregando}    //*[@id="loading"]/div[2]/div[contains(text(),'Carregando...')]    #xpath
${loading}    minimalist-loading-background    #class

#CABEÇALHO
&{cabecalho}
...    idCabecalho=cabecalhoAtendimento    #id
...    pesquisaProfissional=//a[contains(@id,'btnPesquisarUSUARIO_USP')]    #xpath — lupa do campo Profissional
...    pesquisaRapidaProfissional=termSelection_NOME_USUARIO    #id — input de busca rápida dentro do popup
...    pesquisaCliente=//a[contains(@id,'btnPesquisarCLIENTE')]    #xpath — ID parcial estável, independente de posição
...    pesquisaRapidaCliente=termSelection_TERMO    #id
...    pesquisaLocal=//a[contains(@id,'btnPesquisarLOCAL')]    #xpath
...    pesquisaRapidaLocal=termSelection_LOCAL    #id
...    pesquisaTipoAtendimento=//a[contains(@id,'btnPesquisarTIPOATENDIMENTO')]    #xpath
...    pesquisaRapidaTipoAtendimento=termSelection_TIPOATENDIMENTO    #id
...    pesquisajustificativa=//a[contains(@id,'btnPesquisarTIPOJUSTIFICATIVA')]    #xpath
...    limpajustificativa=//a[contains(@id,'btnLimparTIPOJUSTIFICATIVA')]    #xpath
...    pesquisaRapidaJustificativa=termSelection_TIPOJUSTIFICATIVA    #id
...    pesquisaContato=//a[contains(@id,'btnPesquisarCONTATOShortcut_')]    #xpath — lupa do campo Contato (ID parcial estável, sufixo dinâmico ignorado)
...    limpaContato=//a[contains(@id,'btnLimparCONTATOShortcut_')]    #xpath — botão limpar do campo Contato
...    pesquisaRapidaContato=//input[contains(@class,'search-input-contato_contato')]    #xpath — input de busca do autocomplete de Contato
...    horaFim=txtHoraFim    #id
...    dataFim=txtDataFim    #id
...    txtObservacao=observacao    #id

${iniciarAtendimento}    btnIniciar    #id

${gravarAtendimento}    btnGravar    #id

${finalizarAtendimento}    btnFinalizar    #id

&{imagem}
...    guiaImagens=imagem-a    #id
...    incluirImagem=adicionarImagem    #id

&{popUpAtendimentosNaoFinalizados}
...    idPopUp=popup0    #id
...    btnCancelar=btnCancelar    #id

# Grid de seleção genérica (PROFISSIONAL, LOCAL, TIPO ATENDIMENTO, JUSTIFICATIVA)
# Todos os popups de seleção usam id="popup0" — o XPath é scoped para evitar match em grids de fundo
&{selecaoGrid}
...    primeiraLinha=(//*[@id="popup0"]//div[contains(@class,'slick-cell') and contains(@class,'l0')])[1]    #xpath — 1ª célula da 1ª linha da grid DENTRO do popup0
...    btnConfirmar=btnConfirmar    #id — botão Confirmar dentro do popup