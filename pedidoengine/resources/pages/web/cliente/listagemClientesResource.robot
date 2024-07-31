*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas no processo de listagem de clientes.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/locators/web/cliente/listaClientesLocators.robot
Resource    ${EXECDIR}/resources/data/cliente/dataCliente.robot
Resource    ${EXECDIR}/resources/pages/web/local/localResources.robot
Resource    ${EXECDIR}/resources/data/usuario/dataUsuario.robot

*** Keywords ***
Acessa tela de listagem de clientes
    [Documentation]    Irá acessar a tela de listagem de clientes.
    Click Element    id=${cliente.menuCliente}
    Wait Until Element Is Visible    id=${cliente.subMenuCliente}    5
    Click Element    id=${cliente.subMenuCliente}
    Wait Until Element Is Visible     id=${cliente.menuClienteListar}    5
    Click Element    id=${cliente.menuClienteListar}
    Wait Until Page Contains Element    ${tituloPaginaListagemCliente}    20
    sfa_lib_web.Fechar guia de Dashboard
    SeleniumLibrary.Switch Window    TOTVS CRM SFA | Listagem de clientes

Filtra cliente especifico
    [Documentation]    Irá filtrar um cliente específico utilizando o nome e matrícula como argumentos.
    [Arguments]    ${nome}    ${matricula}

    SeleniumLibrary.Click Element    class=${pesquisaAvancada.exibePesquisa}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${pesquisaAvancada.camposAtivos}
    SeleniumLibrary.Input Text    name=${pesquisaAvancada.razaoSocial}    ${nome}
    SeleniumLibrary.Input Text    name=${pesquisaAvancada.matricula}    ${matricula}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${1}
        Log To Console    Cliente ${nome} localizado com sucesso!
    ELSE
        Log To Console    Filtragem do cliente está inconsistênte.
        Fail
    END

Filtra cliente na pesquisa rapida por nome
    [Documentation]    Irá filtrar a listagem de clientes utilizando o campo de pesquisa rápida informando um nome qualquer.

    ${nome}=    FakerLibrary.First Name
    ${count}=    Pesquisa rapida sql    ${nome}
    WHILE  ${count} == ${0}
        ${nome}=    FakerLibrary.First Name
        ${count}=    Pesquisa rapida sql    ${nome}   
    END

    Log To Console    \nNome selecionado: ${nome}

    SeleniumLibrary.Input Text    name=${pesquisaRapida.inputPesquisa}    ${nome}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${count}
        Log To Console    Listagem de clientes utilizando o nome: ${nome} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Clear Element Text    name=${pesquisaRapida.inputPesquisa}

Filtra cliente na pesquisa rapida por numero
    [Documentation]    Representa uma filtragem por número de matrícula do cliente.

    ${matricula}=    FakerLibrary.Random Number    digits=3
    ${count}=    Pesquisa rapida sql    ${matricula}
    WHILE  ${count} == ${0}
        ${nome}=    FakerLibrary.First Name
        ${count}=    Pesquisa rapida sql    ${matricula}   
    END

    Log To Console    \nNumero selecionado: ${matricula}

    SeleniumLibrary.Input Text    name=${pesquisaRapida.inputPesquisa}    ${matricula}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${count}
        Log To Console    Listagem de clientes utilizando o número: ${matricula} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Clear Element Text    name=${pesquisaRapida.inputPesquisa}

Ativa pesquisa avancada
    [Documentation]    Irá clicar sobre a função de Pesquisa Avançada deixando a mesma ativa na tela.
    SeleniumLibrary.Click Element    class=${pesquisaAvancada.exibePesquisa}
    SeleniumLibrary.Wait Until Element Is Enabled    xpath=${pesquisaAvancada.camposAtivos}
    Sleep    0.5s

