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
    [Documentation]    Irá retornar o ID do Local utilizando os campos *descricao* e *parceiro* como argumento.
    [Arguments]    ${descricao}    ${parceiro}

    ${idLocal}=    Query    select l.idlocal from local l inner join parceiro p on p.numeromatricula = l.numeromatricula where l.descricao ilike '%${descricao}%' and p.idparceiro = ${parceiro}

    Return From Keyword    ${idLocal[0][0]}

Retorna idLocalFilial
    [Documentation]    Irá retornar o idlocalfilial utilizando o campo *descricao* como argumento.
    [Arguments]    ${descricao}

    ${idLocalFilial}=    Query    select idlocalfilial from localfilial l join local l2 on l2.idlocal = l.idlocal where l2.descricao ilike '%${descricao}%'

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

    ${sqlParceiroLocal}    Set Variable    select p.idlocal from parceirolocal p where idparceiro = ${idParceiro}
    ${listaIdLocal}    Query    ${sqlParceiroLocal}
    ${count}    Row Count    ${sqlParceiroLocal}    

    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random
    ${idLocal}    Set Variable    ${listaIdLocal[${index[0]}][0]}

    Return From Keyword    ${idLocal}