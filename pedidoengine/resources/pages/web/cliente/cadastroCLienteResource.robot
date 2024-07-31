*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas no processo de cadastro de clientes.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/listagemClientesResource.robot
Resource    ${EXECDIR}/resources/locators/web/cliente/cadastroCLienteLocators.robot
Resource    ${EXECDIR}/resources/variables/web/cliente/cadastroClienteVariables.robot
Resource    ${EXECDIR}/resources/variables/web/cliente/listaInscricoesEstaduais.robot

*** Variables ***
${nome}
${matricula}

*** Keywords ***
Acessa tela de cadastro de cliente
    [Documentation]    Irá direcionar o foco para a tela de cadastro de novo cliente.

    SeleniumLibrary.Click Element    id=${cliente.menuCliente}
    Wait Until Element Is Visible    id=${cliente.subMenuCliente}
    SeleniumLibrary.Click Element    id=${cliente.subMenuCliente}
    Wait Until Element Is Visible    id=${cliente.novoCliente}
    SeleniumLibrary.Click Element    id=${cliente.novoCliente}
    Wait Until Page Contains Element    xpath=${tituloPaginaCadastroCLiente}    10s
    Wait Until Element Is Visible    id=${cabecalhoCliente.idCabecalho}

Cadastra cliente juridico
    [Documentation]    Irá cadastrar um novo cliente do tipo pessoa jurítica.

    Preenche dados gerais pessoa jurídica
    Preenche dados de complemento pessoa juridica
    Prrenche dados gerais de local cliente juridico
    Preenche dados complementares do local
    Grava cadastro de cliente
    Valida cliente listagem

Cadastra cliente juridico para cada inscrição estadual 
    [Documentation]    Irá cadastrar um novo cliente do tipo pessoa jurítica para cada incrição estadual salva em variaveis. 
    FOR  ${i}  IN  @{inscricoes}
        Acessa tela de cadastro de cliente
        Preenche dados gerais pessoa jurídica
        Preenche dados de complemento pessoa juridica
        Prrenche dados gerais de local cliente juridico        ${i['estado']}    ${i['cidade']}
        Preenche dados de identificação - inscrição estadual      ${i['inscricao']}
        Preenche dados complementares do local
        Grava cadastro de cliente
        Valida cliente listagem
    END

Preenche dados gerais pessoa jurídica
    [Documentation]    Irá preencher os dados gerais do cliente levando em consideração que este se trata de pessoa jurídica.

    ${nomeParceiro}=    FakerLibrary.Company
    Set Test Variable    ${nome}    ${nomeParceiro}
    ${numeroMatricula}=    FakerLibrary.Random Number
    Set Test Variable    ${matricula}    ${numeroMatricula}
    ${homepage}=    FakerLibrary.Url    schemes=None

    SeleniumLibrary.Click Element    xpath=${geralCliente.pessoajuridica}
    SeleniumLibrary.Click Element    xpath=${geralCliente.contribuinte}
    SeleniumLibrary.Input Text    name=${geralCliente.nomeCliente}    ${nomeParceiro} 
    SeleniumLibrary.Input Text    name=${geralCliente.fantasiaCliente}    ${nomeParceiro}
    SeleniumLibrary.Input Text    name=${geralCliente.numeroMatricula}    ${numeroMatricula}
    SeleniumLibrary.Click Element    name=${geralCliente.expandeClassificacao}
    #SeleniumLibrary.Click Element    xpath=${geralCliente.classificacaoConsumidorFinal}
    SeleniumLibrary.Input Text    name=${geralCliente.homepage}    ${homepage}

Preenche dados de complemento pessoa juridica
    [Documentation]    Irá preencher os dados complementares do cliente levando em consideração que este se trata de pessoa jurídica.

    ${cnpj}=    FakerLibrary.cnpj
    ${numeroFuncionarios}=    FakerLibrary.Random Int    min=1    max=10000
    ${dataFundacao}=    FakerLibrary.Date    pattern=%d-%m-%Y
    ${valorFaturamento}=    FakerLibrary.Random Number    digits=7
    ${valorCapitalSocial}=    FakerLibrary.Random Number    digits=7
    ${valorCapitalSubscrito}=    FakerLibrary.Random Number    digits=7
    ${valorCapitalIntegral}=    FakerLibrary.Random Number    digits=7

    ${campoCnpj}=    BuiltIn.Run Keyword And Ignore Error    SeleniumLibrary.Page Should Contain Element    name=${complementoClienteJuridico.cnpj}
    BuiltIn.Run Keyword If    '${campoCnpj[0]}' == 'PASS'    SeleniumLibrary.Input Text    name=${complementoClienteJuridico.cnpj}    ${cnpj}
    SeleniumLibrary.Input Text    name=${complementoClienteJuridico.numeroFuncionarios}    ${numeroFuncionarios}
    SeleniumLibrary.Input Text    name=${complementoClienteJuridico.dataFundacao}    ${dataFundacao}
    SeleniumLibrary.Press Keys    name=${complementoClienteJuridico.valorFaturamento}    ${valorFaturamento}
    SeleniumLibrary.Press Keys    name=${complementoClienteJuridico.valorCapitalSocial}    ${valorCapitalSocial}
    SeleniumLibrary.Press Keys    name=${complementoClienteJuridico.valorCapitalSubscrito}    ${valorCapitalSubscrito}
    SeleniumLibrary.Press Keys    name=${complementoClienteJuridico.valorCapitalIntegral}    ${valorCapitalIntegral}

