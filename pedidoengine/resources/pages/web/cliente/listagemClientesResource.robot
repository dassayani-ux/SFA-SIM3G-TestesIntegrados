*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas no processo de listagem de clientes.

Resource    ${EXECDIR}/pedidoengine/resources/lib/web/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/cliente/listaClientesLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/data/cliente/dataCliente.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/local/localResources.robot
Resource    ${EXECDIR}/pedidoengine/resources/data/usuario/dataUsuario.robot

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

Prepara dados de automacao para listagem
    [Documentation]    Carrega dados do primeiro cliente de automação para uso nos testes de filtro.
    ...                Deve ser executado no Suite Setup, após conectar ao banco.
    ${sql}=    Catenate    SEPARATOR=\n
    ...    SELECT p.numeromatricula,
    ...           COALESCE(pj.documentoidentificacao, pf.documentoidentificacao, ''),
    ...           COALESCE(l.bairro, ''),
    ...           COALESCE(l.logradouro, ''),
    ...           COALESCE(c.descricao, ''),
    ...           COALESCE(uf.descricao, '')
    ...    FROM parceiro p
    ...    LEFT JOIN pessoajuridica pj ON p.idparceiro = pj.idpessoajuridica
    ...    LEFT JOIN pessoafisica pf ON p.idparceiro = pf.idpessoafisica
    ...    INNER JOIN parceirolocal pl ON p.idparceiro = pl.idparceiro
    ...    INNER JOIN local l ON pl.idlocal = l.idlocal
    ...    LEFT JOIN cidade c ON l.idcidade = c.idcidade
    ...    LEFT JOIN unidadefederativa uf ON c.idunidadefederativa = uf.idunidadefederativa
    ...    WHERE p.nomeparceiro LIKE '%Automação%' AND p.idnativo = 1
    ...    ORDER BY p.idparceiro DESC LIMIT 1
    ${res}=    DatabaseLibrary.Query    ${sql}
    Should Not Be Empty    ${res}
    ...    msg=❌ Nenhum cliente Automação encontrado. Execute cadastroCliente.robot primeiro.
    Set Suite Variable    ${auto_matricula}      ${res[0][0]}
    Set Suite Variable    ${auto_documento}      ${res[0][1]}
    Set Suite Variable    ${auto_bairro}         ${res[0][2]}
    Set Suite Variable    ${auto_logradouro}     ${res[0][3]}
    Set Suite Variable    ${auto_cidade}         ${res[0][4]}
    Set Suite Variable    ${auto_uf}             ${res[0][5]}
    Log To Console    \n✅ Dados automação: matrícula=${auto_matricula} | cidade=${auto_cidade} | UF=${auto_uf}

Filtra cliente na pesquisa rapida por nome
    [Documentation]    Pesquisa rápida pelo termo 'automação' — garante resultados em qualquer base
    ...                onde os testes de cadastro foram executados. Valida contagem tela = banco.
    ${count}=    Pesquisa rapida sql    automação
    Should Be True    ${count} > 0
    ...    msg=❌ Nenhum cliente 'automação' encontrado. Execute cadastroCliente.robot antes.
    Log To Console    \nPesquisa rápida por 'automação': ${count} registros esperados.
    SeleniumLibrary.Input Text    name=${pesquisaRapida.inputPesquisa}    automação
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${count}
    ...    msg=❌ Pesquisa por 'automação': tela=${intQtdeRegistros}, banco=${count}
    Log To Console    ✅ Pesquisa rápida por nome validada: ${intQtdeRegistros} registros.
    SeleniumLibrary.Clear Element Text    name=${pesquisaRapida.inputPesquisa}

Filtra cliente na pesquisa rapida por numero
    [Documentation]    Pesquisa rápida pela matrícula do cliente de automação (carregada no Suite Setup).
    ${count}=    Pesquisa rapida sql    ${auto_matricula}
    Should Be True    ${count} > 0
    ...    msg=❌ Matrícula '${auto_matricula}' não retornou resultados no banco.
    Log To Console    \nPesquisa rápida por matrícula '${auto_matricula}': ${count} registros esperados.
    SeleniumLibrary.Input Text    name=${pesquisaRapida.inputPesquisa}    ${auto_matricula}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${count}
    ...    msg=❌ Pesquisa por matrícula '${auto_matricula}': tela=${intQtdeRegistros}, banco=${count}
    Log To Console    ✅ Pesquisa rápida por número validada: ${intQtdeRegistros} registros.
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

    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro tipo pessoa '${tipo}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por tipo de pessoa '${tipo}' validado: ${intQtdeRegistros} registros.

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

    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro situação '${situacao}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por situação '${situacao}' validado: ${intQtdeRegistros} registros.

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

        Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
        ...    msg=❌ Filtro situação aprovação '${situacoesAprovacao[${I}]}': tela=${intQtdeRegistros}, banco=${countRegistros}
        Log To Console    ✅ Situação aprovação '${situacoesAprovacao[${I}]}': ${intQtdeRegistros} registros.

        SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaBuscaSituacaoAprovacao}
    END

