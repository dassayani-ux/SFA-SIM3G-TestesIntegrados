*** Settings ***
Documentation    Arquivo criado para armazenar as SQLs utilizadas para validar usuários.

Library    DatabaseLibrary
Variables    ${EXECDIR}/libraries/variables/sfa_variables.py

*** Keywords ***
Retornar id usuario logado web
    [Documentation]    Retorna o id do usuário utilizado em *usuarioWeb* do arquivo de variáveis.
    
    ${sql}=    BuiltIn.Set Variable    select idusuario from usuario where login = '${login_web.usuarioWeb}' and idnativo = 1
    ${result}=    DatabaseLibrary.Query    ${sql}

    BuiltIn.Return From Keyword    ${result[0][0]}

Retornar id usuario logado mobile
    [Documentation]    Retorna o id do usuário utilizado em *usuarioWeb* do arquivo de variáveis.
    
    ${sql}=    BuiltIn.Set Variable    select idusuario from usuario where login = '${login_mobile.usuarioMobile}' and idnativo = 1
    ${result}=    DatabaseLibrary.Query    ${sql}

    BuiltIn.Return From Keyword    ${result[0][0]}

Retornar usuario aleatorio
    [Documentation]    Irá retornar uma lista contendo um *ID* e *NOME* de usuário aleatório.

    ${usuLogado}=    Retornar id usuario logado web
    ${sql}=    BuiltIn.Set Variable
    ${sql}=    BuiltIn.Catenate    SEPARATOR=\n
    ...    select this_.idUsuario, this_.login,
    ...    this_.nome, this_.idPerfilAcesso
    ...    from Usuario this_
    ...    where this_.idUsuario in (
    ...    	select distinct a_.idUsuario as y0_
    ...    	from Usuario a_
    ...    	left outer join UsuarioHierarquia a_0x1_ on a_.idUsuario=a_0x1_.idUsuario
    ...    	left outer join Usuario a_1x2_ on a_0x1_.idUsuarioSuperior=a_1x2_.idUsuario
    ...    	where((a_.idUsuario=${usuLogado} or a_1x2_.idUsuario=${usuLogado})
    ...    	and a_.idnAtivo=1)
    ...    )
    ...    order by this_.nome asc

    ${usuario}    Query    ${sql}
    ${count}    Row Count    ${sql}
    ${index}=    Evaluate    random.sample(range(0, ${count}), 1)    random

    Return From Keyword    ${usuario[${index[0]}][0]}    ${usuario[${index[0]}][2]}

Retornar id filial do usuario
    [Documentation]    Retorna a filial padrão vinculada ao usuário.
    ...    \nQuando não especificado usuário será utilizado o usuário logao na WEB como argumento.
    [Arguments]    ${usuario}=${EMPTY}

    IF  '${usuario}' == '${EMPTY}'
        ${usuario}=    Retornar id usuario logado web
    END
    ${sql}=    BuiltIn.Set Variable
    ${sql}=    BuiltIn.Catenate    SEPARATOR=\n
    ...    select 
    ...    case 
    ...        when (select count(*) from usuariofilial where idusuario = ${usuario}) = 1 then 
    ...            (select u.idlocalfilial from usuariofilial u where u.idusuario = ${usuario})
    ...        else 
    ...            (select u.idlocalfilial from usuariofilial u where u.idusuario = ${usuario} and idnpadrao = 1)
    ...    end as id_filial

    ${filial}=    DatabaseLibrary.Query    ${sql}

    BuiltIn.Return From Keyword    ${filial[0][0]}