*** Settings ***
Documentation    Arquivo utilizado para armazenas as palavras chaves utilizadas no processo de cadastro de atendimento.

Resource    ${EXECDIR}/pedidoengine/resources/lib/web/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/data/local/dataLocal.robot
Resource    ${EXECDIR}/pedidoengine/resources/data/cliente/dataCliente.robot
Resource    ${EXECDIR}/pedidoengine/resources/data/atendimento/dataAtendimento.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/atendimento/cadastroAtendimentoLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/variables/web/atendimento/cadastroAtendimentoVariables.robot


*** Keywords ***
Acessar tela de lançamento de atendimento
    [Documentation]    Utilizada para acessar a tela de cadastro de novo atendimento.
    SeleniumLibrary.Wait Until Element Is Visible    id=${menuAtendimento.menuAtendimento}
    SeleniumLibrary.Click Element    id=${menuAtendimento.menuAtendimento}
    SeleniumLibrary.Wait Until Element Is Visible    id=${menuAtendimento.novoAtendimento}
    SeleniumLibrary.Click Element    id=${menuAtendimento.novoAtendimento}
    SeleniumLibrary.Wait Until Page Contains Element    ${tituloPaginaAtendimento}    20

Preencher cabeçalho do atendimento
    [Documentation]    Esta keyword preenche os campos do cabeçalho do atendimento.
    ...    Ordem dos campos baseada no fluxo Cypress (novoatendimento.cy.js):
    ...    Profissional → Cliente → Local → Tipo Atendimento → Contato (condicional) → Justificativa (condicional) → Observação
    ...    A condicional de Contato e Justificativa usa a visibilidade real na UI como critério principal,
    ...    pois a atendimentoconfig pode não estar vinculada ao perfil mas o campo ainda ser exibido.
    [Tags]    atendimento-cabecalho

    ${config}=    Retornar dados de campos da config atendimento

    Preencher profissional no cabecalho do atendimento
    Preencher cliente no cabecalho do atendimento
    Preencher local do cliente no cabecalho do atendimento
    Preencher tipo atendimento no cabecalho do atendimento

    # Contato: preenche se o campo estiver visível na UI OU se a config do banco indicar exibição
    ${contatoNaUI}=    BuiltIn.Run Keyword And Return Status
    ...    SeleniumLibrary.Element Should Be Visible    xpath=${cabecalho.pesquisaContato}
    IF    ${contatoNaUI} or '${config['contato']}' == '${1}'
        Preencher contato no cabecalho do atendimento
    END

    # Justificativa: mesma lógica — UI tem prioridade sobre a config do banco
    ${justificativaNaUI}=    BuiltIn.Run Keyword And Return Status
    ...    SeleniumLibrary.Element Should Be Visible    xpath=${cabecalho.pesquisajustificativa}
    IF    ${justificativaNaUI} or '${config['justificativa']}' == '${1}'
        Preencher jutstificativa no cabecalho do atendimento
    END

    Preencher observacao no cabecalho do atendimento