Filtra cliente por razao social
    [Documentation]    Filtra por razão social usando 'Automação' — presente em todos os clientes criados
    ...                pela automação. Valida contagem tela = banco.
    ${countRegistros}=    SQL Pesquisa Avancada    razaoSocial=Automação
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Nenhum cliente com razão social 'Automação'. Execute cadastroCliente.robot antes.
    Log To Console    \nFiltro razão social 'Automação': ${countRegistros} registros esperados.
    SeleniumLibrary.Input Text    name=${pesquisaAvancada.razaoSocial}    Automação
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro razão social 'Automação': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por razão social validado: ${intQtdeRegistros} registros.
    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.razaoSocial}

Filtra cliente por fantasia
    [Documentation]    Filtra por nome fantasia usando 'Automação' — presente em todos os clientes PJ
    ...                criados pela automação. Valida contagem tela = banco.
    ${countRegistros}=    SQL Pesquisa Avancada    nomeFantasia=Automação
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Nenhum cliente com nome fantasia 'Automação'. Execute cadastroCliente.robot antes.
    Log To Console    \nFiltro nome fantasia 'Automação': ${countRegistros} registros esperados.
    SeleniumLibrary.Input Text    name=${pesquisaAvancada.fantasia}    Automação
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro nome fantasia 'Automação': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por nome fantasia validado: ${intQtdeRegistros} registros.
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

    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro local '${local[0]}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por local '${local[0]} - ${local[1]}' validado: ${intQtdeRegistros} registros.
    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaLocal}

Filtra cliente por documento
    [Documentation]    Filtra pelo documento (CNPJ/CPF) do cliente de automação carregado no Suite Setup.
    ${fragmento}=    Get Substring    ${auto_documento}    0    6
    ${countRegistros}=    SQL Pesquisa Avancada    documento=${fragmento}
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Documento '${fragmento}' não retornou registros. Verifique ${auto_documento}.
    Log To Console    \nFiltro documento '${fragmento}': ${countRegistros} registros esperados.
    SeleniumLibrary.Input Text    name=${pesquisaAvancada.documento}    ${fragmento}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro documento '${fragmento}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por documento validado: ${intQtdeRegistros} registros.
    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.documento}

Filtra cliente por matricula
    [Documentation]    Filtra pela matrícula exata do cliente de automação carregada no Suite Setup.
    ${countRegistros}=    SQL Pesquisa Avancada    matricula=${auto_matricula}
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Matrícula '${auto_matricula}' não retornou registros no banco.
    Log To Console    \nFiltro matrícula '${auto_matricula}': ${countRegistros} registros esperados.
    SeleniumLibrary.Input Text    name=${pesquisaAvancada.matricula}    ${auto_matricula}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro matrícula '${auto_matricula}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por matrícula validado: ${intQtdeRegistros} registros.
    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.matricula}

Filtra cliente por bairro
    [Documentation]    Filtra pelo bairro do cliente de automação ('Centro', fixo em todos os cadastros).
    ${countRegistros}=    SQL Pesquisa Avancada    bairro=Centro
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Nenhum cliente com bairro 'Centro' encontrado.
    Log To Console    \nFiltro bairro 'Centro': ${countRegistros} registros esperados.
    SeleniumLibrary.Input Text    name=${pesquisaAvancada.bairro}    Centro
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro bairro 'Centro': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por bairro validado: ${intQtdeRegistros} registros.
    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.bairro}

Filtra cliente por logradouro
    [Documentation]    Filtra pelo logradouro do cliente de automação ('Avenida Brasil', fixo nos cadastros).
    ${countRegistros}=    SQL Pesquisa Avancada    logradouro=Avenida Brasil
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Nenhum cliente com logradouro 'Avenida Brasil' encontrado.
    Log To Console    \nFiltro logradouro 'Avenida Brasil': ${countRegistros} registros esperados.
    SeleniumLibrary.Input Text    name=${pesquisaAvancada.logradouro}    Avenida Brasil
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro logradouro 'Avenida Brasil': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por logradouro validado: ${intQtdeRegistros} registros.
    SeleniumLibrary.Clear Element Text    name=${pesquisaAvancada.logradouro}

