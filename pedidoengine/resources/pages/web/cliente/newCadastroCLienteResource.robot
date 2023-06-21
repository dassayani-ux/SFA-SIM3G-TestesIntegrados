*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas no processo de cadastro de clientes.

Resource    ${EXECDIR}/resources/lib/web/lib.robot
Resource    ${EXECDIR}/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/resources/pages/web/cliente/listagemClientesResource.robot
Resource    ${EXECDIR}/resources/locators/web/cliente/cadastroCLienteLocators.robot
Resource    ${EXECDIR}/resources/variables/web/cliente/newCadastroClienteVariables.robot

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
    Capture Page Screenshot

Cadastra cliente juridico
    [Documentation]    Irá cadastrar um novo cliente do tipo pessoa jurítica.

    Preenche dados gerais pessoa jurídica
    Preenche dados de complemento pessoa juidica
    Prrenche dados gerais de local cliente juridico
    Preenche dados complementares do local
    Grava cadastro de cliente
    Valida cliente listagem

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
    SeleniumLibrary.Click Element    xpath=${geralCliente.classificacaoConsumidorFinal}
    SeleniumLibrary.Input Text    name=${geralCliente.homepage}    ${homepage}

Preenche dados de complemento pessoa juidica
    [Documentation]    Irá preencher os dados complementares do cliente levando em consideração que este se trata de pessoa jurídica.

    ${cnpj}=    FakerLibrary.cnpj
    ${numeroFuncionarios}=    FakerLibrary.Random Int    min=1    max=10000
    ${dataFundacao}=    FakerLibrary.Date    pattern=%d-%m-%Y
    ${valorFaturamento}=    FakerLibrary.Random Number    digits=7
    ${valorCapitalSocial}=    FakerLibrary.Random Number    digits=7
    ${valorCapitalSubscrito}=    FakerLibrary.Random Number    digits=7
    ${valorCapitalIntegral}=    FakerLibrary.Random Number    digits=7

    SeleniumLibrary.Input Text    name=${complementoClienteJuridico.cnpj}    ${cnpj}  
    SeleniumLibrary.Input Text    name=${complementoClienteJuridico.numeroFuncionarios}    ${numeroFuncionarios}
    SeleniumLibrary.Input Text    name=${complementoClienteJuridico.dataFundacao}    ${dataFundacao}
    SeleniumLibrary.Press Keys    name=${complementoClienteJuridico.valorFaturamento}    ${valorFaturamento}
    SeleniumLibrary.Press Keys    name=${complementoClienteJuridico.valorCapitalSocial}    ${valorCapitalSocial}
    SeleniumLibrary.Press Keys    name=${complementoClienteJuridico.valorCapitalSubscrito}    ${valorCapitalSubscrito}
    SeleniumLibrary.Press Keys    name=${complementoClienteJuridico.valorCapitalIntegral}    ${valorCapitalIntegral}

Prrenche dados gerais de local cliente juridico
    [Documentation]    Irá preencher os dados gerais do local levando em consideração que este se trata de local de pessoa jurídica.

    ${logradouro}=    FakerLibrary.Street Name
    ${numero}=    FakerLibrary.Building Number
    ${bairro}=    FakerLibrary.bairro
    ${cep}=    FakerLibrary.Postcode
    ${estado}=    FakerLibrary.State
    ${uf}    Convert To Upper Case    ${estado}
    ${estadoFormat}=    Evaluate    unidecode.unidecode('${uf}')
    ${limteCredito}=    FakerLibrary.Random Number    digits=6
    ${telefone}=    FakerLibrary.Cellphone Number
    ${telefoneFormat}    Remove String    ${telefone}    +55    (    )    -    ${telefone[0:1]}
    ${email}=    FakerLibrary.Email

    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.descricao}    ${logradouro}, ${numero} - ${bairro}
    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.logradouro}    ${logradouro}
    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.numero}    ${numero}
    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.bairro}    ${bairro}
    SeleniumLibrary.Input Text    name=${localGeralClienteJuridico.cep}    ${cep}
    SeleniumLibrary.Click Element    id=${localGeralClienteJuridico.uf}
    SeleniumLibrary.Click Element    xpath=//*[@id="${localGeralClienteJuridico.uf}"]/option[contains(text(),'${estadoFormat}')]
    
    ## Irá capturar a quantidade de opções no combo de cidade após informado o estado, e sorteará um index aleatório, selecionado
    ## assim a cidade que se encontra presente naquele index
    Sleep    0.5s
    ${countCidades}    Get Element Count    xpath=//*[@id="${localGeralClienteJuridico.comboCidade}"]/option
    ${iCidade}=    Evaluate    random.sample(range(2, ${countCidades}-1), 1)    random
    SeleniumLibrary.Click Element    xpath=//*[@id="${localGeralClienteJuridico.comboCidade}"]/option[${iCidade[0]}]  
    ##

    SeleniumLibrary.Input Text    id=${localGeralClienteJuridico.limteCredito}    ${limteCredito} 
    SeleniumLibrary.Input Text    id=${localGeralClienteJuridico.telefone}    ${telefoneFormat}
    SeleniumLibrary.Input Text    id=${localGeralClienteJuridico.email}    ${email}

