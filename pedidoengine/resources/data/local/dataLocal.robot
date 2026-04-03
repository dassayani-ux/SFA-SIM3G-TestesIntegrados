*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar local.

Library    DatabaseLibrary
Resource    ${EXECDIR}/pedidoengine/resources/data/usuario/dataUsuario.robot

*** Variables ***
${LOCAL_CLIENTE_SQL}    select p.idlocal from parceirolocal p where idparceiro =
${DESCRICAO_LOCAL_SQL}    select descricao from local where idlocal =

${SQL_LOCAL}    with descricaoLocal as(
...    	select
...    		this_.descricao, count(*)
...    	from
...    	    Local this_
...    	left outer join WAgrLocal wagrlocal2_ on this_.idLocal=wagrlocal2_.idWAgrLocal
...    	group by 
...    		this_.descricao
...    	having count(*) = 1
...    )
...    
...    select
...    	this_.idLocal,
...    	this_.bairro,
...    	this_.descricao,
...    	this_.logradouro
...    from
...        Local this_
...    left outer join WAgrLocal wagrlocal2_ on this_.idLocal=wagrlocal2_.idWAgrLocal
...    inner join descricaoLocal dl on dl.descricao = this_.descricao
...    order by
...        this_.descricao asc

*** Keywords ***
Retorna idlocal
    [Documentation]    Irá retornar o ID do Local utilizando os campos *descricao* e *parceiro* como argumento.
    [Arguments]    ${descricao}    ${parceiro}

    ${sql}=    BuiltIn.Set Variable
    ${sql}=    BuiltIn.Catenate    SEPARATOR=\n
    ...    select l.idlocal
    ...    from local l
    ...    inner join parceirolocal pl on pl.idlocal = l.idlocal
    ...    inner join parceiro p on p.idparceiro = pl.idparceiro
    ...    where l.descricao = '${descricao}' 
    ...    and p.idparceiro = ${parceiro};
    ${idLocal}=    DatabaseLibrary.Query    ${sql}

    Return From Keyword    ${idLocal[0][0]}

Retorna idLocalFilial
    [Documentation]    Irá retornar o idlocalfilial utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idLocalFilial}=    Query    select * from local l where l.descricao = '${descricao}'

    Return From Keyword    ${idLocalFilial[0][0]}

Retornar descricao local
    [Documentation]    Irá retornar a descrição de um local de acordo com o parceiro passado como argumento.
    [Arguments]    ${idParceiro}

    ${idLocal}=    Retornar id local parceiro    ${idParceiro}
    ${sqlDescricaoLocal}    Set Variable    select descricao from local where idlocal = ${idLocal}    
    ${tuplaDescicaoLocal}    Query    ${sqlDescricaoLocal}
    ${descricaoLocal}    Set Variable    ${tuplaDescicaoLocal[0][0]}   

    Log To Console    Local selecionado: ${descricaoLocal}
    
    Return From Keyword    ${descricaoLocal}

Retornar id local parceiro
    [Documentation]    Irá retornar o id de um local de acordo com o parceiro passado como argumento.
    [Arguments]    ${idParceiro}

    ${usuario}=    Retornar id usuario logado web

    ${sql}=    BuiltIn.Set Variable
    ${sql}=    BuiltIn.Catenate    SEPARATOR=\n
    ...    select l. idLocal
    ...    from local l
    ...    where(l.idLocal in (
    ...    	select pl.idLocal
    ...    	from ParceiroLocal pl
    ...    	left outer join Parceiro p on pl.idParceiro=p.idParceiro
    ...    	where pl.idparceiro = ${idParceiro})
    ...    	and l.idLocal in (
    ...    		select ul.idLocal
    ...            from UsuarioLocal ul
    ...            left outer join Usuario u on ul.idUsuario=u.idUsuario
    ...            where u.idUsuario in (
    ...            	select idu.idUsuario
    ...                from Usuario idu
    ...                left outer join UsuarioHierarquia uh on idu.idUsuario=uh.idUsuario
    ...                left outer join Usuario iduh on uh.idUsuarioSuperior=iduh.idUsuario
    ...                where(idu.idUsuario=${usuario} or iduh.idUsuario=${usuario}))))

    ${listaIdLocal}    Query    ${sql}
    ${count}    Row Count    ${sql}    

    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random
    ${idLocal}    Set Variable    ${listaIdLocal[${index[0]}][0]}

    Return From Keyword    ${idLocal}

Retornar dados de local especifico
    [Documentation]    Irá retornar dados de um local específico.
    [Arguments]    ${idlocal}=${EMPTY}

    IF  '${idlocal}' == '${EMPTY}'
        BuiltIn.Log To Console    [ERRO] Nenhum local informado.
        BuiltIn.Fail
    ELSE
        ${sql}    BuiltIn.Set Variable    select descricao from local l where l.idlocal = ${idlocal};
        ${local}    DatabaseLibrary.Query    ${sql}    returnAsDict=True
    
        BuiltIn.Return From Keyword    ${local[0]}
    END