Filtra cliente por estado
    [Documentation]    Filtra pelo estado do cliente de automação carregado no Suite Setup.
    ...                O valor vem direto do banco, portanto funciona em qualquer base.
    ${countRegistros}=    SQL Pesquisa Avancada    estadoUF=${auto_uf}
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Nenhum cliente no estado '${auto_uf}' encontrado para o usuário logado.
    Log To Console    \nFiltro UF '${auto_uf}': ${countRegistros} registros esperados.
    ${btnUF}=    Set Variable
    ...    xpath=//*[starts-with(@id,'btnPesquisarUNIDADEFEDERATIVA')]//span[contains(@class,'ui-button-icon-primary')]
    ${btnVisivel}=    Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    ${btnUF}    3s
    Run Keyword If    not ${btnVisivel}
    ...    SeleniumLibrary.Click Element    class=${pesquisaAvancada.exibePesquisa}
    SeleniumLibrary.Wait Until Element Is Visible    ${btnUF}    10s
    SeleniumLibrary.Click Element    ${btnUF}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaUnidadeFederativa.input}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaUnidadeFederativa.input}
    SeleniumLibrary.Input Text    id=${pesquisaUnidadeFederativa.input}    ${auto_uf}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaUnidadeFederativa.input}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro UF '${auto_uf}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por UF '${auto_uf}' validado: ${intQtdeRegistros} registros.
    # Garante painel aberto antes do cleanup (pode ter fechado após pesquisar)
    ${btnUFVisivel}=    Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    ${btnUF}    3s
    Run Keyword If    not ${btnUFVisivel}
    ...    SeleniumLibrary.Click Element    class=${pesquisaAvancada.exibePesquisa}
    SeleniumLibrary.Wait Until Element Is Visible    ${btnUF}    10s
    # Limpar: irmão seguinte do botão de pesquisa (evita xpath posicional li[17])
    SeleniumLibrary.Click Element
    ...    xpath=//*[starts-with(@id,'btnPesquisarUNIDADEFEDERATIVA')]/following-sibling::a[1]

Filtra cliente por cidade
    [Documentation]    Filtra pela cidade do cliente de automação carregada no Suite Setup.
    ...                Usa o idcidade exato do cliente automação para evitar ambiguidade
    ...                (múltiplas cidades com o mesmo nome em estados diferentes).
    ${usuario}=    Retornar id usuario logado web
    ${sql_count}=    Catenate    SEPARATOR=\n
    ...    SELECT COUNT(DISTINCT p.idparceiro) FROM parceiro p
    ...    INNER JOIN parceirolocal pl ON p.idparceiro = pl.idparceiro
    ...    INNER JOIN local l ON pl.idlocal = l.idlocal
    ...    INNER JOIN cidade c ON l.idcidade = c.idcidade
    ...    INNER JOIN usuariolocal ul ON l.idlocal = ul.idlocal
    ...    INNER JOIN usuario u ON ul.idusuario = u.idusuario
    ...    LEFT OUTER JOIN usuariohierarquia uh ON u.idusuario = uh.idusuario
    ...    LEFT OUTER JOIN usuario us ON uh.idusuariosuperior = us.idusuario
    ...    WHERE c.descricao = '${auto_cidade}'
    ...    AND p.idnativo = 1
    ...    AND (u.idusuario = ${usuario} OR us.idusuario = ${usuario})
    ${res}=    DatabaseLibrary.Query    ${sql_count}
    ${countRegistros}=    Set Variable    ${res[0][0]}
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Nenhum cliente em '${auto_cidade}' encontrado para o usuário logado.
    Log To Console    \nFiltro cidade '${auto_cidade}': ${countRegistros} registros esperados.
    ${btnCidade}=    Set Variable
    ...    xpath=//*[starts-with(@id,'btnPesquisarCIDADE_cidade')]//span[contains(@class,'ui-button-icon-primary')]
    ${btnVisivel}=    Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    ${btnCidade}    3s
    Run Keyword If    not ${btnVisivel}
    ...    SeleniumLibrary.Click Element    class=${pesquisaAvancada.exibePesquisa}
    SeleniumLibrary.Wait Until Element Is Visible    ${btnCidade}    10s
    SeleniumLibrary.Click Element    ${btnCidade}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaCidade.input}    10s
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaCidade.input}
    SeleniumLibrary.Input Text    id=${pesquisaCidade.input}    ${auto_cidade}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaCidade.input}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro cidade '${auto_cidade}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por cidade '${auto_cidade}' validado: ${intQtdeRegistros} registros.
    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaCidade}

