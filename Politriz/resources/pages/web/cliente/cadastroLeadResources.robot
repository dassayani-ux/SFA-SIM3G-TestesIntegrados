*** Settings ***
Documentation    Arquivo utilizado para escrever as keywords utilizadas no processo de cadastro de um Lead.

Library     SeleniumLibrary
Library     FakerLibrary    locale=pt_BR
Library     String
Library     Screenshot
Library     SikuliLibrary

Resource    ${EXECDIR}/resources/locators/web/lead/cadastroLeadLocators.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/login/loginResources.robot
Resource    ${EXECDIR}/resources/variables/web/lead/listaInscricoesEstaduais.robot
Resource    ${EXECDIR}/resources/pages/web/login/loginResources.robot
Resource    ${EXECDIR}/resources/pages/web/menu/menuLateral.robot


*** Keywords ***

Cadastrar inscricoes estaduais de todos os estados-LEAD POLITRIZ
    [Documentation]        cadastro de pessoa juridica na tela de lead 

    FOR  ${i}  IN  @{inscricoes}
        Abre navegador
        Realiza login na plataforma web    
        Iniciar um novo lead quando menu recolhido
        Cadastrar informações de contato lead
        Cadastrar informações de local lead      ${i['estado']}    ${i['cidade']}
        Cadastrar inscrição estadual        ${i['inscricao']}
        Cadastrar complemento local
        Gravar cadastro lead
        
    END


Cadastrar informações de contato lead
    [Documentation]    keyword responsável por preencher uma parte dos campos de identificação do lead (nome, cnpj, contato) de pessoa juridica
    ${nomeFake}    FakerLibrary.Name
    Press Keys    id=${cabecalho.razaoSocial}    ${nomeFake}

    Click Element   id=${cabecalho.nomeFantasia}
    Press Keys    id=${cabecalho.nomeFantasia}   ${nomeFake}

    ${cnpjFake}    FakerLibrary.cnpj
    Press Keys      id=${cabecalho.cnpj}       ${cnpjFake}

    SeleniumLibrary.Click Element    xpath=${cabecalho.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${dialogProfissional.titleDialog}       timeout=10s
    Wait Until Element Is Visible    xpath=${cabecalho.profissional}
    SeleniumLibrary.Click Element    xpath=${cabecalho.profissional}
    SeleniumLibrary.Click Element    id=${dialogProfissional.btnConfirmar}


    Wait Until Element Is Enabled    id=${cabecalho.contato}
    ${contatoFake}    FakerLibrary.Name
    Press Keys      id=${cabecalho.contato}       ${contatoFake}

    Wait Until Element Is Enabled    id=${cabecalho.telefone}
    ${telefoneFake}    FakerLibrary.Random Int     min=1000000000000     max=9000000000000
    Press Keys      id=${cabecalho.telefone}       ${telefoneFake}

    Wait Until Element Is Enabled    id=${cabecalho.email}
    ${emailFake}    FakerLibrary.Email
    Press Keys      id=${cabecalho.email}       ${emailFake}

    Wait Until Element Is Enabled    id=${cabecalho.responsavel}
    ${responsavelFake}    FakerLibrary.Name
    Press Keys      id=${cabecalho.responsavel}       ${responsavelFake}
    


Cadastrar informações de local lead
    [Documentation]    irá preencher as informações de local do lead 
    [Arguments]    ${ESTADO}=GO    ${LOCAL_CIDADE}=ADELANDIA

    Scroll Element Into View       id=${local.inscEstadual} 
    # País
    Click Element    xpath=${local.comboBoxPais}
    Wait Until Page Contains    BRASIL
    Click Element     xpath=${local.opcaoBrasil}
    

    # Estado
    Wait Until Element Is Visible    xpath=${local.comboBoxEstado}
    Click Element       xpath=${local.comboBoxEstado}
    ${elementoFormatado}       Format String       ${UF}      state=${ESTADO}      
    Wait Until Element Is Visible    ${elementoFormatado}
    Click Element       ${elementoFormatado} 
    

    # Cidade
    Click Element      xpath=${local.labelCidade}     #Utilizado para remover o foco do combobox de cidade
    Click Element      xpath=${local.comboBoxCidade}
    ${CIDADE_EM_MAIUSCULO}=    Convert To Upper Case      ${LOCAL_CIDADE}
    ${cidadeFormat}=    Evaluate    unidecode.unidecode('${CIDADE_EM_MAIUSCULO}')
    ${elementoFormatadoCidade}       Format String       ${OPTION_CIDADE}      city=${cidadeFormat}  
    Click Element       ${elementoFormatadoCidade} 
    

    Click Element      xpath=${local.labelLogradouro}    #Utilizado para remover o foco do combobox de cidade
    Press Keys      id=${local.logradouro}      TESTE ROBOT
    Press Keys      id=${local.numero}      3000
    Press Keys      id=${local.descricao}     TESTE COMPLEMENTO 


Cadastrar inscrição estadual 
    [Documentation]        irá preencher somente o campo de inscrição estadual
    [Arguments]      ${INSCRICAO}=0121754832766
    Wait Until Element Is Visible    id=${local.inscEstadual}     timeout=30s
    Press Keys      id=${local.inscEstadual}    ${INSCRICAO}


Cadastrar complemento local
    [Documentation]      preenche os campos da aba Informações adicionais do cadastro de lead  
    Wait Until Element Is Enabled    xpath=${complementoLead.bairro}
    Press Keys      xpath=${complementoLead.bairro}      BAIRRO TESTE
    Wait Until Element Is Enabled    xpath=${complementoLead.cep}
    Press Keys     xpath=${complementoLead.cep}       85825-000
    Wait Until Element Is Enabled    xpath=${complementoLead.segmento}
    # Segmento
    Click Element   xpath=${complementoLead.segmento}
    Press Keys     xpath=${complementoLead.segmento}      ARROW_DOWN
    Wait Until Element Is Enabled       xpath=${complementoLead.valorPrevisto}
    Press keys     xpath=${complementoLead.valorPrevisto}        1500



Gravar cadastro lead
    [Documentation]        irá clicar no botão gravar e validar se aparece a mensagem: Gravado com sucesso!
    Click Element   id=${btnGravar}
    Wait Until Element Is Visible    xpath=${mensagem}        30s
    Run Keyword And Continue On Failure       Element Should Contain      xpath=${mensagem}      Gravado com sucesso!
    Run Keyword And Continue On Failure    Capture Page Screenshot