Filtra cliente por tipo pessoa
    [Documentation]    Irá realizar a filtragem utilizando como argumento o tipo de possoa: PF para física e PJ para jurídica.
    ...    \nValores válidos para o argumento *tipo* : PF, PJ, AMBOS_CHECK, AMBOS_UNCHECK
    [Arguments]    ${tipo}=AMBOS_CHECK

    IF  '${tipo}' == 'PF'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.tipoPessoaJuridica}
        ${countRegistros}=    SQL Pesquisa Avancada    tipoPessoa=PF
    ELSE IF  '${tipo}' == 'PJ'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.tipoPessoaFisica}
        ${countRegistros}=    SQL Pesquisa Avancada    tipoPessoa=PJ
    ELSE IF  '${tipo}' == 'AMBOS_CHECK'
        ${countRegistros}=    SQL Pesquisa Avancada    tipoPessoa=Ambos
    ELSE IF  '${tipo}' == 'AMBOS_UNCHECK'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.tipoPessoaJuridica}
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.tipoPessoaFisica}
        ${countRegistros}=    SQL Pesquisa Avancada    tipoPessoa=Ambos
    ELSE
        Log To Console    Tipo passado no argumento é inválido.
        Fail
    END

    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando o tipo de pessoa: ${tipo} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    IF  '${tipo}' == 'PF'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.tipoPessoaJuridica}
    ELSE IF  '${tipo}' == 'PJ'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.tipoPessoaFisica}
    ELSE IF  '${tipo}' == 'AMBOS_UNCHECK'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.tipoPessoaJuridica}
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.tipoPessoaFisica}
    END

Filtra cliente por situacao
    [Documentation]    Irá realizar a filtragem de clientes levando a situação como argumento.
    ...    \nValores válidos para o argumento *situacao* : 0, 1, AMBOS_CHECK, AMBOS_UNCHECK
    [Arguments]    ${situacao}=1

    IF  '${situacao}' == '${0}'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.situacaoAtivo}
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.situacaoInativo}
        ${countRegistros}=    SQL Pesquisa Avancada    situacao=0
    ELSE IF  '${situacao}' == '${1}'   
        ${countRegistros}=    SQL Pesquisa Avancada    situacao=1
    ELSE IF  '${situacao}' == 'AMBOS_CHECK'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.situacaoInativo}
        ${countRegistros}=    SQL Pesquisa Avancada    situacao=Ambos
    ELSE IF  '${situacao}' == 'AMBOS_UNCHECK'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.situacaoAtivo}
        ${countRegistros}=    SQL Pesquisa Avancada    situacao=Ambos
    ELSE
        Log To Console    Situação passada como argumento é inválida.
        Fail
    END
    
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando a situação: ${situacao} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    IF  '${situacao}' == '${0}'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.situacaoAtivo}
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.situacaoInativo}    
    ELSE IF  '${situacao}' == 'AMBOS_CHECK'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.situacaoInativo}
    ELSE IF  '${situacao}' == 'AMBOS_UCHECK'
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.situacaoAtivo}
    END

Filtra Cliente por situacao aprovacao
    [Documentation]    Irá realizar a filtragem de clientes levando em consideração a situação de aprovação.

    ${situacoesAprovacao}    Retorna siuacao aprovacao
    ${lenght}    Get Length    ${situacoesAprovacao}

    FOR  ${I}  IN RANGE    ${lenght}
        ${countRegistros}=    SQL Pesquisa Avancada    situacaoAprovacao=${situacoesAprovacao[${I}]}
        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnPesquisaSituacaoAprovacao}
        Sleep    0.5s
        SeleniumLibrary.Input Text    id=${pesquisaSituacaoAprovacao.input}    ${situacoesAprovacao[${I}]}
        SeleniumLibrary.Press Keys    None    ENTER
        Sleep    0.5s
        SeleniumLibrary.Press Keys    None    ENTER
        SeleniumLibrary.Wait Until Element Is Visible    xpath=${pesquisaRapida.btnPesquisar}
        SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
        SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

        ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
        ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
        ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

        IF  ${intQtdeRegistros} == ${countRegistros}
            Log To Console    \nListagem de clientes utilizando a situação de aprovacao: ${situacoesAprovacao[${I}]} está de acordo.
        ELSE
            Log To Console    Listagem de clientes está incorreta.
            Fail
        END

        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaBuscaSituacaoAprovacao}
    END