Filtra cliente por profissional
    [Documentation]    Filtra pela carteira do usuário logado. O mesmo ID é usado na query SQL e na
    ...                busca da tela, garantindo que tela e banco sempre representem o mesmo escopo.
    ${usuario_id}=    Retornar id usuario logado web
    ${res}=    DatabaseLibrary.Query
    ...    SELECT login FROM usuario WHERE idusuario = ${usuario_id}
    ${usuario_login}=    Set Variable    ${res[0][0]}
    ${countRegistros}=    SQL Pesquisa Avancada    usuario=${usuario_id}
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Usuário logado '${usuario_login}' não possui clientes na carteira.
    Log To Console    \nFiltro profissional '${usuario_login}': ${countRegistros} registros esperados.
    ${btnVisivel}=    Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    xpath=${pesquisaAvancada.btnPesquisaProfissional}    3s
    Run Keyword If    not ${btnVisivel}
    ...    SeleniumLibrary.Click Element    class=${pesquisaAvancada.exibePesquisa}
    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnPesquisaProfissional}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaProfissional.input}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaProfissional.input}
    SeleniumLibrary.Input Text    id=${pesquisaProfissional.input}    ${usuario_login}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaProfissional.input}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro profissional '${usuario_login}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por profissional '${usuario_login}' validado: ${intQtdeRegistros} registros.
    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaProfissional}

Filtra cliente por classificacao
    [Documentation]    Busca no banco uma classificação sem caracteres especiais (sem /  & ( ) que
    ...                quebram a busca no modal) e que tenha pelo menos 1 cliente vinculado.
    ${sql}=    Catenate    SEPARATOR=\n
    ...    SELECT cp.idclassificacaoparceiro, cp.descricao
    ...    FROM classificacaoparceiro cp
    ...    INNER JOIN parceiro p ON p.idclassificacaoparceiro = cp.idclassificacaoparceiro
    ...    WHERE cp.idnativo = 1
    ...    AND cp.descricao NOT LIKE '%/%'
    ...    AND cp.descricao NOT LIKE '%&%'
    ...    AND cp.descricao NOT LIKE '%(%'
    ...    GROUP BY cp.idclassificacaoparceiro, cp.descricao
    ...    HAVING COUNT(p.idparceiro) > 0
    ...    ORDER BY cp.descricao LIMIT 1
    ${res}=    DatabaseLibrary.Query    ${sql}
    Should Not Be Empty    ${res}    msg=❌ Nenhuma classificação sem caracteres especiais encontrada.
    ${classificacao_id}=    Set Variable    ${res[0][0]}
    ${classificacao_desc}=    Set Variable    ${res[0][1]}
    ${countRegistros}=    SQL Pesquisa Avancada    classificacao=${classificacao_id}
    Should Be True    ${countRegistros} > 0
    ...    msg=❌ Classificação '${classificacao_desc}' não retornou clientes.
    Log To Console    \nFiltro classificação '${classificacao_desc}': ${countRegistros} registros esperados.
    ${btnVisivel}=    Run Keyword And Return Status
    ...    SeleniumLibrary.Wait Until Element Is Visible    xpath=${pesquisaAvancada.btnPesquisaClassificacao}    3s
    Run Keyword If    not ${btnVisivel}
    ...    SeleniumLibrary.Click Element    class=${pesquisaAvancada.exibePesquisa}
    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnPesquisaClassificacao}
    SeleniumLibrary.Wait Until Element Is Visible    id=${pesquisaClassificacao.input}
    SeleniumLibrary.Wait Until Element Is Enabled    id=${pesquisaClassificacao.input}
    SeleniumLibrary.Input Text    id=${pesquisaClassificacao.input}    ${classificacao_desc}
    SeleniumLibrary.Press Keys    None    ENTER
    Sleep    0.5s
    SeleniumLibrary.Press Keys    None    ENTER
    SeleniumLibrary.Wait Until Page Does Not Contain Element    id=${pesquisaClassificacao.input}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}
    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}
    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro classificação '${classificacao_desc}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por classificação '${classificacao_desc}' validado: ${intQtdeRegistros} registros.
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

    Should Be Equal As Integers    ${intQtdeRegistros}    ${countRegistros}
    ...    msg=❌ Filtro situação cadastro '${situacaoCadastro[1]}': tela=${intQtdeRegistros}, banco=${countRegistros}
    Log To Console    ✅ Filtro por situação de cadastro '${situacaoCadastro[1]}' validado: ${intQtdeRegistros} registros.
    SeleniumLibrary.Click Element    xpath=${pesquisaAvancada.btnLimpaPesquisaSituacaoCadastro}