Preenche dados complementares do local
    [Documentation]    Irá preencher os dados complementares do local.

    ${coutTipoLocal}    Get Element Count    xpath=//*[@id="${localComplemento.tipoLocal}"]/option
    IF  ${coutTipoLocal} > 2
        ${tipoLocal}=    Evaluate    random.sample(range(2, ${coutTipoLocal}-1), 1)    random   
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.tipoLocal}"]/option[${tipoLocal[0]}] 
    END

    ${coutTipologia}    Get Element Count    xpath=//*[@id="${localComplemento.tipologia}"]/option
    IF  ${coutTipologia} > 2
        ${tipologia}=    Evaluate    random.sample(range(2, ${coutTipologia}-1), 1)    random   
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.tipologia}"]/option[${tipologia[0]}] 
    END
    
    ${CountRegiao}    Get Element Count    xpath=//*[@id="${localComplemento.regiao}"]/option
    ${regiao}=    Evaluate    random.sample(range(2, ${CountRegiao}-1), 1)    random
    SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.regiao}"]/option[${regiao[0]}]  

    ${coutSegmento}    Get Element Count    xpath=//*[@id="${localComplemento.segmento}"]/option
    IF  ${coutSegmento} > 2
        ${segmento}=    Evaluate    random.sample(range(2, ${coutSegmento}-1), 1)    random   
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.segmento}"]/option[${segmento[0]}] 
    END

    ${coutTabelaPreco}    Get Element Count    xpath=//*[@id="${localComplemento.tabelaPreco}"]/option
    IF  ${coutTabelaPreco} > 2
        ${tabelaPreco}=    Evaluate    random.sample(range(2, ${coutTabelaPreco}-1), 1)    random   
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.tabelaPreco}"]/option[${tabelaPreco[0]}] 
    END

    ${coutCondicaoPagamento}    Get Element Count    xpath=//*[@id="${localComplemento.condicaoPagamento}"]/option
    IF  ${coutCondicaoPagamento} > 2
        ${condicaoPagamento}=    Evaluate    random.sample(range(2, ${coutCondicaoPagamento}-1), 1)    random   
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.condicaoPagamento}"]/option[${condicaoPagamento[0]}] 
    END

    ${coutTipoCobranca}    Get Element Count    xpath=//*[@id="${localComplemento.tipoCobranca}"]/option
    IF  ${coutTipoCobranca} > 2
        ${tipoCobranca}=    Evaluate    random.sample(range(2, ${coutTipoCobranca}-1), 1)    random   
        SeleniumLibrary.Click Element    xpath=//*[@id="${localComplemento.tipoCobranca}"]/option[${tipoCobranca[0]}] 
    END

    SeleniumLibrary.Input Text    ${localComplemento.observacao}    Cliente cadastrado por meio de teste automatizado.

Grava cadastro de cliente
    [Documentation]    Irá gravar as informações do cadastro de cliente.
    SeleniumLibrary.Click Element    id=${btnGravarCadastro}

    SeleniumLibrary.Wait Until Element Is Visible    id=${cadastroBemSucedido}
    SeleniumLibrary.Element Should Contain    id=${cadastroBemSucedido}    ${msgCadastroBemSucedido}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${popUpAcoes.popUp}    10s
    SeleniumLibrary.Capture Page Screenshot

Valida cliente listagem 
    [Documentation]    Irá validar se o cliente cadastrado está sendo exibido na listagem de clientes.

    SeleniumLibrary.Click Element    xpath=${popUpAcoes.listaClientes}   
    SeleniumLibrary.Wait Until Page Contains Element    xpath=${tituloPaginaListagemCliente}    10s
    Filtra cliente especifico    ${nome}    ${matricula}