Preencher profissional no cabecalho do atendimento
    [Documentation]    Irá preencher o campo Profissional no cabeçalho do atendimento.
    ...    Usa o usuário "automação" como profissional.
    ...    ⚠️ O SFA pode abrir uma aba de Dashboard como efeito colateral ao selecionar o profissional.
    ...    Por isso, ao final desta keyword, eventuais abas extras são fechadas e o foco volta ao formulário.
    [Arguments]    ${profissional}=${EMPTY}
    [Tags]    atendimento-cabecalho

    IF    '${profissional}' == '${EMPTY}'
        ${profissional}=    Retornar nome profissional atendimento
    END
    SeleniumLibrary.Scroll Element Into View    xpath=${cabecalho.pesquisaProfissional}
    SeleniumLibrary.Click Element    xpath=${cabecalho.pesquisaProfissional}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaProfissional}    15s
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaProfissional}    ${profissional}
    SeleniumLibrary.Press Keys    None    ENTER
    ${gridVisivel}=    BuiltIn.Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    xpath=${selecaoGrid.primeiraLinha}    3s
    IF    ${gridVisivel}
        # Race condition: popup pode fechar por auto-seleção entre o check de visibilidade e o click.
        # Se o click falhar (popup já fechado), o campo já foi preenchido pelo ENTER — ignora silenciosamente.
        ${clicouLinha}=    BuiltIn.Run Keyword And Return Status
        ...    SeleniumLibrary.Click Element    xpath=${selecaoGrid.primeiraLinha}
        IF    ${clicouLinha}
            SeleniumLibrary.Wait Until Element Is Enabled    id=${selecaoGrid.btnConfirmar}
            SeleniumLibrary.Click Element    id=${selecaoGrid.btnConfirmar}
        END
    END
    SeleniumLibrary.Wait Until Element Is Not Visible    id=${cabecalho.pesquisaRapidaProfissional}    15s
    # O SFA abre uma aba de Dashboard ao selecionar o profissional — fecha todas as extras e volta ao formulário
    BuiltIn.Sleep    0.5s
    ${janelas}=    SeleniumLibrary.Get Window Handles
    ${qtdJanelas}=    BuiltIn.Get Length    ${janelas}
    IF    ${qtdJanelas} > ${1}
        FOR    ${janela}    IN    @{janelas}[1:]
            SeleniumLibrary.Switch Window    ${janela}
            SeleniumLibrary.Close Window
        END
        SeleniumLibrary.Switch Window    MAIN
    END
    # Garante que ainda estamos no formulário de atendimento (caso o SFA tenha navegado na mesma aba)
    ${noFormulario}=    BuiltIn.Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Page Contains Element    id=${cabecalho.idCabecalho}    5s
    IF    not ${noFormulario}
        BuiltIn.Log To Console    ⚠️ Formulário de atendimento perdido após seleção de profissional — navegando de volta.
        SeleniumLibrary.Go Back
        SeleniumLibrary.Wait Until Page Contains Element    id=${cabecalho.idCabecalho}    15s
    END
    BuiltIn.Log To Console    Profissional preenchido: ${profissional}

Preencher cliente no cabecalho do atendimento
    [Documentation]    Irá preencher o campo de cliente no cabeçalho do Atendimento.
    [Arguments]    ${cliente}=${EMPTY}
    [Tags]    atendimento-cabecalho

    IF  '${cliente}' == '${EMPTY}'
        ${dicCliente}    Retornar cliente ativo
        ${dadosAtendimento.idParceiro}    Set Variable    ${dicCliente['id']}
        ${cliente}    Set Variable    ${dicCliente['nome']}
    ELSE
        ${dadosAtendimento.idParceiro}    Set Variable    ${cliente} 
    END
    SeleniumLibrary.Scroll Element Into View    xpath=${cabecalho.pesquisaCliente}
    SeleniumLibrary.Click Element    xpath=${cabecalho.pesquisaCliente}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaCliente}    15s
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaCliente}    ${cliente}
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Element Is Not Visible    id=${cabecalho.pesquisaRapidaCliente}    15s

    ${popUp}=    BuiltIn.Run Keyword And Ignore Error    SeleniumLibrary.Page Should Contain Element    id=${popUpAtendimentosNaoFinalizados.idPopUp}
    BuiltIn.Run Keyword If    '${popUp[0]}' == 'PASS'    SeleniumLibrary.Click Element    id=${popUpAtendimentosNaoFinalizados.btnCancelar}

