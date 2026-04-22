*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs e palavras chaves utilizadas para validar atendimentos.

Resource    ${EXECDIR}/pedidoengine/resources/lib/web/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/data/usuario/dataUsuario.robot

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

    IF    ${count} == ${0}
        BuiltIn.Log To Console    ⚠️ Nenhum tipo de atendimento encontrado no banco — campo será ignorado.
        BuiltIn.Return From Keyword    ${EMPTY}
    END

    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random
    ${tipoAtendimento}    Set Variable    ${listaTipoAtendimento[${index[0]}][0]}

    Log To Console    Tipo de atendimento selecionado: ${tipoAtendimento}

    Return From Keyword    ${tipoAtendimento}

Retornar descricao justificativa atendimento
    [Documentation]    Irá retornar a descricao de uma justificativa para preencher no atendimento.
    ...    Retorna ${EMPTY} se não houver justificativas cadastradas no banco para o contexto ATE.
    [Arguments]    ${idJustificativa}=${EMPTY}

    IF  '${idJustificativa}' == '${EMPTY}'
        ${sql}    Set Variable    select descricao from tipojustificativa where idnativo = 1 and sglContexto='ATE'
    ELSE
        ${sql}    Set Variable    select descricao from tipojustificativa where sglContexto='ATE' and idtipojustificativa = ${idJustificativa}
    END

    ${listaJustificativa}    Query    ${sql}
    ${count}    Row Count    ${sql}

    IF    ${count} == ${0}
        BuiltIn.Log To Console    ⚠️ Nenhuma justificativa encontrada no banco para contexto ATE — campo será ignorado.
        BuiltIn.Return From Keyword    ${EMPTY}
    END

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
        ${dataHoraFim}    Query    ${sql}    return_dict=True
    END
    
    Return From Keyword    ${dataHoraFim[0]}

Retornar nome profissional atendimento
    [Documentation]    Retorna o nome do usuário de automação para preencher o campo Profissional no atendimento.

    ${sql}=    Set Variable    select nome from usuario where idnativo = 1 and upper(nome) like upper('%automação%') limit 1
    ${result}    Query    ${sql}
    Return From Keyword    ${result[0][0]}

Retornar contato parceiro
    [Documentation]    Retorna o nome de um contato ativo vinculado ao parceiro.
    ...    A tabela no banco é *contatopessoa* (vínculo Parceiro → Contato).
    ...    Em caso de tabela inexistente ou nenhum registro, retorna ${EMPTY} sem falhar.
    [Arguments]    ${idParceiro}=${EMPTY}

    IF  '${idParceiro}' == '${EMPTY}'
        ${sql}    Set Variable    select c.nome from contatopessoa c where c.idnativo = 1 limit 1
    ELSE
        ${sql}    Set Variable    select c.nome from contatopessoa c where c.idparceiro = ${idParceiro} and c.idnativo = 1 limit 1
    END

    ${status}    ${listaContato}=    BuiltIn.Run Keyword And Ignore Error    DatabaseLibrary.Query    ${sql}
    IF    '${status}' == 'FAIL'
        BuiltIn.Log To Console    ⚠️ Não foi possível consultar contatos (tabela não encontrada ou erro de SQL) — campo será ignorado.
        BuiltIn.Return From Keyword    ${EMPTY}
    END

    ${count}=    BuiltIn.Get Length    ${listaContato}
    IF    ${count} == ${0}
        BuiltIn.Log To Console    \n⚠️ Nenhum contato encontrado para o parceiro ${idParceiro} — campo será ignorado.
        BuiltIn.Return From Keyword    ${EMPTY}
    END

    ${contato}    Set Variable    ${listaContato[0][0]}
    Log To Console    Contato selecionado: ${contato}
    Return From Keyword    ${contato}

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

    ${result}    DatabaseLibrary.Query    ${sql}    return_dict=True

    IF    not ${result}
        Log To Console    \n⚠️ Nenhuma atendimentoconfig encontrada para o usuário — usando config padrão (sem contato, sem outro prof, sem justificativa).
        ${default}=    BuiltIn.Create Dictionary    contato=${0}    outro_prof=${0}    justificativa=${0}
        BuiltIn.Return From Keyword    ${default}
    END

    BuiltIn.Return From Keyword    ${result[0]}