Filtra cliente por razao social
    [Documentation]    Irá utilizar o campo Razão Social do filtro para realizar a busca por clientes.

    ${razao}=    FakerLibrary.First Name
    ${countRegistros}=    SQL Pesquisa Avancada    razaoSocial=${razao}
    WHILE  ${countRegistros} == ${0}
        ${razao}=    FakerLibrary.First Name
        ${countRegistros}=    SQL Pesquisa Avancada    razaoSocial=${razao}  
    END

    Log To Console    \nTrecho de Razão Social selecionada: ${razao}

    SeleniumLibrary.Input Text    name=${pesquisaAvancada.razaoSocial}    ${razao}    
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando a Razão Social: ${razao} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.razaoSocial}

Filtra cliente por fantasia
    [Documentation]    Irá utilizar o campo Nome Fantasia do filtro para realizar a busca por clientes.

    ${fantasia}=    FakerLibrary.First Name
    ${countRegistros}=    SQL Pesquisa Avancada    nomeFantasia=${fantasia}
    WHILE  ${countRegistros} == ${0}
        ${fantasia}=    FakerLibrary.First Name
        ${countRegistros}=    SQL Pesquisa Avancada    nomeFantasia=${fantasia}  
    END

    Log To Console    \nTrecho de Nome Faantasia selecionado: ${fantasia}

    SeleniumLibrary.Input Text    name=${pesquisaAvancada.fantasia}    ${fantasia}    
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando a Fantasia: ${fantasia} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.fantasia}

Filtra cliente por local
    [Documentation]    Irá realizar a consulta de clientes utilizando um local selecionado aleatoriamente.

    @{local}=    Retorna local aleatorio

    ${countRegistros}=    SQL Pesquisa Avancada    local=${local[0]}

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnPesquisarLocal}
    SeleniumLibrary.Wait Until Page Contains Element    id=${pesquisaLocal.input}    
    SeleniumLibrary.Input Text    id=${pesquisaLocal.input}    ${local[1]}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaLocal.input} 
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando o local: ${local[0]} - ${local[1]} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaLocal}

Filtra cliente por documento
    [Documentation]    Irá realizar a consulta de clientes tendo como parâmetro o campo de *Documento*.

    ${documento}=    FakerLibrary.Random Number    digits=2
    ${countRegistros}=    SQL Pesquisa Avancada    documento=${documento}
    WHILE  ${countRegistros} == ${0}
        ${documento}=    FakerLibrary.Random Number    digits=2
        ${countRegistros}=    SQL Pesquisa Avancada    documento=${documento} 
    END

    SeleniumLibrary.Input Text    name=${pesquisaAvancada.documento}    ${documento}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando o documento: ${documento} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.documento}

Filtra cliente por matricula
    [Documentation]    Irá realizar a consulta de clientes tendo como parâmetro o campo *Matrícula*.

    ${parceiro}=    Retornar razao, matricula e id de parceiro aleatorio
    ${matricula}=    BuiltIn.Set Variable    ${parceiro[1]}
    ${countRegistros}=    SQL Pesquisa Avancada    matricula=${matricula}
    WHILE  ${countRegistros} == ${0}
        ${parceiro}=    Retornar razao, matricula e id de parceiro aleatorio
        ${matricula}=    BuiltIn.Set Variable    ${parceiro[1]}
        ${countRegistros}=    SQL Pesquisa Avancada    matricula=${matricula} 
    END

    SeleniumLibrary.Input Text    name=${pesquisaAvancada.matricula}    ${matricula}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando a matrícula: ${matricula} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.matricula}

Filtra cliente por bairro
    [Documentation]    Irá realizar a consulta de clientes tendo como parâmetro o campo *Bairro*.

    ${bairro}=    Retorna bairro aleatorio
    ${countRegistros}=    SQL Pesquisa Avancada    bairro=${bairro}
    WHILE  ${countRegistros} == ${0}
        ${bairro}=    Retorna bairro aleatorio
        ${countRegistros}=    SQL Pesquisa Avancada    bairro=${bairro} 
    END

    SeleniumLibrary.Input Text    name=${pesquisaAvancada.bairro}    ${bairro}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando o bairro: ${bairro} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.bairro}