Prrenche dados gerais de local cliente juridico
    [Documentation]    Irá preencher os dados gerais do local levando em consideração que este se trata de local de pessoa jurídica.
    [Arguments]    ${estadoArg}=${EMPTY}    ${cidadeArg}=${EMPTY}

    ${logradouro}=    FakerLibrary.Street Name
    ${numero}=    FakerLibrary.Building Number
    ${bairro}=    FakerLibrary.bairro
    ${cep}=    FakerLibrary.Postcode
    ${limteCredito}=    FakerLibrary.Random Number    digits=6
    ${telefone}=    FakerLibrary.Cellphone Number
    ${telefoneFormat}    Remove String    ${telefone}    +55    (    )    -    ${telefone[0:1]}
    ${email}=    FakerLibrary.Email
    ${cnpj}=    FakerLibrary.cnpj

    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.descricao}    ${logradouro}, ${numero} - ${bairro}
    ${campoCnpj}=    BuiltIn.Run Keyword And Ignore Error    SeleniumLibrary.Page Should Contain Element    name=${localGeralClienteJuridico.documento}
    BuiltIn.Run Keyword If    '${campoCnpj[0]}' == 'PASS'    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.documento}    ${cnpj}
    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.logradouro}    ${logradouro}
    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.numero}    ${numero}
    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.bairro}    ${bairro}
    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.cep}    ${cep}
    SeleniumLibrary.Click Element    id=${localGeralClienteJuridico.uf}
    
    IF  "${estadoArg}" == "${EMPTY}" and "${cidadeArg}" == "${EMPTY}"
        Selecionar cidade e estados aleatórios 
    ELSE
        Selecionar estado e cidade de acordo com o que foi passado como argumento    ${estadoArg}    ${cidadeArg}
    END

    SeleniumLibrary.Input Text    id=${localGeralClienteJuridico.limteCredito}    ${limteCredito} 
    SeleniumLibrary.Input Text    id=${localGeralClienteJuridico.telefone}    ${telefoneFormat}
    SeleniumLibrary.Input Text    id=${localGeralClienteJuridico.email}    ${email}
    

Selecionar estado e cidade de acordo com o que foi passado como argumento
    [Documentation]    Irá selecionar a cidade e o estado que foram passados por argumento no cadastro de pessoa jurídica.
    [Arguments]    ${estadoArg}    ${cidadeArg}
    SeleniumLibrary.Click Element    xpath=//*[@id="${localGeralClienteJuridico.uf}"]/option[contains(text(),'${estadoArg}')] 

    ${cidade}    Convert To Upper Case    ${cidadeArg}
    ${cidadeFormat}=    Evaluate    unidecode.unidecode('${cidade}')
    Sleep    0.5s
    SeleniumLibrary.Click Element    xpath=//*[@id="${localGeralClienteJuridico.comboCidade}"]/option[contains(text(),'${cidadeFormat}')] 

Selecionar cidade e estados aleatórios 
    [Documentation]    Irá selecionar a cidade e o estado de modo aleatório no cadastro de pessoa jurídica.
    
    ${formatoDescricao}    DatabaseLibrary.Query    select AVG(LENGTH(descricao)) from unidadefederativa u where u.idnativo = 1;
    IF  ${formatoDescricao[0][0]} == ${2}
        ${estado}=    FakerLibrary.State Abbr
    ELSE
        ${estado}=    FakerLibrary.State
    END
    
    ${uf}    Convert To Upper Case    ${estado}
    ${estadoFormat}=    Evaluate    unidecode.unidecode('${uf}')

    SeleniumLibrary.Click Element    xpath=//*[@id="${localGeralClienteJuridico.uf}"]/option[contains(text(),'${estadoFormat}')]    
    ## Irá capturar a quantidade de opções no combo de cidade após informado o estado, e sorteará um index aleatório, selecionado
    ## assim a cidade que se encontra presente naquele index
    Sleep    0.5s
    ${countCidades}    SeleniumLibrary.Get Element Count    xpath=//*[@id="${localGeralClienteJuridico.comboCidade}"]/option
    ${iCidade}=    BuiltIn.Evaluate    random.randint(2, ${countCidades})    random
    SeleniumLibrary.Click Element    xpath=//*[@id="${localGeralClienteJuridico.comboCidade}"]/option[${iCidade}]  
    
