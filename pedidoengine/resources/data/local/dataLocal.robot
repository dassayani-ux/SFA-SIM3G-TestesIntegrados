*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar local.

Resource    ${EXECDIR}/resources/lib/web/lib.robot

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
    [Documentation]    Irá retornar o ID do Local utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idLocal}=    Query    select l.idlocal from local l where l.descricao ilike '%${descricao}%'

    Return From Keyword    ${idLocal[0][0]}

Retorna idLocalFilial
    [Documentation]    Irá retornar o idlocalfilial utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idLocalFilial}=    Query    select idlocalfilial from localfilial l join local l2 on l2.idlocal = l.idlocal where l2.descricao ilike '%${descricao}%'

    Return From Keyword    ${idLocalFilial[0][0]}