Preencher local do cliente no cabecalho do atendimento
    [Documentation]    Irá preencher o campo de local do cliente no cabeçalho do Atendimento.
    [Arguments]    ${descricaoLocal}=${EMPTY}
    [Tags]    atendimento-cabecalho

    IF  '${descricaoLocal}' == '${EMPTY}'
        ${descricaoLocal}    Retornar descricao local    ${dadosAtendimento.idParceiro}
        ${dadosAtendimento.descricaoLocalParceiro}    Set Variable    ${descricaoLocal}
    ELSE
        ${dadosAtendimento.descricaoLocalParceiro}    Set Variable    ${descricaoLocal} 
    END
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${cabecalho.pesquisaLocal}    ${10}
    SeleniumLibrary.Click Element    xpath=${cabecalho.pesquisaLocal}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaLocal}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaLocal}    ${descricaoLocal}
    SeleniumLibrary.Press Keys    None    ENTER
    # Quando há mais de 1 resultado o SFA exibe uma grid — clica na 1ª linha e confirma.
    # Com exatamente 1 resultado o popup fecha sozinho (pisca e já seleciona).
    ${gridVisivel}=    BuiltIn.Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    xpath=${selecaoGrid.primeiraLinha}    3s
    IF    ${gridVisivel}
        # Race condition: popup pode fechar por auto-seleção entre o check de visibilidade e o click.
        # Se o click falhar (popup já fechado), o campo já foi preenchido pelo ENTER — ignora silenciosamente.
        ${clicouLinha}=    BuiltIn.Run Keyword And Return Status
        ...    SeleniumLibrary.Click Element    xpath=${selecaoGrid.primeiraLinha}
        IF    ${clicouLinha}
            SeleniumLibrary.Wait Until Element Is Enabled    id=${selecaoGrid.btnConfirmar}
            SeleniumLibrary.Click Element    id=${selecaoGrid.btnConfirmar}
        END
    END
    SeleniumLibrary.Wait Until Element Is Not Visible    id=${cabecalho.pesquisaRapidaLocal}    15s

Preencher tipo atendimento no cabecalho do atendimento
    [Documentation]    Irá preencher o campo de tipo atendimento no cabeçalho do atendimento.
    [Arguments]    ${tipoAtendimento}=${EMPTY}
    [Tags]    atendimento-cabecalho

    IF  '${tipoAtendimento}' == '${EMPTY}'
        ${tipoAtendimento}=    Retornar descricao tipo atendimento
    END

    IF    '${tipoAtendimento}' == '${EMPTY}'
        BuiltIn.Log To Console    ℹ️ Nenhum tipo de atendimento disponível — campo ignorado.
        RETURN
    END

    ${dadosAtendimento.descricaoTipoAtendimento}    Set Variable    ${tipoAtendimento}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${cabecalho.pesquisaTipoAtendimento}    ${10}
    SeleniumLibrary.Click Element    xpath=${cabecalho.pesquisaTipoAtendimento}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaTipoAtendimento}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaTipoAtendimento}    ${tipoAtendimento}
    SeleniumLibrary.Press Keys    None    ENTER
    # Mesma lógica: múltiplos resultados → grid; 1 resultado → fecha sozinho.
    ${gridVisivel}=    BuiltIn.Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    xpath=${selecaoGrid.primeiraLinha}    3s
    IF    ${gridVisivel}
        # Race condition: popup pode fechar por auto-seleção entre o check de visibilidade e o click.
        # Se o click falhar (popup já fechado), o campo já foi preenchido pelo ENTER — ignora silenciosamente.
        ${clicouLinha}=    BuiltIn.Run Keyword And Return Status
        ...    SeleniumLibrary.Click Element    xpath=${selecaoGrid.primeiraLinha}
        IF    ${clicouLinha}
            SeleniumLibrary.Wait Until Element Is Enabled    id=${selecaoGrid.btnConfirmar}
            SeleniumLibrary.Click Element    id=${selecaoGrid.btnConfirmar}
        END
    END
    SeleniumLibrary.Wait Until Element Is Not Visible    id=${cabecalho.pesquisaRapidaTipoAtendimento}    15s

Preencher jutstificativa no cabecalho do atendimento
    [Documentation]    Irá preencher o campo de justificativa no cabeçalho do atendimento.
    ...    Se não houver justificativas no banco, ignora o campo sem falhar.
    [Arguments]    ${justificativa}=${EMPTY}
    [Tags]    atendimento-cabecalho

    IF  '${justificativa}' == '${EMPTY}'
        ${justificativa}=    Retornar descricao justificativa atendimento
    END

    IF    '${justificativa}' == '${EMPTY}'
        BuiltIn.Log To Console    ℹ️ Nenhuma justificativa disponível — campo ignorado.
        RETURN
    END

    ${dadosAtendimento.descricaoJustificativa}    Set Variable    ${justificativa}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${cabecalho.pesquisajustificativa}    ${10}
    SeleniumLibrary.Click Element    xpath=${cabecalho.limpajustificativa}
    SeleniumLibrary.Click Element    xpath=${cabecalho.pesquisajustificativa}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaJustificativa}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaJustificativa}    ${justificativa}
    SeleniumLibrary.Press Keys    None    ENTER
    # Mesma lógica do LOCAL: com múltiplos resultados aparece grid; com 1 resultado fecha sozinho.
    ${gridVisivel}=    BuiltIn.Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    xpath=${selecaoGrid.primeiraLinha}    3s
    IF    ${gridVisivel}
        # Race condition: popup pode fechar por auto-seleção entre o check de visibilidade e o click.
        # Se o click falhar (popup já fechado), o campo já foi preenchido pelo ENTER — ignora silenciosamente.
        ${clicouLinha}=    BuiltIn.Run Keyword And Return Status
        ...    SeleniumLibrary.Click Element    xpath=${selecaoGrid.primeiraLinha}
        IF    ${clicouLinha}
            SeleniumLibrary.Wait Until Element Is Enabled    id=${selecaoGrid.btnConfirmar}
            SeleniumLibrary.Click Element    id=${selecaoGrid.btnConfirmar}
        END
    END
    SeleniumLibrary.Wait Until Element Is Not Visible    id=${cabecalho.pesquisaRapidaJustificativa}    15s

Preencher contato no cabecalho do atendimento
    [Documentation]    Irá preencher o campo de contato no cabeçalho do atendimento (quando ativo na config).
    ...    Segue o mesmo padrão dos outros campos lupa do SFA: clica a lupa, aguarda o popup aparecer,
    ...    tenta os IDs de input em sequência (para de testar ao achar o primeiro válido),
    ...    digita o contato, ENTER, seleciona na grid se necessário e confirma.
    [Arguments]    ${contato}=${EMPTY}
    [Tags]    atendimento-cabecalho

    IF  '${contato}' == '${EMPTY}'
        ${contato}=    Retornar contato parceiro    ${dadosAtendimento.idParceiro}
        IF    '${contato}' == '${EMPTY}'
            BuiltIn.Log To Console    ℹ️ Nenhum contato disponível — campo ignorado.
            RETURN
        END
    END
    ${dadosAtendimento.descricaoContato}    Set Variable    ${contato}

    # Limpa seleção anterior antes de pesquisar (se o botão limpar estiver presente)
    ${btnLimpar}=    BuiltIn.Run Keyword And Return Status
    ...    SeleniumLibrary.Page Should Contain Element    xpath=${cabecalho.limpaContato}
    BuiltIn.Run Keyword If    ${btnLimpar}    SeleniumLibrary.Click Element    xpath=${cabecalho.limpaContato}

    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${cabecalho.pesquisaContato}    10s
    SeleniumLibrary.Click Element    xpath=${cabecalho.pesquisaContato}

    # O SFA pode abrir uma aba de Dashboard ao clicar na lupa — fecha extras e volta ao formulário
    BuiltIn.Sleep    0.5s
    ${janelas}=    SeleniumLibrary.Get Window Handles
    ${qtdJanelas}=    BuiltIn.Get Length    ${janelas}
    IF    ${qtdJanelas} > ${1}
        FOR    ${janela}    IN    @{janelas}[1:]
            SeleniumLibrary.Switch Window    ${janela}
            SeleniumLibrary.Close Window
        END
        SeleniumLibrary.Switch Window    MAIN
    END

    # Descobre qual input o SFA usou para este popup — testa IDs sequencialmente, para no primeiro encontrado
    ${inputId}=    BuiltIn.Set Variable    ${EMPTY}
    FOR    ${candidato}    IN    termSelection_CONTATOPESSOA    termSelection_CONTATO    termSelection_NOME_CONTATO
        ${encontrou}=    BuiltIn.Run Keyword And Return Status
        ...    SeleniumLibrary.Wait Until Element Is Visible    id=${candidato}    2s
        IF    ${encontrou}
            ${inputId}=    BuiltIn.Set Variable    ${candidato}
            BREAK
        END
    END

    IF    '${inputId}' != '${EMPTY}'
        # Padrão popup padrão (igual a PROFISSIONAL, LOCAL, TIPO ATENDIMENTO)
        SeleniumLibrary.Input Text    id=${inputId}    ${contato}
        SeleniumLibrary.Press Keys    None    ENTER
        ${gridVisivel}=    BuiltIn.Run Keyword And Return Status
        ...    SeleniumLibrary.Wait Until Element Is Visible    xpath=${selecaoGrid.primeiraLinha}    3s
        IF    ${gridVisivel}
            SeleniumLibrary.Click Element    xpath=${selecaoGrid.primeiraLinha}
            SeleniumLibrary.Wait Until Element Is Enabled    id=${selecaoGrid.btnConfirmar}
            SeleniumLibrary.Click Element    id=${selecaoGrid.btnConfirmar}
        END
        BuiltIn.Run Keyword And Ignore Error
        ...    SeleniumLibrary.Wait Until Element Is Not Visible    id=${inputId}    5s
    ELSE
        # Nenhum input de busca detectado — o SFA pode ter auto-selecionado (1 único contato)
        BuiltIn.Log To Console    ℹ️ Campo de busca do contato não detectado — possível auto-seleção pelo SFA.
    END

    BuiltIn.Log To Console    Contato preenchido: ${contato}

Preencher observacao no cabecalho do atendimento
    [Documentation]    Irá preencher o campo de observação no cabeçalho do atendimento.
    [Arguments]    ${observacao}=${EMPTY}
    [Tags]    atendimento-cabecalho

    IF  '${observacao}' == '${EMPTY}'
        SeleniumLibrary.Input Text    id=${cabecalho.txtObservacao}    Atendimento cadastrado por teste automatizado.
    ELSE
        SeleniumLibrary.Input Text    id=${cabecalho.txtObservacao}    ${observacao}
    END

Iniciar atendimento
    [Documentation]    Irá iniciar o atendimento clicando no botão _"Iniciar"_.
    ...    O SFA pode abrir uma aba de Dashboard ao iniciar — abas extras são fechadas ao final.

    SeleniumLibrary.Wait Until Element Is Not Visible    class=${loading}    60s
    SeleniumLibrary.Click Element    id=${iniciarAtendimento}
    BuiltIn.Run Keyword And Ignore Error
    ...    SeleniumLibrary.Wait Until Element Is Not Visible    class=${loading}    15s
    BuiltIn.Sleep    0.5s
    sfa_lib_web.Fechar guia de Dashboard
    SeleniumLibrary.Switch Window    MAIN

Gravar atendimento
    [Documentation]    Irá gravar o atendimento em aberto.
    ...    Após gravar, fecha eventuais abas extras (Dashboard e outras) e aguarda o SFA estabilizar.

    SeleniumLibrary.Wait Until Page Does Not Contain Element    class=${loading}    15s
    SeleniumLibrary.Click Element    id=${gravarAtendimento}
    BuiltIn.Run Keyword And Ignore Error
    ...    SeleniumLibrary.Wait Until Page Does Not Contain Element    class=${loading}    15s
    # Aguarda o SFA abrir qualquer aba extra antes de fechar — o Dashboard pode abrir com leve atraso
    BuiltIn.Sleep    1.5s
    sfa_lib_web.Fechar guia de Dashboard
    ${janelas}=    SeleniumLibrary.Get Window Handles
    ${qtdJanelas}=    BuiltIn.Get Length    ${janelas}
    IF    ${qtdJanelas} > ${1}
        FOR    ${janela}    IN    @{janelas}[1:]
            SeleniumLibrary.Switch Window    ${janela}
            SeleniumLibrary.Close Window
        END
        SeleniumLibrary.Switch Window    MAIN
    END

Finalizar atendimento
    [Documentation]    Irá finalizar o lançamento/edição do atendimento.
    ...    ⚠️ O SFA exibe um popup de confirmação após clicar em Finalizar — esta keyword trata o popup.
    ...    Após finalizar, fecha eventuais abas extras e aguarda o commit do banco.

    SeleniumLibrary.Wait Until Page Does Not Contain Element    class=${loading}    15s
    SeleniumLibrary.Wait Until Element Is Enabled    id=${finalizarAtendimento}    10s
    SeleniumLibrary.Click Element    id=${finalizarAtendimento}
    # O SFA pode exibir popup de confirmação (ex: "Deseja finalizar o atendimento?") — trata Sim e Ok
    ${popupVisivel}=    BuiltIn.Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    xpath=/html/body/div[4]/div    3s
    IF    ${popupVisivel}
        BuiltIn.Log To Console    ℹ️ Popup de confirmação de finalização detectado — confirmando.
        # Tenta botão "Sim" (index 2); se não houver, tenta o único botão disponível
        ${btnSim}=    BuiltIn.Run Keyword And Return Status
        ...    SeleniumLibrary.Wait Until Element Is Enabled    xpath=/html/body/div[4]/div/div[3]/button[2]    3s
        IF    ${btnSim}
            SeleniumLibrary.Click Element    xpath=/html/body/div[4]/div/div[3]/button[2]
        ELSE
            BuiltIn.Run Keyword And Ignore Error
            ...    SeleniumLibrary.Click Element    xpath=/html/body/div[4]/div/div[3]/button
        END
    END
    # Aguarda navegação/loading pós-finalização
    BuiltIn.Run Keyword And Ignore Error
    ...    SeleniumLibrary.Wait Until Page Does Not Contain Element    class=${loading}    30s
    # Fecha abas extras (ex: sugestão de novo pedido, Dashboard)
    sfa_lib_web.Fechar guia de Dashboard
    ${janelas}=    SeleniumLibrary.Get Window Handles
    ${qtdJanelas}=    BuiltIn.Get Length    ${janelas}
    IF    ${qtdJanelas} > ${1}
        FOR    ${janela}    IN    @{janelas}[1:]
            SeleniumLibrary.Switch Window    ${janela}
            SeleniumLibrary.Close Window
        END
        SeleniumLibrary.Switch Window    MAIN
    END
    # Aguarda commit do banco antes de qualquer consulta de validação
    BuiltIn.Sleep    3s

Validar criacao do atendimento no banco de dados
    [Documentation]    Irá validar se o atendimento foi criado no banco de dados utilizando o ID do atendimento como parâmetro.
    [Arguments]    ${idAtendimento}

    ${utlimoAtendimento}=    Retornar ultimo atendimento

    IF  ${idAtendimento} == ${utlimoAtendimento}
        Log To Console    Atendimento ${idAtendimento} criado com sucesso!
    ELSE
        Log To Console    Atendimento ${idAtendimento} não foi gravado com sucesso no banco de dados.
        Fail
    END

Incluir imagem no atendimento
    [Documentation]    Irá vincular uma imagem ao atendimento.

    IF  '${aplicacao_web.navegadorWeb}' != 'Firefox'
        SeleniumLibrary.Wait Until Element Is Visible    ${imagem.guiaImagens}    ${10}
        SeleniumLibrary.Click Element    ${imagem.guiaImagens}
        ${urlAtendimento}    SeleniumLibrary.Get Location
        sfa_lib_web.Incluir imagem atendimento    ${urlAtendimento}
    ELSE IF  '${aplicacao_web.navegadorWeb}' == 'Firefox'
        BuiltIn.Log To Console    Para o navegador Firefox não há tratamento na inclusão de imagem no atendimento.
    END