Preenche dados complementares do local
    [Documentation]    Irá preencher os dados complementares do local.

    ${coutTipoLocal}    SeleniumLibrary.Get Element Count    xpath=//*[@id="${localComplemento.tipoLocal}"]/option
    IF  ${coutTipoLocal} > 2
        ${tipoLocal}=    BuiltIn.Evaluate    random.randint(2, ${coutTipoLocal})    random
        SeleniumLibrary.Wait Until Element Is Not Visible    class=${telaLoading}    15s
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.tipoLocal}"]/option[${tipoLocal}] 
    END

    ${coutTipologia}    SeleniumLibrary.Get Element Count    xpath=//*[@id="${localComplemento.tipologia}"]/option
    IF  ${coutTipologia} > 2
        ${tipologia}=    BuiltIn.Evaluate    random.randint(2, ${coutTipologia})    random
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.tipologia}"]/option[${tipologia}] 
    END
    
    ${CountRegiao}    SeleniumLibrary.Get Element Count    xpath=//*[@id="${localComplemento.regiao}"]/option
    IF  ${CountRegiao} > 2
        ${regiao}=    BuiltIn.Evaluate    random.randint(2, ${CountRegiao})    random
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.regiao}"]/option[${regiao}]  
    END

    ${coutSegmento}    SeleniumLibrary.Get Element Count    xpath=//*[@id="${localComplemento.segmento}"]/option
    IF  ${coutSegmento} > 2
        ${segmento}=    BuiltIn.Evaluate    random.randint(2, ${coutSegmento})    random
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.segmento}"]/option[${segmento}] 
    END

    ${coutTabelaPreco}    SeleniumLibrary.Get Element Count    xpath=//*[@id="${localComplemento.tabelaPreco}"]/option
    IF  ${coutTabelaPreco} > 2
        ${tabelaPreco}=    BuiltIn.Evaluate    random.randint(2, ${coutTabelaPreco})    random
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.tabelaPreco}"]/option[${tabelaPreco}] 
    END

    ${coutCondicaoPagamento}    SeleniumLibrary.Get Element Count    xpath=//*[@id="${localComplemento.condicaoPagamento}"]/option
    IF  ${coutCondicaoPagamento} > 2
        ${condicaoPagamento}=    BuiltIn.Evaluate    random.randint(2, ${coutCondicaoPagamento})    random
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.condicaoPagamento}"]/option[${condicaoPagamento}] 
    END

    ${coutTipoCobranca}    SeleniumLibrary.Get Element Count    xpath=//*[@id="${localComplemento.tipoCobranca}"]/option
    IF  ${coutTipoCobranca} > 2
        ${tipoCobranca}=    BuiltIn.Evaluate    random.randint(2, ${coutTipoCobranca})    random
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.tipoCobranca}"]/option[${tipoCobranca}] 
    END

    SeleniumLibrary.Input Text    ${localComplemento.observacao}    Cliente cadastrado por meio de teste automatizado.

Grava cadastro de cliente
    [Documentation]    Irá gravar as informações do cadastro de cliente.
    SeleniumLibrary.Click Element    id=${btnGravarCadastro}

    SeleniumLibrary.Wait Until Element Is Visible    id=${cadastroBemSucedido}
    BuiltIn.Sleep    1s
    SeleniumLibrary.Element Should Contain    id=${cadastroBemSucedido}    ${msgCadastroBemSucedido}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpAcoes.popUp}    10s
    SeleniumLibrary.Capture Page Screenshot

Valida cliente listagem 
    [Documentation]    Irá validar se o cliente cadastrado está sendo exibido na listagem de clientes.

    SeleniumLibrary.Click Element    xpath=${popUpAcoes.listaClientes}   
    SeleniumLibrary.Wait Until Page Contains Element    xpath=${tituloPaginaListagemCliente}    10s
    Filtra cliente especifico    ${nome}    ${matricula}

Valida campos obrigatorios do cliente
    [Documentation]    Esta keyword é responsável por verificar se os campos tidos como obrigtórios estão preenchidos corretamente no cadastro do cliente.

    ${urlAtual}=    SeleniumLibrary.Get Location
    ${listaXpath}    Retornar xpath do elemento pai    css_class=requerido    url=${urlAtual}
    ${lenght}    BuiltIn.Get Length    ${listaXpath}

    Log To Console    \nCampos obrigatórios:
    FOR  ${i}  IN RANGE    ${lenght}
        ${campo}=    SeleniumLibrary.Get Text    xpath=${listaXpath[${i}]}/label
        ${campoStr}=    String.Remove String    ${campo}    :
        Log To Console    ${campoStr}
    END

    SeleniumLibrary.Click Element    id=${btnGravarCadastro}
    Sleep    0.7s

    FOR  ${i}  IN RANGE    ${lenght}
        SeleniumLibrary.Element Should Be Visible    xpath=${listaXpath[${i}]}/div[@class="error"]
    END

Retorna parceiro tipo cobranca aleatorio
    [Documentation]    Utilizada para retornar um parceiro aleatório levando em conta que este possui tipo de cobrança padrão.
    ...    \nEsta keyword retorna uma lista contendo a *Razão Social*, *Matrícula* e descrição do *Tipo cobrança* padrão, respectivamente.

    ${dados}    Query    ${SQL_PARCEIRO_MATRICULA_TIPO_COBRANCA}
    ${countDados}    Row Count    ${SQL_PARCEIRO_MATRICULA_TIPO_COBRANCA}
    ${index}=    Evaluate    random.sample(range(0, ${countDados}), 1)    random

    Return From Keyword    ${dados[${index[0]}][0]}    ${dados[${index[0]}][1]}    ${dados[${index[0]}][2]}

Valida tipo cobranca padrao
    [Documentation]    Esta keyword é responsável por editar o cadastro de um cliente aleatório e validar se a opção exibida no combo de *Tipo cobrança* está
    ...    de acordo com o banco de dados.

    ${dadosParceiro}=    Retorna parceiro tipo cobranca aleatorio
    Log To Console    Parceiro selecionado: ${dadosParceiro[0]}

    SeleniumLibrary.Input Text    name=${pesquisaAvancada.razaoSocial}    ${dadosParceiro[0]}
    SeleniumLibrary.Input Text    name=${pesquisaAvancada.matricula}    ${dadosParceiro[1]}
    SeleniumLibrary.Click Element    xpath=${pesquisaRapida.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}

    ${stringQtdeRegistros}    SeleniumLibrary.Get Text    class=${gridClientes.labelQtdeRegsitros}
    ${removeQtdeRegitros}    Remove String    ${stringQtdeRegistros}    Registros    (    )    .
    ${intQtdeRegistros}    Convert To Integer    ${removeQtdeRegitros}

    IF  ${intQtdeRegistros} == ${1}
        SeleniumLibrary.Click Element    ${gridClientes.btnEditar}
        SeleniumLibrary.Wait Until Element Is Not Visible    class=${telaLoading}    15s
        SeleniumLibrary.Wait Until Element Is Enabled    xpath=${edicaoCliente.edicaoLocal}
        SeleniumLibrary.Click Element    xpath=${edicaoCliente.edicaoLocal}
        SeleniumLibrary.Wait Until Element Is Not Visible    class=${telaLoading}    15s
        SeleniumLibrary.Wait Until Element Is Enabled    id=${localComplemento.tipoCobranca}
        ${valor}=    SeleniumLibrary.Get Value   id=${localComplemento.tipoCobranca}    
        ${tipoCobranca}=    SeleniumLibrary.Get Text    xpath=//*[@id="${localComplemento.tipoCobranca}"]/option[@value="${valor}"]
        IF  '${tipoCobranca}'== '${dadosParceiro[2]}'
            Log To Console    Tipo cobrança: ${tipoCobranca} corresponde ao registro salvo no banco de dados.
        ELSE    
            Log To Console    Tipo cobrança: ${tipoCobranca} *não* corresponde ao registro salvo no banco de dados.
            Fail
        END
        SeleniumLibrary.Click Element    id=${btnCancelarCadastro}
    ELSE
        Log To Console    Filtragem do cliente está inconsistênte.
        Fail
    END

Preenche dados de identificação - inscrição estadual 
    [Documentation]        irá preencher somente o campo de inscrição estadual
    [Arguments]      ${INSCRICAO}=0121754832766
    Wait Until Element Is Visible    id=${dadosIdentificacao.inscricaoEstadual}     timeout=30s
    Press Keys      id=${dadosIdentificacao.inscricaoEstadual}     ${INSCRICAO}