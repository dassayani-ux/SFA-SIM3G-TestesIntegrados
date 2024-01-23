*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs e palavras chaves utilizadas para validar atendimentos.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/data/usuario/dataUsuario.robot

*** Keywords ***
Retornar proximo atendimento
    [Documentation]    Irá retornar o próximo ID que será criado na tabela atendimento.

    ${sql}    Set Variable    select max(idatendimento)+1 from atendimento
    ${proximoAtendimento}    Query    ${sql}

    Return From Keyword    ${proximoAtendimento[0][0]}

Retornar ultimo atendimento
    [Documentation]    Irá retornar o maior ID salvo na tabela de atendimento.

    ${sql}    Set Variable    select max(idatendimento) from atendimento
    ${ultimoAtendimento}    Query    ${sql}

    Return From Keyword    ${ultimoAtendimento[0][0]}

Retornar descricao tipo atendimento
    [Documentation]    Irá retornar a descrição de um tipo atendimento.
    [Arguments]    ${idTipoAtendimento}=${EMPTY}
    [Tags]    Not-autentication

    IF  '${idTipoAtendimento}' == '${EMPTY}'
        ${sql}    Set Variable    select descricao from tipoatendimento t where idnativo = 1 and (tipoautenticacao = 0 or tipoautenticacao is null)
    ELSE
        ${sql}    Set Variable    select descricao from tipoatendimento t where idtipoatendimento = ${idTipoAtendimento}
    END

    ${listaTipoAtendimento}    Query    ${sql}
    ${count}    Row Count    ${sql}
    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random
    ${tipoAtendimento}    Set Variable    ${listaTipoAtendimento[${index[0]}][0]}

    Log To Console    Tipo de atendimento selecionado: ${tipoAtendimento}

    Return From Keyword    ${tipoAtendimento}

Retornar descricao justificativa atendimento
    [Documentation]    Irá retornar a descricao de uma justificativa para preencher no atendimento.
    [Arguments]    ${idJustificativa}=${EMPTY}

    IF  '${idJustificativa}' == '${EMPTY}'
        ${sql}    Set Variable    select descricao from tipojustificativa where idnativo = 1 and sglContexto='ATE'
    ELSE
        ${sql}    Set Variable    select descricao from tipojustificativa where sglContexto='ATE' and idtipojustificativa = ${idJustificativa}
    END

    ${listaJustificativa}    Query    ${sql}
    ${count}    Row Count    ${sql}
    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random
    ${justificativa}    Set Variable    ${listaJustificativa[${index[0]}][0]}

    Log To Console    Justificativa selecionada: ${justificativa}

    Return From Keyword    ${justificativa}

Retornar data e hora fim do atendimento
    [Documentation]    Retorna a data e a hora fim do atendimento passado no argumento _*${idAtendimento}*_.
    [Arguments]    ${idAtendimento}=${EMPTY}

    IF  '${idAtendimento}' == '${EMPTY}'
        BuiltIn.Log To Console    Nenhum atendimento foi passado como argumento.
        BuiltIn.Fail
    ELSE
        ${sql}    Set Variable    select datafim, horafim from atendimento where idatendimento = ${idAtendimento}
        ${dataHoraFim}    Query    ${sql}    returnAsDict=True
    END
    
    Return From Keyword    ${dataHoraFim[0]}

Retornar dados de campos da config atendimento
    [Documentation]    Utilizada para retornar informações a respeito de campos/abas exibidos no atendimento.
    ...    _Obs.:_ Retorna os dados da config atendimento vinculada ao usuário logado.

    ${idUsuario}=    Retornar id usuario logado web
    ${sql}=    BuiltIn.Set Variable
    ${sql}=    BuiltIn.Catenate    SEPARATOR=\n
    ...    select ac.idnexibecontato as contato, 
    ...    ac.idnexibeoutprof as outro_prof,
    ...    ac.idnexibejustweb as justificativa
    ...    from perfilacesso pa
    ...    inner join usuario u on u.idperfilacesso = pa.idperfilacesso
    ...    inner join atendimentoconfig ac on ac.idatendimentoconfig = pa.idatendimentoconfig
    ...    where u.idusuario = ${idUsuario};

    ${result}    DatabaseLibrary.Query    ${sql}    returnAsDict=True

    BuiltIn.Return From Keyword    ${result[0]}