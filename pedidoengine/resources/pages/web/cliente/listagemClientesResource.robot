*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas no processo de listagem de clientes.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/variables/web/global/newGlobalVariables.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/locators/web/cliente/listaClientesLocators.robot
Resource    ${EXECDIR}/resources/data/cliente/dataCliente.robot

*** Keywords ***
Acessa tela de listagem de clientes
    [Documentation]    Irá acessar a tela de listagem de clientes.
    Click Element    id=${cliente.menuCliente}
    Wait Until Element Is Visible    id=${cliente.subMenuCliente}    5
    Click Element    id=${cliente.subMenuCliente}
    Wait Until Element Is Visible     id=${cliente.menuClienteListar}    5
    Click Element    id=${cliente.menuClienteListar}
    Wait Until Page Contains Element    ${tituloPaginaListagemCliente}    20
    Capture Page Screenshot

Retorna cliente ativo
    [Documentation]    Irá retornar uma lista contenedo um id e um nome de cliente random ativo.
    ${COUNT}    Row Count    ${CLIENTE_ATIVO_SQL}
    ${CLIENTE_ATIVO}    Query    ${CLIENTE_ATIVO_SQL}
    ${Index}=    Evaluate    random.sample(range(0, ${COUNT}), 1)    random

    Log To Console    \nCliente selecionado: ${CLIENTE_ATIVO[${Index[0]}][0]} - ${CLIENTE_ATIVO[${Index[0]}][1]}

    Return From Keyword    ${CLIENTE_ATIVO[${Index[0]}][0]}    ${CLIENTE_ATIVO[${Index[0]}][1]}

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
    