Alterar data fim do atendimento 
    [Documentation]    Irá alterar o valor da data fim do atendimento para a data e hora atual.
    [Arguments]    ${idAtendimento}=${EMPTY}

    IF  '${idAtendimento}' == '${EMPTY}'
        BuiltIn.Log To Console    Nenhum atendimento passado no argumento idAtendimento.
        BuiltIn.Fail
    END
    
    ${dataHoraFimAnterior}    Retornar data e hora fim do atendimento    ${idAtendimento}
    ${dataHoraFimOriginal.data}    Set Variable    ${dataHoraFimAnterior['datafim']}
    ${dataHoraFimOriginal.hora}    Set Variable    ${dataHoraFimAnterior['horafim']}

    ${currentdate}    Get Current Date    result_format=%d-%m-%Y %H:%M:%S
    ${stringDate}    Convert To String    ${currentdate}
    ${ListaDataHora}    Split String    ${stringDate}

    # Usa o native value setter + despacho de eventos para que frameworks (Angular/AngularJS)
    # detectem a mudança — SeleniumLibrary.Input Text não dispara os eventos necessários.
    SeleniumLibrary.Execute JavaScript
    ...    var ns = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
    ...    var d = document.getElementById('${cabecalho.dataFim}');
    ...    d.removeAttribute('readonly'); d.removeAttribute('disabled');
    ...    ns.call(d, '${ListaDataHora[0]}');
    ...    d.dispatchEvent(new Event('input', {bubbles:true}));
    ...    d.dispatchEvent(new Event('change', {bubbles:true}));
    ...    d.dispatchEvent(new Event('blur', {bubbles:true}));
    ...    var h = document.getElementById('${cabecalho.horaFim}');
    ...    h.removeAttribute('readonly'); h.removeAttribute('disabled');
    ...    ns.call(h, '${ListaDataHora[1]}');
    ...    h.dispatchEvent(new Event('input', {bubbles:true}));
    ...    h.dispatchEvent(new Event('change', {bubbles:true}));
    ...    h.dispatchEvent(new Event('blur', {bubbles:true}));
    # Lê os valores de volta para confirmar que o campo aceitou
    ${dataSetada}=    SeleniumLibrary.Execute JavaScript
    ...    return document.getElementById('${cabecalho.dataFim}').value;
    ${horaSetada}=    SeleniumLibrary.Execute JavaScript
    ...    return document.getElementById('${cabecalho.horaFim}').value;
    BuiltIn.Log To Console    📅 Data fim no campo: '${dataSetada}' | Hora fim no campo: '${horaSetada}'
    BuiltIn.Log To Console    📅 Valores enviados: data='${ListaDataHora[0]}' | hora='${ListaDataHora[1]}'
    BuiltIn.Sleep    1s

Validar edicao do atendimento
    [Documentation]    Verifica se os dados alterados na edição foram salvos no banco de dados.
    [Arguments]    ${idAtendimento}=${EMPTY}

    IF  '${idAtendimento}' == '${EMPTY}'
        BuiltIn.Log To Console    Nenhum atendimento passado no argumento idAtendimento.
        BuiltIn.Fail
    END

    ${dataHoraFimAtual}    Retornar data e hora fim do atendimento    ${idAtendimento}

    IF  '${dataHoraFimAtual['datafim']}' != '${dataHoraFimOriginal.data}' or '${dataHoraFimAtual['horafim']}' != '${dataHoraFimOriginal.hora}'
        BuiltIn.Log To Console    \nData e hora final do atendimento ${idAtendimento} alterado com sucesso!
        BuiltIn.Log To Console    Data anterior: ${dataHoraFimOriginal.data} -- Data Atual: ${dataHoraFimAtual['datafim']}
        BuiltIn.Log To Console    Hora anterior: ${dataHoraFimOriginal.hora} -- Hora atual: ${dataHoraFimAtual['horafim']}
    ELSE
        BuiltIn.Log To Console    \nData e hora do atendimento ${idAtendimento} não foram alteradas com sucesso no banco de dados.
        BuiltIn.Fail
    END