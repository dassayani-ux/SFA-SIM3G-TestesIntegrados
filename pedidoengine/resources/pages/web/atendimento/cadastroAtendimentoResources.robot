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

Preencher cabeçalho do atentimento
    [Documentation]    Esta keyword preenche os campos do cabeçalho do atendimento.
    [Tags]    atendimento-cabecalho
    
    ${config}=    Retornar dados de campos da config atendimento
    IF  '${config['outro_prof']}' == '${1}'
        BuiltIn.Set Test Variable    ${cabecalho.pesquisaCliente}    //*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[3]/div/a[1]
        BuiltIn.Set Test Variable    ${cabecalho.pesquisaLocal}    //*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[4]/div/a[1]
        BuiltIn.Set Test Variable    ${cabecalho.pesquisaTipoAtendimento}    //*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[5]/div/a[1]
        IF  '${config['contato']}' == '${1}'
            BuiltIn.Set Test Variable    ${cabecalho.limpajustificativa}    //*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[10]/div/a[2]
            BuiltIn.Set Test Variable    ${cabecalho.pesquisajustificativa}    //*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[10]/div/a[1]
        ELSE
            BuiltIn.Set Test Variable    ${cabecalho.limpajustificativa}    //*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[9]/div/a[2]
            BuiltIn.Set Test Variable    ${cabecalho.pesquisajustificativa}    //*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[9]/div/a[1]
        END
    ELSE
        IF  '${config['contato']}' == '${1}'
            BuiltIn.Set Test Variable    ${cabecalho.limpajustificativa}    //*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[9]/div/a[2]
            BuiltIn.Set Test Variable    ${cabecalho.pesquisajustificativa}    //*[@id="principal"]/div[2]/div/div/div[3]/div[3]/form/ul/li[9]/div/a[1]
        END
    END
    
    Preencher cliente no cabecalho do atendimento
    Preencher local do cliente no cabecalho do atendimento
    Preencher tipo atendimento no cabecalho do atendimento
    BuiltIn.Run Keyword If    '${config['justificativa']}' == '${1}'    Preencher jutstificativa no cabecalho do atendimento
    Preencher observacao no cabecalho do atendimento

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
    SeleniumLibrary.Click Element    xpath=${cabecalho.pesquisaCliente}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaCliente}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaCliente}    ${cliente}
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Element Is Not Visible    id=${cabecalho.pesquisaRapidaCliente}    ${10}

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
    FOR  ${I}  IN RANGE    ${5}
        SeleniumLibrary.Press Keys    None    TAB
    END
    IF  '${aplicacao_web.navegadorWeb}' == 'Firefox'
        FOR  ${I}  IN RANGE    ${2}
            SeleniumLibrary.Press Keys    None    TAB
        END
    END
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Element Is Not Visible    id=${cabecalho.pesquisaRapidaLocal}

Preencher tipo atendimento no cabecalho do atendimento
    [Documentation]    Irá preencher o campo de tipo atendimento no cabeçalho do atendimento.
    [Arguments]    ${tipoAtendimento}=${EMPTY}
    [Tags]    atendimento-cabecalho

    IF  '${tipoAtendimento}' == '${EMPTY}'
        ${tipoAtendimento}=    Retornar descricao tipo atendimento
        ${dadosAtendimento.descricaoTipoAtendimento}    Set Variable    ${tipoAtendimento}
    ELSE
        ${dadosAtendimento.descricaoTipoAtendimento}    Set Variable    ${tipoAtendimento}
    END
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${cabecalho.pesquisaTipoAtendimento}    ${10}
    SeleniumLibrary.Click Element    xpath=${cabecalho.pesquisaTipoAtendimento}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaTipoAtendimento}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaTipoAtendimento}    ${tipoAtendimento}
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Element Is Not Visible    id=${cabecalho.pesquisaRapidaTipoAtendimento}

Preencher jutstificativa no cabecalho do atendimento
    [Documentation]    Irá preencher o campo de justificativa no cabeçalho do atendimento.
    [Arguments]    ${justificativa}=${EMPTY}
    [Tags]    atendimento-cabecalho

    IF  '${justificativa}' == '${EMPTY}'
        ${justificativa}=    Retornar descricao justificativa atendimento
        ${dadosAtendimento.descricaoJustificativa}    Set Variable    ${justificativa}
    ELSE
        ${dadosAtendimento.descricaoJustificativa}    Set Variable    ${justificativa}
    END
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${cabecalho.pesquisajustificativa}    ${10}
    SeleniumLibrary.Click Element    xpath=${cabecalho.limpajustificativa}
    SeleniumLibrary.Click Element    xpath=${cabecalho.pesquisajustificativa}
    SeleniumLibrary.Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaJustificativa}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaJustificativa}    ${justificativa}
    SeleniumLibrary.Press Keys    None    ENTER
    FOR  ${I}  IN RANGE    ${5}
        SeleniumLibrary.Press Keys    None    TAB
    END
    IF  '${aplicacao_web.navegadorWeb}' == 'Firefox'
        FOR  ${I}  IN RANGE    ${2}
            SeleniumLibrary.Press Keys    None    TAB
        END
    END
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Element Is Not Visible    id=${cabecalho.pesquisaRapidaJustificativa}

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

    SeleniumLibrary.Wait Until Element Is Not Visible    class=${loading}    60s
    SeleniumLibrary.Click Element    id=${iniciarAtendimento}

Gravar atendimento
    [Documentation]    Irá gravar o atendimento em aberto.

    SeleniumLibrary.Wait Until Page Does Not Contain Element    class=${loading}    15s
    SeleniumLibrary.Click Element    id=${gravarAtendimento}

Finalizar atendimento
    [Documentation]    Irá finalizar o lançamento/edição do atendimento.
    
    SeleniumLibrary.Wait Until Page Does Not Contain Element    class=${loading}    15s
    SeleniumLibrary.Click Element    id=${finalizarAtendimento}

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

    SeleniumLibrary.Input Text    id=${cabecalho.dataFim}    ${ListaDataHora[0]}
    SeleniumLibrary.Input Text    id=${cabecalho.horaFim}    ${ListaDataHora[1]}

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