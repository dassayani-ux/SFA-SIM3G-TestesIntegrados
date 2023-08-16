*** Settings ***

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/locators/web/atendimento/cadastroAtendimentoLocators.robot
Resource    ${EXECDIR}/resources/variables/web/atendimento/cadastroAtendimentoVariables.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/listagemClientesResource.robot
Resource    ${EXECDIR}/resources/data/atendimento/dataAtendimento.robot

*** Keywords ***
Acessa tela de cadastro de atendimento
    [Documentation]    Utilizada para acessar a tela de cadastro de novo atendimento.
    Click Element    id=${atendimento.menuAtendimento}
    Wait Until Element Is Visible    id=${atendimento.novoAtendimento}
    Click Element    id=${atendimento.novoAtendimento}    
    Wait Until Page Contains Element    ${tituloPaginaAtendimento}    20
    Capture Page Screenshot

Preenche cabeçalho do atendimento
    [Documentation]    Irá preencher os dados do cabeçalho de maneira randomizada utilizando dados do banco de dados.
    ## Cliente
    Click Element    xpath=${cabecalho.pesquisaCliente}
    ${cliente}    Retorna cliente ativo
    Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaCliente}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaCliente}    ${cliente[1]}
    Press Keys    None    ENTER
    Sleep    1s
    Press Keys    None    ENTER

    Sleep    2s

    ##Local
    Click Element    xpath=${cabecalho.pesquisaLocal} 
    ${localDescription}    Retorna descricao local    ${cliente[0]}
    Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaLocal}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaLocal}    ${localDescription}
    Press Keys    None    ENTER
    FOR  ${I}  IN RANGE    ${4}
        Press Keys    None    TAB
    END
    Press Keys    None    ENTER

    Sleep    1s

    ##Tipo Atendimento
    Click Element    xpath=${cabecalho.pesquisaTipoAtendimento}
    ${tipoAtendimento}    Retorna tipo atendimento
    Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaTipoAtendimento}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaTipoAtendimento}    ${tipoAtendimento}
    Press Keys    None    ENTER

    Sleep    1s
    
    ##Justificativa
    Click Element    xpath=${cabecalho.pesquisajustificativa}
    ${justificativa}    Retorna justificativa atendimento
    Wait Until Element Is Visible    id=${cabecalho.pesquisaRapidaJustificativa}
    SeleniumLibrary.Input Text    id=${cabecalho.pesquisaRapidaJustificativa}    ${justificativa}
    Press Keys    None    ENTER

Retorna tipo atendimento
    [Documentation]    Irá retornar um tipo de atendimento ativo para utilizar no cadastro de novo atendimento.

    ${tipoAtendimento}    Query    ${TIPO_ATENDIMENTO_SQL}
    ${countTipoAtendimento}    Row Count    ${TIPO_ATENDIMENTO_SQL}

    ${index}=    Evaluate    random.sample(range(0, ${countTipoAtendimento}), 1)    random

    Log To Console    Tipo de atendimento selecionado: ${tipoAtendimento[${index[0]}][0]}

    Return From Keyword    ${tipoAtendimento[${index[0]}][0]}


Inicia atendimento
    [Documentation]    Irá iniciar o atendimento clicando no botão "Iniciar".

    Click Element    id=${iniciarAtendimento}

Grava atendimento
    [Documentation]    Irá gravar o cadastro de atendimento em aberto.

    Click Element    id=${gravarAtendimento}

Finaliza atendimento
    [Documentation]    Irá finalizar o lançamento/edição do atendimento.

    Click Element    id=${finalizarAtendimento}

Inlcuir imagem no atendimento
    [Documentation]    Irá vincular uma imagem no atendimento.

    Wait Until Element Is Visible    ${imagem.guiaImagens}    10
    Click Element    id=${imagem.guiaImagens}
    Click Element    id=${imagem.incluirImagem}
    SikuliLibrary.Add Image Path    ${EXECDIR}\\Resources\\elements\\atendimento
    SikuliLibrary.Click    iconeDirExplorer.png
    SikuliLibrary.Input Text    ${EMPTY}    ${repositorioImagemAtendimento}
    SikuliLibrary.Press Special Key    ENTER
    FOR  ${I}  IN RANGE    ${5}
        SikuliLibrary.Press Special Key    TAB
        Sleep    0.5s
    END
    SikuliLibrary.Input Text    ${EMPTY}    ${nomeImagemAtendimento}
    SikuliLibrary.Press Special Key    ENTER
    Sleep    3s
    SeleniumLibrary.Capture Page Screenshot

