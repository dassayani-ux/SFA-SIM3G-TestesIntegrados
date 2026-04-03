*** Settings ***
Documentation    Arquivo Resource FULL FIELD (400+ linhas).
...              Contém: Injeção de Massa, PF Completo (Cônjuge/Renda), PJ Completo e Local.

Resource    ${EXECDIR}/pedidoengine/resources/lib/web/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/cliente/listagemClientesResource.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/cliente/cadastroCLienteLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/variables/web/cliente/cadastroClienteVariables.robot
Resource    ${EXECDIR}/pedidoengine/resources/variables/web/cliente/listaInscricoesEstaduais.robot

Library     FakerLibrary    locale=pt_BR
Library     String

*** Variables ***
${nome}
${matricula}

*** Keywords ***
# ==============================================================================
# SETUP E BANCO DE DADOS (MASSA COMPLETA CYPRESS)
# ==============================================================================

Configura parametros padroes do sistema
    [Documentation]    Injeta toda a massa necessária para os combos e campos obrigatórios.
    Log To Console     \n⚙️ Injetando Massa de Dados no Postgres...
    ${query}=    Catenate    SEPARATOR=\n
    ...    BEGIN;
    ...    UPDATE wsconfigentidade SET idnpermitevisualizar = 1, idnpermiteeditar = 1, idnpermitecadastrar = 1;
    ...    UPDATE wsconfigentidadecampo SET idnobrigatorio = 0;
    ...    UPDATE wsconfigentidadecampo SET idnobrigatorio = 1 WHERE labelcampo IN ('tipocliente', 'descricao', 'cidade', 'nome', 'parceiro', 'idnativo', 'profissional', 'sgltipopessoa', 'telefone', 'email', 'razaosocial', 'idnpessoafisica', 'cpf', 'login', 'perfilacesso', 'idnpadrao', 'datainicio', 'logradouro', 'nomeparceiro', 'numero', 'cnpj', 'nomeparceirofantasia');
    ...    -- MASSA PARA COMBOS (RESTORED)
    ...    INSERT INTO classificacaoparceiro (idclassificacaoparceiro, idnativo, percentualdesconto, descricao, sglclassificacao, ordem, codigoerp, wsversao) SELECT 99999, 1, 0, 'CLASSIFICACAO AUTOMACAO', 'AUTO', 1, 'CT#AUTO', 1 WHERE NOT EXISTS (SELECT 1 FROM classificacaoparceiro WHERE idclassificacaoparceiro = 99999);
    ...    INSERT INTO grupoparceiro (idgrupoparceiro, idnativo, descricao, codigoerp, wsversao, sglgrupoparceiro) SELECT 99999, 1, 'GRUPO AUTOMACAO', 'CT#AUTO', 1, 'AUTO' WHERE NOT EXISTS (SELECT 1 FROM grupoparceiro WHERE idgrupoparceiro = 99999);
    ...    INSERT INTO tipologia (idtipologia, idnativo, descricao, codigo, sgltipologia, codigoerp, wsversao) SELECT 99999, 1, 'TIPOLOGIA AUTOMACAO', 'AUTO', 'AUT', 'CT#AUTO', 1 WHERE NOT EXISTS (SELECT 1 FROM tipologia WHERE idtipologia = 99999);
    ...    INSERT INTO regiao (idregiao, descricao, codigo, idnativo, codigoerp, wsversao) SELECT 99999, 'REGIAO AUTOMACAO', 'AUTO', 1, 'CT#AUTO', 1 WHERE NOT EXISTS (SELECT 1 FROM regiao WHERE idregiao = 99999);
    ...    INSERT INTO segmento (idsegmento, descricao, idnativo, codigo, sigla, idnconsomecotasupervisor, codigoerp, wsversao) SELECT 99999, 'SEGMENTO AUTOMACAO', 1, 'AUTO', 'AUT', 0, 'CT#AUTO', 1 WHERE NOT EXISTS (SELECT 1 FROM segmento WHERE idsegmento = 99999);
    ...    COMMIT;
    DatabaseLibrary.Execute Sql String    ${query}
    Log To Console     ✅ Banco preparado!

Valida cliente no banco de dados
    Log To Console     \nValidando cliente: ${nome}
    ${res}=    DatabaseLibrary.Query    SELECT idparceiro FROM parceiro WHERE nomeparceiro = '${nome}'
    Should Not Be Empty    ${res}    msg=❌ Cliente não encontrado!

# ==============================================================================
# NAVEGAÇÃO (ESTRUTURA ORIGINAL)
# ==============================================================================