Filtra cliente por logradouro
    [Documentation]    Irá realizar a consulta de clientes tendo como parâmetro o campo *Logradouro*.

    ${logradouro}=    Retorna logradouro aleatorio
    ${countRegistros}=    SQL Pesquisa Avancada    logradouro=${logradouro}
    WHILE  ${countRegistros} == ${0}
        ${logradouro}=    Retorna logradouro aleatorio
        ${countRegistros}=    SQL Pesquisa Avancada    logradouro=${logradouro} 
    END

    SeleniumLibrary.Input Text    name=${pesquisaAvancada.logradouro}    ${logradouro}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando o logradouro: ${logradouro} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.logradouro}

Filtra cliente por estado
    [Documentation]    Irá realizar a consulta de clientes tendo como parâmetro o campo *UF*.

    ${formatoDescricao}    DatabaseLibrary.Query    select AVG(LENGTH(descricao)) from unidadefederativa u where u.idnativo = 1;
    IF  ${formatoDescricao[0][0]} == ${2}
        ${estadoUnformat}=    FakerLibrary.State Abbr
    ELSE
        ${estadoUnformat}=    FakerLibrary.State
    END
    ${format}    Convert To Upper Case    ${estadoUnformat}
    ${estadoFormat}=    Evaluate    unidecode.unidecode('${format}')
    ${countEstado}=    Retorna count Estado    ${estadoFormat}
    WHILE  ${countEstado} > ${1} or ${countEstado} == ${0}    ## Por hora, só irá filtrar por estados que possuem nome único.
        ${formatoDescricao}    DatabaseLibrary.Query    select AVG(LENGTH(descricao)) from unidadefederativa u where u.idnativo = 1;
        IF  ${formatoDescricao[0][0]} == ${2}
            ${estadoUnformat}=    FakerLibrary.State Abbr
        ELSE
            ${estadoUnformat}=    FakerLibrary.State
        END
        ${format}    Convert To Upper Case    ${estadoUnformat}
        ${estadoFormat}=    Evaluate    unidecode.unidecode('${format}')
        ${countEstado}=    Retorna count Estado    ${estadoFormat}
    END
    ${countRegistros}=    SQL Pesquisa Avancada    estadoUF=${estadoFormat}
    WHILE  ${countRegistros} == ${0}
        ${formatoDescricao}    DatabaseLibrary.Query    select AVG(LENGTH(descricao)) from unidadefederativa u where u.idnativo = 1;
        IF  ${formatoDescricao[0][0]} == ${2}
            ${estadoUnformat}=    FakerLibrary.State Abbr
        ELSE
            ${estadoUnformat}=    FakerLibrary.State
        END
        ${format}    Convert To Upper Case    ${estadoUnformat}
        ${estadoFormat}=    Evaluate    unidecode.unidecode('${format}')
        ${countEstado}=    Retorna count Estado    ${estadoFormat}
        WHILE  ${countEstado} > ${1}    ## Por hora, só irá filtrar por estados que possuem nome único.
            ${formatoDescricao}    DatabaseLibrary.Query    select AVG(LENGTH(descricao)) from unidadefederativa u where u.idnativo = 1;
            IF  ${formatoDescricao[0][0]} == ${2}
                ${estadoUnformat}=    FakerLibrary.State Abbr
            ELSE
                ${estadoUnformat}=    FakerLibrary.State
            END
            ${format}    Convert To Upper Case    ${estadoUnformat}
            ${estadoFormat}=    Evaluate    unidecode.unidecode('${format}')
            ${countEstado}=    Retorna count Estado    ${estadoFormat}
        END
        ${countRegistros}=    SQL Pesquisa Avancada    estadoUF=${estadoFormat}
    END
    
    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnPesquisaUF}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaUnidadeFederativa.input}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaUnidadeFederativa.input}
    SeleniumLibrary.Input Text    id=${pesquisaUnidadeFederativa.input}    ${estadoFormat}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaUnidadeFederativa.input}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando a UF: ${estadoUnformat} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaUF}