Retorna justificativa atendimento
    [Documentation]    Irá retornar uma justificativa random para preencher no atendimento.

    ${justificativa}    Query    ${JUSTIFICATIVA_SQL}
    ${countJustificativa}    Row Count    ${JUSTIFICATIVA_SQL}

    ${index}=    Evaluate    random.sample(range(0, ${countJustificativa}), 1)    random

    Log To Console    Justificativa selecionada: ${justificativa[${index[0]}][0]}

    Return From Keyword    ${justificativa[${index[0]}][0]}

Retorna proximo atendimento
    [Documentation]    Irá retornar o próximo ID que será criado na tabela atendimento.

    ${proximoAtendimento}    Query    ${PROXIMO_ATENDIMENTO_SQL}

    Return From Keyword    ${proximoAtendimento[0][0]}

Retorna ultimo atendimento
    [Documentation]    Irá retornar o maior ID salvo na tabela de atendimento.

    ${ultimoAtendimento}    Query    ${ULTIMO_ATENDIMENTO_SQL}

    Return From Keyword    ${ultimoAtendimento[0][0]}

Valida criacao do atendimento no bd
    [Documentation]    Irá validar se o atendimento foi criado no banco de dados utilizando o ID do atendimento como parâmetro.
    [Arguments]    ${idAtendimento}

    ${utlimoAtendimento}=    Retorna ultimo atendimento

    IF  ${idAtendimento} == ${utlimoAtendimento}
        Log To Console    Atendimento ${idAtendimento} criado com sucesso!
    ELSE
        Log To Console    Atendimento ${idAtendimento} não foi gravado com sucesso no banco de dados.
        Fail
    END

Altera data fim do atendimento 
    [Documentation]    Irá alterar o valor da data fim do atendimento para a data e hora atual.
    [Arguments]    ${idAtendimentoLocal}

    ${dataHoraFimAnterior}    Query    ${DATA_HORA_FIM_SQL}${idAtendimentoLocal}

    Append To List    ${dataHoraFimOriginal}    ${dataHoraFimAnterior[0][0]}    ${dataHoraFimAnterior[0][1]}     

    ${currentdate}    Get Current Date    result_format=%d-%m-%Y %H:%M:%S
    ${stringDate}    Convert To String    ${currentdate}
    ${ListaDataHora}    Split String    ${stringDate}

    SeleniumLibrary.Input Text    id=${cabecalho.dataFim}    ${ListaDataHora[0]}
    SeleniumLibrary.Input Text    id=${cabecalho.horaFim}    ${ListaDataHora[1]}

Valida edicao do atendimento
    [Documentation]    Verifica se os dados alterados na edição foram salvos no banco de dados.
    [Arguments]    ${idAtendimentoLocal}

    Sleep    2s
    ${dataHoraAtual}    Query    ${DATA_HORA_FIM_SQL}${idAtendimentoLocal}

    IF  '${dataHoraAtual[0][0]}' != '${dataHoraFimOriginal[0]}' or '${dataHoraAtual[0][1]}' != '${dataHoraFimOriginal[1]}'
        Log To Console    \nData e hora final do atendimento ${idAtendimentoLocal} alterado com sucesso!
        Log To Console    Data anterior: ${dataHoraFimOriginal[0]} -- Data Atual: ${dataHoraAtual[0][0]}
        Log To Console    Hora anterior: ${dataHoraFimOriginal[1]} -- Hora atual: ${dataHoraAtual[0][1]}
    ELSE
        Log To Console    \nData e hora do atendimento ${idAtendimentoLocal} não foram alteradas com sucesso no banco de dados.
        Fail 
    END
      