Acessa tela de cadastro de cliente
    Wait Until Element Is Not Visible    class=minimalist-loading-background    30s
    Click Element    id=${cliente.menuCliente}
    Wait Until Element Is Visible    id=${cliente.subMenuCliente}    15s
    Click Element    id=${cliente.subMenuCliente}
    Wait Until Element Is Visible    id=${cliente.novoCliente}       15s
    Click Element    id=${cliente.novoCliente}
    Wait Until Page Contains Element    xpath=${tituloPaginaCadastroCLiente}    20s

# ==============================================================================
# PESSOA JURÍDICA (FULL FIELDS)
# ==============================================================================

Cadastra cliente juridico
    Preenche dados gerais pessoa juridica
    Preenche dados de complemento pessoa juridica
    Preenche dados gerais de local
    Preenche dados complementares do local
    Grava cadastro de cliente
    Entra em modo de edicao apos salvar
    Adiciona contato ao cliente

Preenche dados gerais pessoa juridica
    ${idRand}=    Evaluate    int(time.time() * 1000)
    Set Test Variable    ${nome}    Cliente Auto PJ ${idRand}
    
    Click Forcado JS    xpath=${geralCliente.pessoajuridica}
    Input Text    name=${geralCliente.nomeCliente}           ${nome}
    Input Text    name=${geralCliente.fantasiaCliente}       ${nome}
    Input Text    name=${geralCliente.numeroMatricula}       ${idRand}
    Input Text    name=parceiro_homepage                     www.automacao.com.br
    
    Click Element           xpath=${tituloPaginaCadastroCLiente}
    
    # Ajuste: Fazendo o scroll diretamente no botão da lupa que é visível
    ${lupa_atividade}=    Set Variable    xpath=(//*[@name='pessoajuridica_atividadeseconomica']/..//*[contains(@class, 'ui-button') or contains(@class, 'icon-search')])[1]
    Scroll Para Elemento    ${lupa_atividade}
    
    Selecionar Lupa Padrao Cypress    pessoajuridica_atividadeseconomica
    Selecionar Lupa Padrao Cypress    parceiro_grupoparceiro
    Selecionar primeira opcao valida do select    parceiro_classificacaoparceiro

Preenche dados de complemento pessoa juridica
    ${cnpj}=    FakerLibrary.Cnpj
    ${cnpj_limpo}=    Remove String    ${cnpj}    .    -    /
    Scroll Para Elemento    name=pessoajuridica_documentoidentificacao
    Input Text    name=pessoajuridica_documentoidentificacao    ${cnpj_limpo}
    
    # Isento
    Click Forcado JS    xpath=//label[contains(text(),'Isento')]
    
    # Valores Financeiros (Aleatórios Cypress)
    ${faturamento}=    Evaluate    random.randint(10000, 900000)    random
    Input Text    name=pessoajuridica_datafundacao    15/05/2015
    Input Text    name=pessoajuridica_valorfaturamento    ${faturamento}
    Input Text    name=pessoajuridica_valorcapitalsocial    500000
    Input Text    name=pessoajuridica_valorcapitalsubscrito    500000
    Input Text    name=pessoajuridica_valorcapitalintegral     500000

# ==============================================================================
# PESSOA FÍSICA (FULL FIELDS + CÔNJUGE)
# ==============================================================================

Cadastra cliente fisico
    Preenche dados gerais pessoa fisica
    Preenche dados gerais de local
    Preenche dados complementares do local
    Grava cadastro de cliente
    Entra em modo de edicao apos salvar
    Adiciona contato ao cliente

Preenche dados gerais pessoa fisica
    ${idRand}=    Evaluate    int(time.time() * 1000)
    Set Test Variable    ${nome}    Cliente Auto PF ${idRand}
    ${cpf}=    FakerLibrary.Cpf
    ${cpf_limpo}=    Remove String    ${cpf}    .    -
    
    Click Forcado JS    xpath=${geralCliente.pessoaFisica}
    Input Text    name=${geralCliente.nomeCliente}    ${nome}
    
    Scroll Para Elemento    name=pessoafisica_documentoidentificacao
    Input Text    name=pessoafisica_documentoidentificacao    ${cpf_limpo}
    Input Text    name=pessoafisica_datanascimento    15/08/1990
    Input Text    name=pessoafisica_nomemae    Maria da Silva Cypress
    Input Text    name=pessoafisica_profissao    Analista de Qualidade
    Input Text    name=pessoafisica_rendamensal    850000
    
    # Dados Cônjuge
    ${cpfConj}=    FakerLibrary.Cpf
    ${cpfConj_limpo}=    Remove String    ${cpfConj}    .    -
    Scroll Para Elemento    name=conjuge_nome
    Input Text    name=conjuge_nome    Esposa Automação
    Input Text    name=conjuge_documentoidentificacao    ${cpfConj_limpo}
    Input Text    name=conjuge_anonascimento    1992

# ==============================================================================
# ENDEREÇO E LOCAL (PAINEL DIREITO)
# ==============================================================================

Preenche dados gerais de local
    Scroll Para Elemento    name=local_descricao
    Input Text    name=local_descricao    LOCAL PRINCIPAL
    Input Text    name=local_logradouro   Avenida Brasil
    Input Text    name=local_numero       123
    Input Text    name=local_bairro       Centro
    Input Text    name=local_cep          85812000
    
    Select From List By Label    name=local_unidadefederativa    PARANA
    Wait Until Element Is Not Visible    xpath=${msgCarregando}  10s
    
    # Ajuste: Agora garantimos que o sistema carregou as cidades antes de interagir
    Wait Until Page Contains Element     xpath=//select[@name='local_cidade']/option[contains(text(), 'CASCAVEL')]    15s
    Select From List By Label            name=local_cidade               CASCAVEL (PR)
    Wait Until Element Is Not Visible    xpath=${msgCarregando}  10s
    
    Scroll Para Elemento    xpath=//input[@name='local_idnisentoie']/..//label
    Click Forcado JS        xpath=//input[@name='local_idnisentoie']/..//label
    Input Text              name=local_telefone    45999998888

Preenche dados complementares do local
    Scroll Para Elemento    id=cmbTipoLocal
    Select From List By Label    id=cmbTipoLocal    PRINCIPAL
    Selecionar primeira opcao valida do select    local_tipologia
    Selecionar primeira opcao valida do select    local_regiao
    Selecionar primeira opcao valida do select    local_segmento
    
    Scroll Para Elemento    id=local_precobase
    Input Text    id=local_precobase    150.00
    Input Text    name=local_observacao    Cadastro full via automacao.

# ==============================================================================
# CONTATOS (POPUP)
# ==============================================================================

Adiciona contato ao cliente
    Scroll Para Elemento    id=btnContato
    Click Forcado JS        id=btnContato
    Wait Until Element Is Visible    id=grid-button-adicionar    20s
    Click Forcado JS                 id=grid-button-adicionar
    
    Wait Until Element Is Visible    name=contatopessoa_nome    15s
    Input Text      name=contatopessoa_nome        Contato Automacao
    Input Text      name=contatopessoa_telefone    45988887777
    
    Click Forcado JS    xpath=(//*[@id="btnGravar"])[last()]
    Wait Until Element Is Not Visible    class=jGrowl-message    15s
    
    # Seleção Grid
    Wait Until Page Contains Element    xpath=(//div[contains(@class, 'slick-cell l0')])[1]    15s
    Click Forcado JS    xpath=(//div[contains(@class, 'slick-cell l0')])[1]
    Click Forcado JS    xpath=(//*[@id="btnVoltar"])[last()]
    
    # Salva Principal
    Click Forcado JS    id=${btnGravarCadastro}
    Wait Until Element Is Visible    xpath=${popUpAcoes.popUp}    15s
    Go To    ${aplicacao_web.urlWeb}

# ==============================================================================
# KEYWORDS DE APOIO (JS E SCROLL)
# ==============================================================================

Scroll Para Elemento
    [Arguments]    ${locator}
    Wait Until Page Contains Element    ${locator}    15s
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].scrollIntoView({block: "center"});    ARGUMENTS    ${element}
    Sleep    0.3s

Click Forcado JS
    [Arguments]    ${locator}
    Wait Until Page Contains Element    ${locator}    15s
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${element}

Selecionar Lupa Padrao Cypress
    [Arguments]    ${nome_input}
    ${lupa}=    Set Variable    xpath=(//*[@name='${nome_input}']/..//*[contains(@class, 'ui-button') or contains(@class, 'icon-search')])[1]
    Click Forcado JS    ${lupa}
    Wait Until Element Is Visible    css=.slick-cell    15s
    Click Forcado JS    css=.slick-cell
    Click Forcado JS    id=btnConfirmar
    Sleep    0.5s

Selecionar primeira opcao valida do select
    [Arguments]    ${nome_select}
    ${count}=    Get Element Count    xpath=//select[@name='${nome_select}']/option
    IF  ${count} > 1
        Select From List By Index    name=${nome_select}    1
    END

Grava cadastro de cliente
    Click Forcado JS    id=${btnGravarCadastro}
    Wait Until Element Is Visible    xpath=${popUpAcoes.popUp}    25s

Entra em modo de edicao apos salvar
    Click Forcado JS    css=#popup0 a:nth-child(1)
    Wait Until Element Is Not Visible    css=.minimalist-popup-background    15s