Filtra cliente por cidade
    [Documentation]    Irá realizar a consulta de clientes tendo como parâmetro o campo *Cidade*.

    ${cidadeUnformat}=    FakerLibrary.City
    ${format}    Convert To Upper Case    ${cidadeUnformat}
    ${cidade}=    Evaluate    unidecode.unidecode('${format}')
    ${countCidade}=    Retorna count Cidade    ${cidade}
    WHILE  ${countCidade} > ${1} or ${countCidade} == ${0}     ## Por hora, só irá filtrar por cidade que possuem nome único.
        ${cidadeUnformat}=    FakerLibrary.City
        ${format}    Convert To Upper Case    ${cidadeUnformat}
        ${cidade}=    Evaluate    unidecode.unidecode('${format}')
        ${countCidade}=    Retorna count Cidade    ${cidade}
    END
    ${countRegistros}=    SQL Pesquisa Avancada    cidade=${cidade}
    WHILE  ${countRegistros} == ${0}
        ${cidadeUnformat}=    FakerLibrary.City
        ${format}    Convert To Upper Case    ${cidadeUnformat}
        ${cidade}=    Evaluate    unidecode.unidecode('${format}')
        ${countCidade}=    Retorna count Cidade    ${cidade}
        WHILE  ${countCidade} > ${1} or ${countCidade} == ${0} 
            ${cidadeUnformat}=    FakerLibrary.City
            ${format}    Convert To Upper Case    ${cidadeUnformat}
            ${cidade}=    Evaluate    unidecode.unidecode('${format}')
            ${countCidade}=    Retorna count Cidade    ${cidade}
        END
    ${countRegistros}=    SQL Pesquisa Avancada    cidade=${cidade}
    END

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnPesquisaCidade}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaCidade.input}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaCidade.input}
    SeleniumLibrary.Input Text    id=${pesquisaCidade.input}    ${cidade}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaCidade.input}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando a cidade: ${cidade} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaCidade}

Filtra cliente por profissional
    [Documentation]    Irá realizar a consulta de clientes tendo como parâmetro o campo *Profissonal*.

    ${usuario}=    Retornar usuario aleatorio
    ${countRegistros}=    SQL Pesquisa Avancada    usuario=${usuario[0]}
    WHILE  ${countRegistros} == ${0}
        ${usuario}=    Retornar usuario aleatorio
        ${countRegistros}=    SQL Pesquisa Avancada    usuario=${usuario[0]}
    END

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnPesquisaProfissional}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaProfissional.input}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaProfissional.input}
    SeleniumLibrary.Input Text    id=${pesquisaProfissional.input}    ${usuario[1]}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaProfissional.input}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando o profissional: ${usuario[0]} - ${usuario[1]} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaProfissional}

Filtra cliente por classificacao
    [Documentation]    Irá realizar a consulta de clientes tendo como parâmetro o campo *Classificação*.
    ${classificacao}=    Retorna classificacao de parceiro aleatoria
    ${countRegistros}=    SQL Pesquisa Avancada    classificacao=${classificacao[0]}

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnPesquisaClassificacao}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaClassificacao.input}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaClassificacao.input}
    SeleniumLibrary.Input Text    id=${pesquisaClassificacao.input}    ${classificacao[1]}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaClassificacao.input}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando a classificação: ${classificacao[0]} - ${classificacao[1]} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaClassificacao}

Filtra cliente por situacao de cadastro
    [Documentation]    Irá realizar a consulta de clientes tendo como parâmetro o campo *Situação do Cadastro*.

    ${situacaoCadastro}=    Retorna siuacao cadastro    tipo=1
    ${countRegistros}=    SQL Pesquisa Avancada    situacaoCadastro=${situacaoCadastro[0]}

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnPesquisaSituacaoCadastro}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaSituacaoCadastro.input}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaSituacaoCadastro.input}
    SeleniumLibrary.Input Text    id=${pesquisaSituacaoCadastro.input}    ${situacaoCadastro[1]}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaSituacaoCadastro.input}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${countRegistros}
        Log To Console    \nListagem de clientes utilizando a Situação de Cadastro: ${situacaoCadastro[0]} - ${situacaoCadastro[1]} está de acordo.
    ELSE
        Log To Console    Listagem de clientes está incorreta.
        Fail
    END

    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaSituacaoCadastro}