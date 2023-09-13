*** Settings ***
Library     SeleniumLibrary
Library     FakerLibrary    locale=pt_BR
Library     String
Library     Screenshot
Library     SikuliLibrary

Resource    ${EXECDIR}/resources/locators/web/lead/cadastroLeadLocators.robot
Resource    ${EXECDIR}/resources/pages/web/navegador/navegadorResources.robot
Resource    ${EXECDIR}/resources/pages/web/login/loginResources.robot
Resource    ${EXECDIR}/resources/data/cliente/listaInscricoesEstaduais.robot
Resource    ${EXECDIR}/resources/pages/web/login/loginResources.robot
Resource    ${EXECDIR}/resources/pages/web/menu/menuLateral.robot


*** Keywords ***

Teste de cadastro de inscricoes estaduais de todos os estados-LEAD POLITRIZ

    @{inscricoes}    Create List
    ...    ${rio_grande_do_sul}
    ...    ${acre}
    ...    ${alagoas}
    ...    ${amapa}
    ...    ${amazonas}
    ...    ${bahia}
    ...    ${ceara}
    ...    ${distrito_federal}
    ...    ${espirito_santo}
    ...    ${goias}
    ...    ${maranhao}
    ...    ${mato_grosso}
    ...    ${mato_grosso_do_sul}
    ...    ${minas_gerais}
    ...    ${para}
    ...    ${paraiba}
    ...    ${parana}
    ...    ${pernambuco}
    ...    ${piaui}
    ...    ${rio_de_janeiro}
    ...    ${rio_grande_do_norte}
    ...    ${rondonia}
    ...    ${roraima}
    ...    ${santa_catarina}
    ...    ${sao_paulo}
    ...    ${sergipe}
    ...    ${tocantins}
    
    
    FOR  ${i}  IN  @{inscricoes}
        Abre navegador
        Realiza login na plataforma web    
        Iniciar um novo lead quando menu recolhido
        cadastro lead cabeçalho
        cadastro lead local                    ${i['estado']}    ${i['cidade']}
        cadastro lead documentos de identificação    ${i['inscricao']}
        cadastro lead complemento local
        gravar cadastro lead
        
    END


cadastro lead cabeçalho
    ${NOME FAKE}    FakerLibrary.Name
    Press Keys    id=${cabecalho.razaoSocial}    ${NOME FAKE}

    Click Element   id=${cabecalho.nomeFantasia}
    Press Keys    id=${cabecalho.nomeFantasia}   ${NOME FAKE}

    ${CNPJ FAKE}    FakerLibrary.cnpj
    Press Keys      id=${cabecalho.cnpj}       ${CNPJ FAKE}

    SeleniumLibrary.Click Element    xpath=${cabecalho.btnPesquisar}
    SeleniumLibrary.Wait Until Element Is Visible    xpath=${dialogProfissional.titleDialog}       timeout=10s
    Wait Until Element Is Visible    xpath=${cabecalho.profissional}
    SeleniumLibrary.Click Element    xpath=${cabecalho.profissional}
    SeleniumLibrary.Click Element    id=${dialogProfissional.btnConfirmar}


    Wait Until Element Is Enabled    id=${cabecalho.contato}
    ${CONTATO FAKE}    FakerLibrary.Name
    Press Keys      id=${cabecalho.contato}       ${CONTATO FAKE}

    Wait Until Element Is Enabled    id=${cabecalho.telefone}
    ${TELEFONE FAKE}    FakerLibrary.Random Int     min=1000000000000     max=9000000000000
    Press Keys      id=${cabecalho.telefone}       ${TELEFONE FAKE}

    Wait Until Element Is Enabled    id=${cabecalho.email}
    ${EMAIL FAKE}    FakerLibrary.Email
    Press Keys      id=${cabecalho.email}       ${EMAIL FAKE}

    Wait Until Element Is Enabled    id=${cabecalho.responsavel}
    ${RESPONSAVEL FAKE}    FakerLibrary.Name
    Press Keys      id=${cabecalho.responsavel}       ${RESPONSAVEL FAKE}
    


cadastro lead local
    [Arguments]    ${ESTADO}=GO    ${LOCAL_CIDADE}=ADELANDIA

    Scroll Element Into View       id=${local.inscEstadual} 
    # País
    Click Element    xpath=${local.comboBoxPais}
    Wait Until Page Contains    BRASIL
    Click Element     xpath=${local.opcaoBrasil}
    

    # Estado
    Wait Until Element Is Visible    xpath=${local.comboBoxEstado}
    Click Element       xpath=${local.comboBoxEstado}
    ${ELEMENTO_FORMATADO}       Format String       ${UF}      state=${ESTADO}      
    Wait Until Element Is Visible    ${ELEMENTO_FORMATADO}
    Press keys    xpath=${local.inputEstado}     ${ESTADO}    
    Click Element       ${ELEMENTO_FORMATADO} 


    # Cidade
    Wait Until Element Is Visible    xpath=${local.comboBoxCidade}    timeout=25s
    Click Element      xpath=${local.comboBoxCidade}
    ${CIDADE_EM_MAIUSCULO}=    Convert To Upper Case      ${LOCAL_CIDADE}
    ${cidadeFormat}=    Evaluate    unidecode.unidecode('${CIDADE_EM_MAIUSCULO}')
    ${ELEMENTO_FORMATADO_CIDADE}       Format String       ${CIDADE2}      city=${cidadeFormat}  
    log     ${ELEMENTO_FORMATADO_CIDADE}
    Press Keys        xpath=${local.inputCidade}       ${cidadeFormat}  
    Click Element       ${ELEMENTO_FORMATADO_CIDADE} 
    

    Wait Until Element Is Enabled    id=${local.logradouro}    timeout=25s
    Click Element      xpath=${local.labelLogradouro}
    Press Keys      id=${local.logradouro}      TESTE ROBOT
    Press Keys      id=${local.numero}      3000
    Press Keys      id=${local.descricao}     TESTE COMPLEMENTO 



cadastro lead documentos de identificação
    [Arguments]      ${INSCRICAO}=0121754832766
    Wait Until Element Is Visible    id=${local.inscEstadual}     timeout=30s
    Press Keys      id=${local.inscEstadual}    ${INSCRICAO}


cadastro lead complemento local

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




gravar cadastro lead
    Click Element   id=${btnGravar}
    Wait Until Element Is Visible    xpath=${mensagem}        30s
    Run Keyword And Continue On Failure       Element Should Contain      xpath=${mensagem}      Gravado com sucesso!
    Run Keyword And Continue On Failure    Capture Page Screenshot
