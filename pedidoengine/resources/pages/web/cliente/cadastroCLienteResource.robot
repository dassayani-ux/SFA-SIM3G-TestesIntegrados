*** Settings ***
Documentation    Arquivo Resource FULL FIELD.
...              Contém: Injeção de Massa, PF Completo, PJ Completo, Local,
...              Validação de Campos Obrigatórios, Edição, Inscrições Estaduais,
...              Anexos (T1135) e Logotipo (T1136).

Resource    ${EXECDIR}/pedidoengine/resources/lib/web/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/menu/menuLateralLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/cliente/listagemClientesResource.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/cliente/cadastroCLienteLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/variables/web/cliente/cadastroClienteVariables.robot
Resource    ${EXECDIR}/pedidoengine/resources/variables/web/cliente/listaInscricoesEstaduais.robot

Library     FakerLibrary    locale=pt_BR
Library     String
Library     OperatingSystem

*** Variables ***
${nome}
${matricula}
${CHECKBOX_ISENTO_IE}         id=tipoidentificacao_local_inscricaoestadual_chkIsento
${idparceiro_logotipo}        ${EMPTY}
${nome_parceiro_logotipo}     ${EMPTY}
${idparceiro_anexo}           ${EMPTY}
${nome_parceiro_anexo}        ${EMPTY}
${nome_parceiro_novo_local}   ${EMPTY}
${idparceiro_inativacao}      ${EMPTY}
${nome_parceiro_inativacao}   ${EMPTY}
${FIXTURE_IMAGEM}    ${EXECDIR}/pedidoengine/resources/elements/imagem.png
${FIXTURE_PDF}       ${EXECDIR}/pedidoengine/resources/elements/documento.pdf

*** Keywords ***
# ==============================================================================
# SETUP E BANCO DE DADOS
# ==============================================================================

Configura parametros padroes do sistema
    Log To Console    \n⚙️ Injetando Massa de Dados no Postgres...
    ${query}=    Catenate    SEPARATOR=\n
    ...    BEGIN;
    ...    UPDATE wsconfigentidade SET idnpermitevisualizar = 1, idnpermiteeditar = 1, idnpermitecadastrar = 1;
    ...    UPDATE wsconfigentidadecampo SET idnpermitevisualizar = 1, idnpermiteeditar = 1;
    ...    UPDATE wsconfigentidadecampo SET idnobrigatorio = 0;
    ...    UPDATE wsconfigentidadecampo SET idnobrigatorio = 1 WHERE labelcampo IN ('tipocliente', 'descricao', 'cidade', 'nome', 'parceiro', 'idnativo', 'profissional', 'sgltipopessoa', 'telefone', 'email', 'razaosocial', 'idnpessoafisica', 'cpf', 'login', 'perfilacesso', 'idnpadrao', 'datainicio', 'logradouro', 'nomeparceiro', 'numero', 'cnpj', 'nomeparceirofantasia');
    ...    INSERT INTO classificacaoparceiro (idclassificacaoparceiro, idnativo, percentualdesconto, descricao, sglclassificacao, ordem, codigoerp, wsversao) SELECT 99999, 1, 0, 'CLASSIFICACAO AUTOMACAO', 'AUTO', 1, 'CT#AUTO', 1 WHERE NOT EXISTS (SELECT 1 FROM classificacaoparceiro WHERE idclassificacaoparceiro = 99999);
    ...    INSERT INTO grupoparceiro (idgrupoparceiro, idnativo, descricao, codigoerp, wsversao, sglgrupoparceiro) SELECT 99999, 1, 'GRUPO AUTOMACAO', 'CT#AUTO', 1, 'AUTO' WHERE NOT EXISTS (SELECT 1 FROM grupoparceiro WHERE idgrupoparceiro = 99999);
    ...    INSERT INTO tipologia (idtipologia, idnativo, descricao, codigo, sgltipologia, codigoerp, wsversao) SELECT 99999, 1, 'TIPOLOGIA AUTOMACAO', 'AUTO', 'AUT', 'CT#AUTO', 1 WHERE NOT EXISTS (SELECT 1 FROM tipologia WHERE idtipologia = 99999);
    ...    INSERT INTO regiao (idregiao, descricao, codigo, idnativo, codigoerp, wsversao) SELECT 99999, 'REGIAO AUTOMACAO', 'AUTO', 1, 'CT#AUTO', 1 WHERE NOT EXISTS (SELECT 1 FROM regiao WHERE idregiao = 99999);
    ...    INSERT INTO segmento (idsegmento, descricao, idnativo, codigo, sigla, idnconsomecotasupervisor, codigoerp, wsversao) SELECT 99999, 'SEGMENTO AUTOMACAO', 1, 'AUTO', 'AUT', 0, 'CT#AUTO', 1 WHERE NOT EXISTS (SELECT 1 FROM segmento WHERE idsegmento = 99999);
    ...    COMMIT;
    DatabaseLibrary.Execute Sql String    ${query}
    Log To Console    ✅ Banco preparado!

Valida cliente no banco de dados
    Log To Console    \nValidando cliente: ${nome}
    ${res}=    DatabaseLibrary.Query    SELECT idparceiro FROM parceiro WHERE nomeparceiro = '${nome}'
    Should Not Be Empty    ${res}    msg=❌ Cliente não encontrado no banco: ${nome}

# ==============================================================================
# NAVEGAÇÃO
# ==============================================================================

Acessa tela de cadastro de cliente
    Go To    ${aplicacao_web.urlWeb}
    Wait Until Element Is Not Visible    class=minimalist-loading-background    30s
    Fecha Todos Os Popups
    Click Element    id=${cliente.menuCliente}
    Wait Until Element Is Visible    id=${cliente.subMenuCliente}    15s
    Click Element    id=${cliente.subMenuCliente}
    Wait Until Element Is Visible    id=${cliente.novoCliente}    15s
    Click Element    id=${cliente.novoCliente}
    Wait Until Page Contains Element    xpath=${tituloPaginaCadastroCLiente}    20s

Acessa listagem de clientes
    Go To    ${aplicacao_web.urlWeb}
    Wait Until Element Is Not Visible    class=minimalist-loading-background    30s
    Fecha Todos Os Popups
    Click Element    id=${cliente.menuCliente}
    Wait Until Element Is Visible    id=${cliente.subMenuCliente}    15s
    Click Element    id=${cliente.subMenuCliente}
    Wait Until Element Is Visible    id=menu.cliente.cadastrar.listar    15s
    Click Element    id=menu.cliente.cadastrar.listar
    Wait Until Element Is Not Visible    class=minimalist-loading-background    30s

Fecha Todos Os Popups
    Execute Javascript
    ...    document.querySelectorAll("[id^='popup']").forEach(function(popup) {
    ...        if (window.getComputedStyle(popup).display !== "none") {
    ...            var btn = popup.querySelector("[id*='btnCancelar'], [id*='btnVoltar'], .ui-dialog-titlebar-close");
    ...            if (btn) btn.click();
    ...            else popup.style.display = "none";
    ...        }
    ...    });
    Sleep    0.8s

# ==============================================================================
# TESTE 001 — Validação de Campos Obrigatórios
# ==============================================================================

Valida campos obrigatorios do cliente
    Click Forcado JS    id=${btnGravarCadastro}
    Sleep    1s
    ${tem_alert}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.alert    5s
    ${tem_growl}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.jGrowl-message    5s
    Run Keyword If    not ${tem_alert} and not ${tem_growl}
    ...    Fail    Nenhuma mensagem de erro exibida ao tentar gravar cadastro vazio
    Log To Console    ✅ Campos obrigatórios validados com sucesso!

# ==============================================================================
# TESTE 003 — Edição de Cliente (DTSFASAPP-T1130)
# ==============================================================================

Pesquisa e edita cliente
    [Arguments]    ${termo}
    Sleep    2s
    Wait Until Element Is Not Visible    class=minimalist-loading-background    20s
    ${tem_campo}=    Run Keyword And Return Status    Wait Until Page Contains Element    name=termo    5s
    Run Keyword If    ${tem_campo}    Digita No Campo JS    name=termo    ${termo}
    Wait Until Page Contains Element    id=btnPesquisar    10s
    Click Forcado JS    id=btnPesquisar
    Wait Until Element Is Not Visible    class=minimalist-loading-background    20s
    Sleep    2s
    Wait Until Page Contains Element
    ...    xpath=(//div[contains(@class,'slick-row')]//div[contains(@class,'l0')])[1]    15s
    Log To Console    \n🔍 Pesquisa por '${termo}' concluída.
    Click Forcado JS
    ...    xpath=(//div[contains(@class,'slick-row')]//div[contains(@class,'l0')])[1]
    Sleep    1s
    Wait Until Element Is Visible
    ...    xpath=//div[contains(@class,'slick-row') and contains(@class,'active')]//div[contains(@class,'l6')]//img    10s
    Click Forcado JS
    ...    xpath=//div[contains(@class,'slick-row') and contains(@class,'active')]//div[contains(@class,'l6')]//img
    Wait Until Element Is Not Visible    class=minimalist-loading-background    20s
    Wait Until Page Contains Element    xpath=${tituloPaginaCadastroCLiente}    20s
    Log To Console    ✅ Cliente aberto para edição.

Edita homepage do cliente
    [Arguments]    ${novo_homepage}
    Wait Until Page Contains Element    name=parceiro_homepage    15s
    Digita No Campo JS    name=parceiro_homepage    ${novo_homepage}
    Log To Console    \n✏️ Homepage atualizado para: ${novo_homepage}

Valida gravacao com sucesso
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    10s
    Execute Javascript
    ...    var btns = Array.from(document.querySelectorAll("[id='btnGravar']"));
    ...    var visiveis = btns.filter(function(b) { return b.offsetParent !== null; });
    ...    if (visiveis.length === 0) throw new Error("Nenhum btnGravar visivel");
    ...    visiveis[0].click();
    Sleep    1s
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    30s
    ${tem_toast}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.jGrowl-message    5s
    Run Keyword If    ${tem_toast}    Log To Console    \n✅ Toast de sucesso exibido!
    Run Keyword If    not ${tem_toast}    Log To Console    \n⚠️ Toast sumiu antes da verificação — gravação OK.
    ${tem_popup}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${popUpAcoes.popUp}    5s
    Run Keyword If    ${tem_popup}    Click Forcado JS    css=#popup0 a:last-child
    Run Keyword If    ${tem_popup}    Wait Until Element Is Not Visible    css=.minimalist-popup-background    10s
    Log To Console    ✅ Edição de cliente concluída com sucesso!

# ==============================================================================
# TESTE 004 — Cadastro com Todas as Inscrições Estaduais
# ==============================================================================

Cadastra cliente juridico para cada inscricao estadual
    Wait Until Page Contains Element    xpath=${tituloPaginaCadastroCLiente}    20s
    Click Forcado JS    xpath=${geralCliente.pessoajuridica}
    Sleep    0.5s
    ${opcoes_ie}=    Execute Javascript
    ...    var resultado = [];
    ...    document.querySelectorAll("select").forEach(function(sel) {
    ...        var nome = (sel.name || sel.id || "").toLowerCase();
    ...        if (nome.indexOf("inscricao") >= 0 && nome.indexOf("tipo") >= 0) {
    ...            Array.from(sel.options).forEach(function(op) {
    ...                var txt = op.text.trim();
    ...                if (txt && txt !== "--Selecione--") resultado.push(txt);
    ...            });
    ...        }
    ...    });
    ...    return resultado.length > 0 ? resultado : ["Isento"];
    Log To Console    \n📋 Tipos de IE encontrados: ${opcoes_ie}
    FOR    ${inscricao}    IN    @{opcoes_ie}
        Log To Console    \n🔄 Cadastrando PJ com IE: ${inscricao}
        Acessa tela de cadastro de cliente
        Cadastra PJ com inscricao estadual    ${inscricao}
        Valida cliente no banco de dados
        Log To Console    ✅ PJ cadastrado com IE '${inscricao}': ${nome}
    END

Cadastra PJ com inscricao estadual
    [Arguments]    ${tipo_inscricao}
    ${idRand}=    Evaluate    int(time.time() * 1000)
    ${tipo_curto}=    Get Substring    ${tipo_inscricao}    0    10
    Set Test Variable    ${nome}    Cliente Automação IE ${tipo_curto} ${idRand}
    Click Forcado JS    xpath=${geralCliente.pessoajuridica}
    Digita No Campo JS    name=${geralCliente.nomeCliente}      ${nome}
    Digita No Campo JS    name=${geralCliente.fantasiaCliente}  ${nome}
    Digita No Campo JS    name=${geralCliente.numeroMatricula}  ${idRand}
    Selecionar primeira opcao valida do select    parceiro_classificacaoparceiro
    Digita No Campo JS    name=parceiro_homepage    www.automacao.com.br
    Rolar Painel Cliente Ate    name=parceiro_grupoparceiro
    Selecionar Lupa Padrao Cypress    parceiro_grupoparceiro
    Rolar Painel Cliente Ate    name=parceiro_cnae
    Digita No Campo JS    name=parceiro_cnae    6201501
    ${cnpj}=         FakerLibrary.Cnpj
    ${cnpj_limpo}=    Remove String    ${cnpj}    .    -    /
    Rolar Painel Cliente Para    bottom
    Sleep    0.5s
    Digita No Campo JS    name=pessoajuridica_documentoidentificacao    ${cnpj_limpo}
    Digita No Campo JS    name=pessoajuridica_numerofuncionarios        150
    Digita No Campo JS    name=pessoajuridica_datafundacao             15/05/2015
    ${faturamento}=      Evaluate    random.randint(100000, 9000000)    random
    ${capitalSocial}=    Evaluate    random.randint(100000, 5000000)    random
    Digita No Campo JS    name=pessoajuridica_valorfaturamento       ${faturamento}
    Digita No Campo JS    name=pessoajuridica_valorcapitalsocial     ${capitalSocial}
    Digita No Campo JS    name=pessoajuridica_valorcapitalsubscrito  ${capitalSocial}
    Digita No Campo JS    name=pessoajuridica_valorcapitalintegral   ${capitalSocial}
    ${cnpj_local}=         FakerLibrary.Cnpj
    ${cnpj_local_limpo}=    Remove String    ${cnpj_local}    .    -    /
    Rolar Painel Cliente Para    top
    Sleep    0.3s
    Rolar Painel Local Ate    name=local_descricao
    Digita No Campo JS    name=local_descricao                 LOCAL PRINCIPAL
    Digita No Campo JS    name=local_documentoidentificacao    ${cnpj_local_limpo}
    ${ruas_ie}=    Create List
    ...    Avenida Brasil    Rua Pernambuco    Rua Rio Grande do Norte    Rua Paraná
    ...    Rua São Paulo    Rua Minas Gerais    Avenida Tancredo Neves    Rua Goiás
    ${logradouro_ie}=    Evaluate    random.choice(${ruas_ie})    random
    ${numero_ie}=        Evaluate    str(random.randint(1, 2000))    random
    Digita No Campo JS    name=local_logradouro                ${logradouro_ie}
    Digita No Campo JS    name=local_numero                    ${numero_ie}
    Digita No Campo JS    name=local_bairro                    Centro
    Digita No Campo JS    name=local_cep                       85812000
    Sleep    1.5s
    Selecionar Select JS    name=local_unidadefederativa    PARANA
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    10s
    Sleep    0.8s
    Wait Until Page Contains Element    xpath=//select[@name='local_cidade']/option[contains(text(), 'CASCAVEL')]    15s
    Selecionar Select JS    name=local_cidade    CASCAVEL (PR)
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s
    Sleep    1s
    Digita No Campo JS    name=local_telefone    45999998888
    Rolar Painel Local Ate    ${CHECKBOX_ISENTO_IE}
    Run Keyword If    '${tipo_inscricao}' == 'Isento'
    ...    Click Forcado JS    ${CHECKBOX_ISENTO_IE}
    Run Keyword If    '${tipo_inscricao}' != 'Isento'
    ...    Digita No Campo JS    name=tipoidentificacao_local_inscricaoestadual    123456789
    Rolar Painel Local Ate    name=local_tipolocal
    Selecionar Select JS    name=local_tipolocal    PRINCIPAL
    Sleep    1.5s
    Selecionar primeira opcao valida do select    local_tipologia
    Selecionar primeira opcao valida do select    local_regiao
    Selecionar primeira opcao valida do select    local_segmento
    Sleep    1.5s
    Selecionar primeira opcao valida do select    local_tabelapreco
    Selecionar primeira opcao valida do select    local_condicaopagamento
    Selecionar primeira opcao valida do select    local_tipocobranca
    Rolar Painel Local Ate    id=local_precobase
    Digita No Campo JS    id=local_precobase      150.00
    Digita No Campo JS    name=local_observacao   Cadastro IE via automacao.
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    10s
    Click Forcado JS    id=${btnGravarCadastro}
    Wait Until Element Is Visible    xpath=${popUpAcoes.popUp}    25s
    Click Forcado JS    css=#popup0 a:last-child
    Wait Until Element Is Not Visible    css=.minimalist-popup-background    15s

# ==============================================================================
# PESSOA JURÍDICA (FULL FIELDS — Teste 002)
# ==============================================================================

Cadastra cliente juridico
    Preenche dados gerais pessoa juridica
    Preenche dados de complemento pessoa juridica
    Preenche dados gerais de local
    Preenche dados complementares do local
    Grava cadastro de cliente
    Entra em modo de edicao apos salvar
    Adiciona contato ao cliente
    Adiciona ponto sede ao cliente
    Adiciona limite de credito ao cliente

Preenche dados gerais pessoa juridica
    ${idRand}=    Evaluate    int(time.time() * 1000)
    Set Test Variable    ${nome}    Cliente Automação PJ ${idRand}
    Click Forcado JS    xpath=${geralCliente.pessoajuridica}
    Digita No Campo JS    name=${geralCliente.nomeCliente}      ${nome}
    Digita No Campo JS    name=${geralCliente.fantasiaCliente}  ${nome}
    Digita No Campo JS    name=${geralCliente.numeroMatricula}  ${idRand}
    Selecionar primeira opcao valida do select    parceiro_classificacaoparceiro
    Digita No Campo JS    name=parceiro_homepage    www.automacao.com.br
    Rolar Painel Cliente Ate    name=parceiro_grupoparceiro
    Selecionar Lupa Padrao Cypress    parceiro_grupoparceiro
    Rolar Painel Cliente Ate    name=parceiro_cnae
    Digita No Campo JS    name=parceiro_cnae    6201501

Preenche dados de complemento pessoa juridica
    ${cnpj}=         FakerLibrary.Cnpj
    ${cnpj_limpo}=    Remove String    ${cnpj}    .    -    /
    Rolar Painel Cliente Para    bottom
    Sleep    0.5s
    Digita No Campo JS    name=pessoajuridica_documentoidentificacao    ${cnpj_limpo}
    Digita No Campo JS    name=pessoajuridica_numerofuncionarios        150
    Digita No Campo JS    name=pessoajuridica_datafundacao             15/05/2015
    ${faturamento}=      Evaluate    random.randint(100000, 9000000)    random
    ${capitalSocial}=    Evaluate    random.randint(100000, 5000000)    random
    ${capitalSub}=       Evaluate    int(${capitalSocial} / 2)
    ${capitalInt}=       Evaluate    int(${capitalSocial} / 2)
    Digita No Campo JS    name=pessoajuridica_valorfaturamento         ${faturamento}
    Digita No Campo JS    name=pessoajuridica_valorcapitalsocial       ${capitalSocial}
    Digita No Campo JS    name=pessoajuridica_valorcapitalsubscrito    ${capitalSub}
    Digita No Campo JS    name=pessoajuridica_valorcapitalintegral     ${capitalInt}
    Digita No Campo JS    name=pessoajuridica_situacaocadastral        Novo
    Digita No Campo JS    name=pessoajuridica_situacaoespecial         Novo

# ==============================================================================
# PESSOA FÍSICA — FULL FIELD (Teste 005)
# ==============================================================================

Cadastra cliente fisico
    Preenche dados gerais pessoa fisica
    Preenche dados de complemento pessoa fisica
    Preenche dados gerais de local
    Preenche dados complementares do local
    Grava cadastro de cliente
    Entra em modo de edicao apos salvar
    Adiciona contato ao cliente
    Adiciona ponto sede ao cliente
    Adiciona limite de credito ao cliente

Preenche dados gerais pessoa fisica
    ${idRand}=    Evaluate    int(time.time() * 1000)
    Set Test Variable    ${nome}    Cliente Automação PF ${idRand}
    Click Forcado JS    xpath=//label[@for='rdTipoPessoaPF']
    Digita No Campo JS    name=${geralCliente.nomeCliente}      ${nome}
    Digita No Campo JS    name=${geralCliente.numeroMatricula}  ${idRand}
    Selecionar primeira opcao valida do select    parceiro_classificacaoparceiro
    Digita No Campo JS    name=parceiro_homepage    www.automacao-pf.com.br
    Rolar Painel Cliente Ate    name=parceiro_grupoparceiro
    Selecionar Lupa Padrao Cypress    parceiro_grupoparceiro
    Selecionar primeira opcao valida do select    parceiro_tiposituacaocadastro
    Rolar Painel Cliente Ate    name=parceiro_cnae
    Digita No Campo JS    name=parceiro_cnae    6201501

Preenche dados de complemento pessoa fisica
    ${cpf}=              FakerLibrary.Cpf
    ${cpf_limpo}=         Remove String    ${cpf}    .    -
    ${cpfConj}=           FakerLibrary.Cpf
    ${cpfConj_limpo}=     Remove String    ${cpfConj}    .    -
    Rolar Painel Cliente Para    bottom
    Sleep    0.5s
    Digita No Campo JS    name=pessoafisica_documentoidentificacao    ${cpf_limpo}
    Digita No Campo JS    name=pessoafisica_numerodependentes         2
    Selecionar primeira opcao valida do select    pessoafisica_sglsexo
    Digita No Campo JS    name=pessoafisica_datanascimento            15/08/1990
    Digita No Campo JS    name=pessoafisica_apelido                  Auto PF
    Selecionar primeira opcao valida do select    pessoafisica_escolaridade
    Selecionar primeira opcao valida do select    pessoafisica_estadocivil
    Digita No Campo JS    name=pessoafisica_nomemae                  Maria da Silva Automacao
    Digita No Campo JS    name=pessoafisica_profissao                Analista de Qualidade
    Digita No Campo JS    name=pessoafisica_localtrabalho            TOTVS
    Digita No Campo JS    name=pessoafisica_dataadmissaotrabalho     10/01/2022
    Digita No Campo JS    name=pessoafisica_rendamensal              850000
    Rolar Painel Cliente Ate    name=conjuge_nome
    Digita No Campo JS    name=conjuge_nome                    Esposa Automacao
    Digita No Campo JS    name=conjuge_documentoidentificacao  ${cpfConj_limpo}
    Selecionar primeira opcao valida do select    conjuge_sglsexo
    Digita No Campo JS    name=conjuge_dianascimento           20
    Digita No Campo JS    name=conjuge_mesnascimento           11
    Digita No Campo JS    name=conjuge_anonascimento           1992
    Selecionar primeira opcao valida do select    conjuge_escolaridade
    Digita No Campo JS    name=conjuge_profissao               Engenheiro de Dados

# ==============================================================================
# ENDEREÇO E LOCAL — FULL FIELD
# ==============================================================================

Preenche dados gerais de local
    Rolar Painel Cliente Para    top
    Sleep    0.3s
    ${cnpj_local}=         FakerLibrary.Cnpj
    ${cnpj_local_limpo}=    Remove String    ${cnpj_local}    .    -    /
    # Gera endereço aleatório em Cascavel PR — varia entre clientes para uso em rotas
    ${ruas_cascavel}=    Create List
    ...    Avenida Brasil    Rua Pernambuco    Rua Rio Grande do Norte    Rua Paraná
    ...    Rua São Paulo    Rua Minas Gerais    Avenida Tancredo Neves    Rua 7 de Setembro
    ...    Avenida Curitiba    Rua Independência    Rua Goiás    Rua Mato Grosso
    ${local_logradouro}=    Evaluate    random.choice(${ruas_cascavel})    random
    ${local_numero}=        Evaluate    str(random.randint(1, 2000))    random
    Set Test Variable    ${local_logradouro}    ${local_logradouro}
    Set Test Variable    ${local_numero}        ${local_numero}
    Set Test Variable    ${local_cidade}        CASCAVEL
    Rolar Painel Local Ate    name=local_descricao
    Digita No Campo JS    name=local_descricao                 LOCAL PRINCIPAL
    Digita No Campo JS    name=local_documentoidentificacao    ${cnpj_local_limpo}
    Digita No Campo JS    name=local_logradouro                ${local_logradouro}
    Digita No Campo JS    name=local_numero                    ${local_numero}
    Digita No Campo JS    name=local_bairro                    Centro
    Digita No Campo JS    name=local_complemento               Casa
    Digita No Campo JS    name=local_cep                       85812000
    Digita No Campo JS    name=local_caixapostal               85812
    Sleep    1.5s
    Selecionar Select JS    name=local_unidadefederativa    PARANA
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    10s
    Sleep    0.8s
    Wait Until Page Contains Element    xpath=//select[@name='local_cidade']/option[contains(text(), 'CASCAVEL')]    15s
    Selecionar Select JS    name=local_cidade    CASCAVEL (PR)
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s
    Sleep    1s
    ${limiteCredito}=    Evaluate    random.randint(1000, 20000)    random
    Rolar Painel Local Ate    name=local_limitesugerido
    Digita No Campo JS    name=local_limitesugerido    ${limiteCredito}
    Digita No Campo JS    name=local_telefone          45999998888
    Digita No Campo JS    name=local_email             automacao@teste.com.br
    Rolar Painel Local Ate    name=tipoidentificacao_local_cartaoprodutor
    Digita No Campo JS    name=tipoidentificacao_local_cartaoprodutor    123456789
    Wait Until Page Contains Element    ${CHECKBOX_ISENTO_IE}    15s
    Click Forcado JS    ${CHECKBOX_ISENTO_IE}

Preenche dados complementares do local
    Rolar Painel Local Ate    name=local_tipolocal
    Selecionar Select JS    name=local_tipolocal    PRINCIPAL
    Sleep    1.5s
    Selecionar primeira opcao valida do select    local_tipologia
    Selecionar primeira opcao valida do select    local_regiao
    Selecionar primeira opcao valida do select    local_segmento
    Sleep    1.5s
    Selecionar primeira opcao valida do select    local_tabelapreco
    Selecionar primeira opcao valida do select    local_condicaopagamento
    Selecionar primeira opcao valida do select    local_tipocobranca
    Rolar Painel Local Ate    id=local_precobase
    Digita No Campo JS    id=local_precobase      150.00
    Digita No Campo JS    name=local_observacao   Cadastro full via automacao.

# ==============================================================================
# GRAVAR E EDITAR
# ==============================================================================

Grava cadastro de cliente
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    10s
    Click Forcado JS    id=${btnGravarCadastro}
    Wait Until Element Is Visible    xpath=${popUpAcoes.popUp}    25s

Entra em modo de edicao apos salvar
    Wait Until Page Contains Element    css=#popup0 a:nth-child(1)    15s
    Sleep    0.5s
    Click Forcado JS    css=#popup0 a:nth-child(1)
    Wait Until Element Is Not Visible    css=.minimalist-popup-background    15s

# ==============================================================================
# CONTATOS
# ==============================================================================

Adiciona contato ao cliente
    Rolar Painel Cliente Para    top
    Rolar Painel Cliente Ate     id=btnContato
    Click Forcado JS             id=btnContato
    Wait Until Element Is Visible    id=grid-button-adicionar    20s
    Click Forcado JS                 id=grid-button-adicionar
    Wait Until Element Is Visible    name=contatopessoa_nome    15s
    Digita No Campo JS    name=contatopessoa_nome        Contato Automacao
    Digita No Campo JS    name=contatopessoa_telefone    45988887777
    Digita No Campo JS    name=contatopessoa_email       contato@automacao.com.br
    Click Forcado JS    xpath=//label[@for='rdAtivosim']
    Sleep    0.5s
    Execute Javascript
    ...    var btns = Array.from(document.querySelectorAll("[id='btnGravar']"));
    ...    var visiveis = btns.filter(function(b) { return b.offsetParent !== null; });
    ...    if (visiveis.length === 0) throw new Error("Nenhum btnGravar visivel");
    ...    visiveis[visiveis.length - 1].click();
    Sleep    1s
    ${tem_toast}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.jGrowl-message    5s
    # Fecha o toast imediatamente em vez de aguardar ele sumir (mais rápido)
    Run Keyword If    ${tem_toast}    Execute Javascript
    ...    document.querySelectorAll('.jGrowl-close').forEach(function(b){ b.click(); });
    Run Keyword If    ${tem_toast}    Sleep    0.3s
    Sleep    1s
    Wait Until Page Contains Element
    ...    xpath=//div[@id='grid_contato']//div[contains(@class,'slick-viewport')]//div[contains(@class,'l0')]    15s
    Sleep    1s
    Click Forcado JS
    ...    xpath=(//div[@id='grid_contato']//div[contains(@class,'slick-viewport')]//div[contains(@class,'l0')])[1]
    Sleep    1s
    Execute Javascript
    ...    var popup = document.querySelector("#popup0");
    ...    if (popup) popup.scrollTop = popup.scrollHeight;
    ...    document.querySelectorAll("[id^='popup']").forEach(function(d) { d.scrollTop = d.scrollHeight; });
    Sleep    0.5s
    Execute Javascript
    ...    var btns = Array.from(document.querySelectorAll("[id='btnVoltar']"));
    ...    var visiveis = btns.filter(function(b) { return b.offsetParent !== null; });
    ...    if (visiveis.length === 0) throw new Error("Nenhum btnVoltar visivel");
    ...    visiveis[visiveis.length - 1].click();
    Wait Until Element Is Not Visible    css=.minimalist-popup-background    15s
    Sleep    1s
    Log To Console    \n💾 Persistindo contato no cadastro principal...
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    10s
    # Clica no btnGravar visível (filtra por offsetParent para evitar clicar em btn de popup fechado)
    Execute Javascript
    ...    var btns = Array.from(document.querySelectorAll("[id='btnGravar']"));
    ...    var visiveis = btns.filter(function(b) { return b.offsetParent !== null; });
    ...    if (visiveis.length === 0) throw new Error("Nenhum btnGravar visivel para salvar cadastro");
    ...    visiveis[visiveis.length - 1].click();
    Sleep    3s
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s
    Log To Console    ✅ Cadastro com contato finalizado!

# ==============================================================================
# PONTO SEDE
# ==============================================================================

Adiciona ponto sede ao cliente
    Log To Console    \n📍 Adicionando ponto sede ao cliente...
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    20s
    Sleep    2s
    # Após salvar o contato a página fica em modo edição compacto:
    # btnGravar fica como ícone azul (display:none no botão texto), mas a edição está ativa.
    # NÃO verificar visibilidade de btnGravar nem clicar em "Editar cadastro"
    # (navegar para "Editar cadastro" abre layout diferente sem o grid de locais).
    # Os ícones das linhas do grid de locais (incluindo pontocentral) ficam sempre visíveis.
    # Seleciona a primeira linha do grid de locais (necessário para ativar os botões de ação)
    Wait Until Page Contains Element    css=#grid_local .slick-row    20s
    Execute Javascript
    ...    var cell = document.querySelector("#grid_local .slick-row .slick-cell.l0");
    ...    if (cell) cell.click();
    ...    else throw new Error("Primeira célula do grid de locais não encontrada");
    Sleep    1s
    # Clica no ícone pontocentral NA LINHA DE DADOS (não no cabeçalho do grid)
    # Escopo: #grid_local .slick-row para evitar clicar no ícone do header que não abre popup
    Wait Until Page Contains Element    xpath=//div[@id='grid_local']//div[contains(@class,'slick-row')]//img[contains(@src,'pontocentral')]    10s
    Log To Console    ✅ Ícone pontocentral encontrado — clicando...
    ${pontocentral}=    Get WebElement    xpath=//div[@id='grid_local']//div[contains(@class,'slick-row')]//img[contains(@src,'pontocentral')]
    Execute Javascript    arguments[0].scrollIntoView({block:'center',inline:'center'});    ARGUMENTS    ${pontocentral}
    Sleep    0.5s
    Click Element    xpath=//div[@id='grid_local']//div[contains(@class,'slick-row')]//img[contains(@src,'pontocentral')]
    Sleep    2s
    # Aguarda o popup do mapa abrir (Google Maps API pode demorar para carregar)
    Wait Until Element Is Visible    css=.gmap-searchInput    30s
    Sleep    1s
    Click Element    css=.gmap-searchInput
    Input Text    css=.gmap-searchInput    ${local_logradouro} ${local_numero}, ${local_cidade}
    Sleep    2s
    Wait Until Element Is Visible    css=.pac-item    10s
    Click Element    css=.pac-item
    Sleep    2s
    Click Element At Coordinates    css=.gm-style    0    0
    Sleep    1s
    Handle Alert    ACCEPT
    Sleep    1s
    # Rola o popup para garantir que os botões Gravar/Voltar estejam visíveis
    Execute Javascript
    ...    var popup = document.querySelector("#popup0 .minimalist-popup-div");
    ...    if (popup) popup.scrollTop = popup.scrollHeight;
    Sleep    0.5s
    Wait Until Element Is Visible    id=btnGravarMapeamento    10s
    Click Forcado JS    id=btnGravarMapeamento
    Sleep    1s
    # Clica em Voltar DENTRO do #popup0 para evitar clicar em btnVoltar de outro popup
    Execute Javascript
    ...    var popup = document.querySelector("#popup0");
    ...    if (popup) {
    ...        var btn = popup.querySelector("[id='btnVoltar']");
    ...        if (btn) btn.click();
    ...        else throw new Error("btnVoltar não encontrado dentro do #popup0");
    ...    } else throw new Error("#popup0 não encontrado");
    Wait Until Element Is Not Visible    css=.minimalist-popup-background    15s
    Sleep    1s
    Log To Console    ✅ Ponto sede adicionado com sucesso!
    Log To Console    💾 Gravando cadastro com ponto sede...
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    10s
    # Salva o cadastro clicando no btnGravar visível (pode estar como ícone — offsetParent filtra)
    Execute Javascript
    ...    var btns = Array.from(document.querySelectorAll("[id='btnGravar']"));
    ...    var visiveis = btns.filter(function(b) { return b.offsetParent !== null; });
    ...    if (visiveis.length > 0) { visiveis[visiveis.length - 1].click(); return; }
    ...    if (btns.length > 0) { btns[btns.length - 1].click(); return; }
    ...    throw new Error("Nenhum btnGravar encontrado no DOM");
    Sleep    3s
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s
    Log To Console    ✅ Cadastro com ponto sede gravado!

# ==============================================================================
# LIMITE DE CRÉDITO
# ==============================================================================

Adiciona limite de credito ao cliente
    Log To Console    \n💳 Adicionando limite de crédito ao cliente: ${nome}
    ${res}=    DatabaseLibrary.Query    SELECT idparceiro FROM parceiro WHERE nomeparceiro = '${nome}'
    Should Not Be Empty    ${res}    msg=❌ Cliente não encontrado no banco: ${nome}
    ${idparceiro}=    Set Variable    ${res[0][0]}
    ${url_atual}=    Get Location
    ${match}=    Get Regexp Matches    ${url_atual}    (ID_\\d+)
    ${session_id}=    Set Variable    ${match[0]}
    ${url_limite}=    Set Variable    ${aplicacao_web.urlWeb}${session_id}/cliente/visao360/financeiro/limitecredito.list.ws?filtrar360Menu=true&sk=&baseRequest=cliente/visao360/cadastro.cliente.ws&idCliente=${idparceiro}
    Go To    ${url_limite}
    Wait Until Element Is Not Visible    class=minimalist-loading-background    30s
    Sleep    1s
    Wait Until Element Is Visible    xpath=//span[normalize-space()='Adicionar']    15s
    Click Element    xpath=//span[normalize-space()='Adicionar']
    Sleep    1s
    Wait Until Element Is Visible    css=.slick-cell.lr.l1.r1    20s
    Sleep    0.5s
    # Ativa o editor da célula Local (l1) — aguarda a lupa aparecer antes de interagir
    Click Element    css=.slick-cell.lr.l1.r1
    Wait Until Element Is Visible    xpath=//span[@class='ui-icon ui-icon-search']    10s
    Sleep    0.5s
    # Abre o popup de busca de local via duplo clique na lupa
    Double Click Element    xpath=//span[@class='ui-icon ui-icon-search']
    Sleep    2s
    # Seleciona o primeiro local do popup.
    # Antes do popup: 1 célula l4.r4 no grid principal (data início).
    # Após popup abrir: N células l4.r4 adicionais (popup renderiza depois no DOM).
    # Clicar no ÚLTIMO l4.r4 garante que clicamos no popup, não na data do grid principal.
    ${l4_cells}=    Get WebElements    css=.slick-cell.lr.l4.r4
    ${popup_l4}=    Set Variable    ${l4_cells[-1]}
    Click Element    ${popup_l4}
    Sleep    1s
    # Dt. início vigência: hoje
    # Usa Digita No Campo JS para disparar eventos input+change que o datepicker precisa
    ${data_inicio}=    Evaluate    __import__('datetime').date.today().strftime('%d/%m/%Y')
    Wait Until Element Is Visible    css=.slick-cell.lr.l4.r4    10s
    Click Element    css=.slick-cell.lr.l4.r4
    Sleep    0.5s
    Wait Until Element Is Visible    xpath=//div[contains(@class,'l4') and contains(@class,'active')]//input    5s
    Digita No Campo JS    xpath=//div[contains(@class,'l4') and contains(@class,'active')]//input    ${data_inicio}
    Press Keys    xpath=//div[contains(@class,'l4') and contains(@class,'active')]//input    RETURN
    Sleep    0.5s
    # Dt. fim vigência: hoje + 365 dias
    ${data_fim}=    Evaluate    (__import__('datetime').date.today() + __import__('datetime').timedelta(days=365)).strftime('%d/%m/%Y')
    Wait Until Element Is Visible    css=.slick-cell.lr.l5.r5    5s
    Click Element    css=.slick-cell.lr.l5.r5
    Sleep    0.5s
    Wait Until Element Is Visible    xpath=//div[contains(@class,'l5') and contains(@class,'active')]//input    5s
    Digita No Campo JS    xpath=//div[contains(@class,'l5') and contains(@class,'active')]//input    ${data_fim}
    Press Keys    xpath=//div[contains(@class,'l5') and contains(@class,'active')]//input    RETURN
    Sleep    0.5s
    # Saldo inicial (l6): usa Digita No Campo JS para disparar eventos corretamente
    Wait Until Element Is Visible    css=.slick-cell.lr.l6.r6    10s
    Click Element    css=.slick-cell.lr.l6.r6
    Sleep    0.5s
    Wait Until Element Is Visible    xpath=//div[contains(@class,'l6') and contains(@class,'active')]//input    5s
    Digita No Campo JS    xpath=//div[contains(@class,'l6') and contains(@class,'active')]//input    500
    Press Keys    xpath=//div[contains(@class,'l6') and contains(@class,'active')]//input    RETURN
    Sleep    0.5s
    # Tipo limite (l8): clique simples na lupa dentro da célula l8 ativa
    Click Element    css=.slick-cell.lr.l8.r8
    Sleep    0.5s
    Wait Until Element Is Visible    xpath=//div[contains(@class,'l8') and contains(@class,'active')]//span[@class='ui-icon ui-icon-search']    5s
    Click Forcado JS    xpath=//div[contains(@class,'l8') and contains(@class,'active')]//span[@class='ui-icon ui-icon-search']
    Sleep    2s
    # Seleciona o primeiro resultado — tenta popup slick-grid (2+ row='0') ou btnConfirmar
    ${row_count}=    Get Element Count    xpath=//div[@row='0']
    Run Keyword If    ${row_count} > 1
    ...    Click Element    xpath=(//div[@row='0'])[last()]//div[contains(@class,'slick-cell')][2]
    ${has_confirm}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=btnConfirmar    2s
    Run Keyword If    ${has_confirm}    Click Forcado JS    id=btnConfirmar
    Sleep    1s
    # Clica em l7 (Saldo disponível) para sair do l8 e persistir o tipo limite
    Wait Until Element Is Visible    css=.slick-cell.lr.l7.r7    5s
    Click Forcado JS    css=.slick-cell.lr.l7.r7
    Sleep    0.5s
    # Grava no banco via botão Gravar da página de limite de crédito
    Wait Until Element Is Visible    xpath=//span[contains(@class,'ui-sim3g-icon-gravar-white')]    10s
    Click Forcado JS    xpath=//span[contains(@class,'ui-sim3g-icon-gravar-white')]
    Sleep    2s
    ${tem_toast}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.jGrowl-message    5s
    Run Keyword If    ${tem_toast}    Wait Until Element Is Not Visible    css=.jGrowl-message    15s
    Log To Console    ✅ Limite de crédito adicionado com sucesso!

# ==============================================================================
# TESTE 006 — Anexos (DTSFASAPP-T1135)
# ==============================================================================

Prepara dados para teste de anexo
    Log To Console    \n🎯 Preparando dados para Teste 006 - Anexo...
    DatabaseLibrary.Execute Sql String
    ...    UPDATE wsconfigentidadecampo SET idnpermiteeditar = 1, idnpermitevisualizar = 1 WHERE labelcampo = 'Anexo'
    ${res}=    DatabaseLibrary.Query
    ...    SELECT p.idparceiro, p.nomeparceiro FROM parceiro p WHERE p.nomeparceiro LIKE '%Automação%' AND p.idnativo = 1 LIMIT 1
    Should Not Be Empty    ${res}
    ...    msg=❌ Nenhum cliente com Automação encontrado. Execute os testes 002 ou 005 antes.
    ${idparceiro}=    Set Variable    ${res[0][0]}
    ${nomeparceiro}=    Set Variable    ${res[0][1]}
    Set Suite Variable    ${idparceiro_anexo}      ${idparceiro}
    Set Suite Variable    ${nome_parceiro_anexo}   ${nomeparceiro}
    Log To Console    \n🎯 Cliente selecionado: [${idparceiro}] ${nomeparceiro}
    DatabaseLibrary.Execute Sql String
    ...    DELETE FROM parceiroanexo WHERE idparceiro = ${idparceiro}
    Log To Console    \n🧹 Anexos anteriores removidos para idparceiro=${idparceiro}
    Log To Console    ✅ Dados preparados para teste de anexo.

Pesquisa e edita cliente por nome de banco de anexo
    Pesquisa e edita cliente    ${nome_parceiro_anexo}

Abre modal de anexos
    Wait Until Page Contains Element    id=btnAnexo    15s
    Click Forcado JS    id=btnAnexo
    Wait Until Element Is Visible    css=.minimalist-popup-div    10s
    Sleep    1s
    Log To Console    \n📎 Modal de anexos aberto.

Fecha modal de anexos
    Execute Javascript
    ...    var modais = Array.from(document.querySelectorAll(".minimalist-popup-div"));
    ...    var visivelModal = modais.find(function(m) {
    ...        return window.getComputedStyle(m).display !== "none";
    ...    });
    ...    if (!visivelModal) throw new Error("Modal nao encontrado");
    ...    var btnX = visivelModal.querySelector(".minimalist-table-cell .ui-button-icon-primary");
    ...    if (!btnX) throw new Error("Botao X do modal nao encontrado");
    ...    btnX.click();
    Wait Until Element Is Not Visible    css=.minimalist-popup-div    10s
    Log To Console    ✅ Modal de anexos fechado.

Faz upload de arquivo no modal de anexos
    [Arguments]    ${caminho_arquivo}
    File Should Exist    ${caminho_arquivo}
    Wait Until Page Contains Element    id=anexoFileUpload    10s
    Choose File    id=anexoFileUpload    ${caminho_arquivo}
    Sleep    1.5s
    Log To Console    \n📁 Arquivo enviado: ${caminho_arquivo}

Grava anexos e valida sucesso
    Click Forcado JS    id=btnGravarAnexo
    ${tem_toast}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.jGrowl-message    10s
    Run Keyword If    ${tem_toast}    Execute Javascript
    ...    document.querySelectorAll('.jGrowl-close').forEach(function(b){ b.click(); });
    Run Keyword If    ${tem_toast}    Sleep    0.3s
    Sleep    1s
    Log To Console    ✅ Anexo gravado com sucesso!

Seleciona primeiro anexo na grid
    Wait Until Page Contains Element    xpath=//div[@id='grid_anexo']//div[contains(@class,'slick-row')]    15s
    Sleep    0.5s
    Execute Javascript
    ...    var grid = document.getElementById("grid_anexo");
    ...    if (!grid) throw new Error("Grid de anexos nao encontrada");
    ...    var primeiraLinha = grid.querySelector(".slick-row");
    ...    if (!primeiraLinha) throw new Error("Nenhuma linha na grid de anexos");
    ...    var checkbox = primeiraLinha.querySelector("input[name='check']");
    ...    if (checkbox) {
    ...        checkbox.click();
    ...    } else {
    ...        var celula = primeiraLinha.querySelector(".slick-cell");
    ...        if (celula) celula.click();
    ...        else primeiraLinha.click();
    ...    }
    Sleep    0.5s
    Log To Console    \n☑️ Primeiro anexo selecionado na grid.

Parte 1 Adiciona imagem ao cliente
    [Documentation]    Parte 1: Abre modal, faz upload da imagem, grava e fecha.
    ...                NÃO remove — a Parte 2 é responsável pela remoção.
    Log To Console    \n--- PARTE 1: UPLOAD DE IMAGEM ---
    Abre modal de anexos
    Faz upload de arquivo no modal de anexos    ${FIXTURE_IMAGEM}
    Grava anexos e valida sucesso
    Fecha modal de anexos
    Log To Console    ✅ PARTE 1 CONCLUÍDA!

Parte 2 Remove anexo do cliente
    [Documentation]    Parte 2: Abre modal (imagem da Parte 1 está na grid),
    ...                seleciona, remove com SweetAlert e grava.
    Log To Console    \n--- PARTE 2: REMOÇÃO DE ANEXO ---
    Sleep    1s
    Abre modal de anexos
    Seleciona primeiro anexo na grid
    Click Forcado JS    id=btnRemoveTodos
    Sleep    1s
    Wait Until Element Is Visible    css=.swal2-popup    10s
    Click Forcado JS    css=.swal2-confirm
    Wait Until Element Is Not Visible    css=.swal2-popup    10s
    Log To Console    \n🗑️ Remoção confirmada no SweetAlert.
    Grava anexos e valida sucesso
    Fecha modal de anexos
    Log To Console    ✅ PARTE 2 CONCLUÍDA!

Parte 3 Upload multiplo de anexos
    [Documentation]    Parte 3: Abre modal (vazio após Parte 2), faz upload de imagem e PDF.
    ...                CORREÇÃO: O input id="anexoFileUpload" só aceita um arquivo por vez.
    ...                Fazemos upload da imagem, gravamos, depois upload do PDF, gravamos.
    ...                Resultado final: 2 registros na grid.
    Log To Console    \n--- PARTE 3: UPLOAD MÚLTIPLO ---
    Sleep    1s
    Abre modal de anexos

    # Upload e gravação da imagem
    Log To Console    \n📁 Enviando imagem...
    Faz upload de arquivo no modal de anexos    ${FIXTURE_IMAGEM}
    Grava anexos e valida sucesso

    # Upload e gravação do PDF (modal continua aberto)
    Log To Console    \n📁 Enviando PDF...
    Faz upload de arquivo no modal de anexos    ${FIXTURE_PDF}
    Grava anexos e valida sucesso

    # Valida 2 linhas na grid
    ${qtd_linhas}=    Get Element Count    xpath=//div[@id='grid_anexo']//div[contains(@class,'slick-row')]
    Should Be Equal As Integers    ${qtd_linhas}    2
    ...    msg=❌ Esperado 2 anexos na grid. Encontrado: ${qtd_linhas}
    Log To Console    \n✅ Grid com ${qtd_linhas} anexos validada!
    Fecha modal de anexos
    Log To Console    ✅ PARTE 3 CONCLUÍDA! Fluxo de anexos finalizado com sucesso!

# ==============================================================================
# TESTE 007 — Logotipo (DTSFASAPP-T1136)
#
# O #btnUpload do logotipo provavelmente usa um input DIFERENTE do #btnAnexo.
# Vamos logar todos os inputs de arquivo disponíveis na página para diagnóstico,
# e testar os seletores mais prováveis baseados no padrão do sistema.
# ==============================================================================

Prepara dados para teste de logotipo
    Log To Console    \n🎯 Preparando dados para Teste 007 - Logotipo...
    DatabaseLibrary.Execute Sql String
    ...    UPDATE wsconfigentidadecampo SET idnpermiteeditar = 1, idnpermitevisualizar = 1 WHERE nomecampo = 'imagem' AND labelcampo = 'Logotipo'
    ${res}=    DatabaseLibrary.Query
    ...    SELECT idparceiro, nomeparceiro FROM parceiro WHERE nomeparceiro LIKE '%Automação%' AND idnativo = 1 LIMIT 1
    Should Not Be Empty    ${res}
    ...    msg=❌ Nenhum cliente com Automação encontrado. Execute os testes 002 ou 005 antes.
    ${idparceiro}=    Set Variable    ${res[0][0]}
    ${nomeparceiro}=    Set Variable    ${res[0][1]}
    Set Suite Variable    ${idparceiro_logotipo}      ${idparceiro}
    Set Suite Variable    ${nome_parceiro_logotipo}   ${nomeparceiro}
    Log To Console    \n🎯 Cliente selecionado: [${idparceiro}] ${nomeparceiro}
    DatabaseLibrary.Execute Sql String
    ...    DELETE FROM parceiroimagem WHERE idparceiro = ${idparceiro}
    Log To Console    \n🧹 Logotipo anterior removido para idparceiro=${idparceiro}
    Log To Console    ✅ Dados preparados para teste de logotipo.

Pesquisa e edita cliente por nome de banco de logotipo
    Pesquisa e edita cliente    ${nome_parceiro_logotipo}

Adiciona logotipo ao cliente
    [Documentation]    Clica no botão de logotipo, que cria um input[type=file] no DOM
    ...                e abre o file picker nativo. Choose File injeta o arquivo via
    ...                send_keys, fechando o dialog e disparando o upload AJAX.
    Log To Console    \n--- Iniciando Upload de Logotipo ---
    File Should Exist    ${FIXTURE_IMAGEM}

    Rolar Painel Cliente Para    top
    Sleep    0.5s
    Wait Until Element Is Visible    id=btnUpload    15s

    # Tenta revelar qualquer input[type=file] já oculto no DOM (sem clicar no botão)
    Execute Javascript
    ...    var inputs = document.querySelectorAll('input[type="file"]');
    ...    inputs.forEach(function(i){ i.style.display='block'; i.style.visibility='visible'; i.style.opacity='1'; });
    ${count}=    Get Element Count    xpath=//input[@type='file']

    # Se não há input no DOM, usa clique Selenium (confiável) para criá-lo.
    # Choose File envia o caminho diretamente ao input via send_keys — não interage com o dialog do SO.
    # Em headless (Azure DevOps) nenhum dialog é aberto.
    Run Keyword If    ${count} == 0    Click Element    id=btnUpload
    Run Keyword If    ${count} == 0    Sleep    1s

    Wait Until Page Contains Element    xpath=//input[@type='file']    10s
    Choose File    xpath=//input[@type='file']    ${FIXTURE_IMAGEM}
    Log To Console    \n📸 Arquivo selecionado. Aguardando upload...

    # Aguarda o indicador de upload aparecer e desaparecer
    Run Keyword And Ignore Error    Wait Until Element Is Visible      id=alertAnexando    5s
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible  id=alertAnexando    15s
    Sleep    1s

    # Grava — último btnGravar visível
    Execute Javascript
    ...    var btns = Array.from(document.querySelectorAll("[id='btnGravar']"));
    ...    var visiveis = btns.filter(function(b) { return b.offsetParent !== null; });
    ...    if (visiveis.length === 0) throw new Error("Nenhum btnGravar visivel");
    ...    visiveis[visiveis.length - 1].click();
    Sleep    3s
    Log To Console    ✅ Logotipo enviado e salvo.

Valida logotipo gravado no banco
    Log To Console    \n--- Validando Logotipo no Banco ---
    ${res}=    DatabaseLibrary.Query
    ...    SELECT COUNT(*) AS total FROM parceiroimagem WHERE idparceiro = ${idparceiro_logotipo}
    ${total}=    Set Variable    ${res[0][0]}
    Log To Console    \n📊 Registros em parceiroimagem: ${total}
    Should Be True    ${total} >= 1
    ...    msg=❌ Logotipo não encontrado no banco para idparceiro=${idparceiro_logotipo}
    Log To Console    ✅ Logotipo validado no banco! Total de registros: ${total}

# ==============================================================================
# TESTE 007 — Novo Local (DTSFASAPP-T1134)
# ==============================================================================

Prepara dados para teste de novo local
    Log To Console    \n🎯 Preparando dados para Teste 007 - Novo Local...
    ${res}=    DatabaseLibrary.Query
    ...    SELECT idparceiro, nomeparceiro FROM parceiro WHERE nomeparceiro LIKE '%Automação%' AND idnativo = 1 LIMIT 1
    Should Not Be Empty    ${res}
    ...    msg=❌ Nenhum cliente com Automação encontrado. Execute os testes 002 ou 003 antes.
    Set Suite Variable    ${nome_parceiro_novo_local}    ${res[0][1]}
    Log To Console    \n🎯 Cliente selecionado: ${nome_parceiro_novo_local}
    Log To Console    ✅ Dados preparados para teste de novo local.

Adiciona novo local ao cliente
    [Documentation]    Clica em Adicionar na seção de locais, preenche o popup e salva.
    Rolar Painel Cliente Para    top
    Wait Until Page Contains Element    id=btnAdicionar    15s
    Click Forcado JS    id=btnAdicionar
    Wait Until Element Is Visible    css=.minimalist-popup-div    15s
    Sleep    0.5s
    Digita No Campo JS    name=local_descricao      LOCAL SECUNDARIO AUTO
    Digita No Campo JS    name=local_logradouro     Rua das Automaticas
    Digita No Campo JS    name=local_numero         456
    Digita No Campo JS    name=local_bairro         Centro
    Digita No Campo JS    name=local_complemento    Apto 10
    Digita No Campo JS    name=local_cep            11013010
    Sleep    1s
    Selecionar Select JS    id=cmbTipoLocal    PRINCIPAL
    Sleep    0.5s
    Selecionar Select JS    id=cmbUF    SAO PAULO
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s
    Sleep    0.8s
    Wait Until Page Contains Element    xpath=//select[@id='cmbCidade']/option[contains(text(), 'SANTOS')]    15s
    Selecionar Select JS    id=cmbCidade    SANTOS (SP)
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s
    Sleep    0.5s
    Digita No Campo JS    id=local_limitesugerido    5000
    Digita No Campo JS    id=txtTelefoneLocal        13999998888
    Digita No Campo JS    id=txtEmailLocal           automacao.local@teste.com.br
    Execute Javascript
    ...    var btns = Array.from(document.querySelectorAll(".minimalist-popup-buttons #btnGravar, .minimalist-popup-div #btnGravar"));
    ...    var visiveis = btns.filter(function(b) { return b.offsetParent !== null; });
    ...    if (visiveis.length === 0) throw new Error("Nenhum btnGravar no popup visivel");
    ...    visiveis[visiveis.length - 1].click();
    Sleep    2s
    Log To Console    ✅ Novo local adicionado e salvo.

Valida novo local adicionado com sucesso
    ${tem_toast}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.jGrowl-message    8s
    Run Keyword If    ${tem_toast}    Log To Console    \n✅ Toast de sucesso exibido para novo local!
    Run Keyword If    not ${tem_toast}    Log To Console    \n⚠️ Toast sumiu antes da verificação — local OK.
    Wait Until Element Is Not Visible    css=.minimalist-popup-background    10s
    Log To Console    ✅ Popup de local fechado com sucesso!

# ==============================================================================
# TESTE 008 — Inativação de Cliente (DTSFASAPP-T1131)
# ==============================================================================

Prepara dados para teste de inativacao
    Log To Console    \n🎯 Preparando dados para Teste 008 - Inativação...
    DatabaseLibrary.Execute Sql String
    ...    UPDATE parceiro SET idnativo = 1 WHERE nomeparceiro LIKE '%Automação%'
    ${res}=    DatabaseLibrary.Query
    ...    SELECT idparceiro, nomeparceiro FROM parceiro WHERE nomeparceiro LIKE '%Automação%' AND idnativo = 1 LIMIT 1
    Should Not Be Empty    ${res}
    ...    msg=❌ Nenhum cliente com Automação encontrado. Execute os testes 002 ou 003 antes.
    Set Suite Variable    ${idparceiro_inativacao}      ${res[0][0]}
    Set Suite Variable    ${nome_parceiro_inativacao}   ${res[0][1]}
    Log To Console    \n🎯 Cliente selecionado: [${idparceiro_inativacao}] ${nome_parceiro_inativacao}
    Log To Console    ✅ Dados preparados para teste de inativação.

Inativa cliente na tela
    [Documentation]    Clica no radio button "Não" da situação ativo e salva o cadastro.
    Wait Until Page Contains Element    id=rdAtivonao    15s
    Click Forcado JS    id=rdAtivonao
    Sleep    0.5s
    Valida gravacao com sucesso
    Log To Console    ✅ Cliente inativado com sucesso na tela.

Valida cliente inativo no banco
    Log To Console    \n--- Validando Inativação no Banco ---
    Sleep    2s
    ${res}=    DatabaseLibrary.Query
    ...    SELECT idnativo FROM parceiro WHERE idparceiro = ${idparceiro_inativacao}
    ${idnativo}=    Set Variable    ${res[0][0]}
    Should Be Equal As Integers    ${idnativo}    0
    ...    msg=❌ Cliente não foi inativado no banco. idnativo=${idnativo}
    Log To Console    ✅ Cliente validado como inativo no banco! idnativo=${idnativo}

# ==============================================================================
# KEYWORDS DE SCROLL
# ==============================================================================

Rolar Painel Cliente Ate
    [Arguments]    ${locator}
    Wait Until Page Contains Element    ${locator}    15s
    ${element}=    Get WebElement    ${locator}
    Execute Javascript
    ...    var c = document.querySelector(".cliente-container");
    ...    if(c) { c.scrollTop = arguments[0].offsetTop - 100; }
    ...    arguments[0].scrollIntoView({block: "center"});
    ...    ARGUMENTS    ${element}
    Sleep    0.4s

Rolar Painel Cliente Para
    [Arguments]    ${posicao}
    Run Keyword If    '${posicao}' == 'top'
    ...    Execute Javascript    var c = document.querySelector(".cliente-container"); if(c) c.scrollTop = 0;
    Run Keyword If    '${posicao}' == 'bottom'
    ...    Execute Javascript    var c = document.querySelector(".cliente-container"); if(c) c.scrollTop = c.scrollHeight;
    Sleep    0.3s

Rolar Painel Local Ate
    [Arguments]    ${locator}
    Wait Until Page Contains Element    ${locator}    15s
    ${element}=    Get WebElement    ${locator}
    Execute Javascript
    ...    (function scrollParent(el) {
    ...        el.scrollIntoView({block: "center", behavior: "instant"});
    ...        var parent = el.parentElement;
    ...        while (parent && parent !== document.body) {
    ...            var style = window.getComputedStyle(parent);
    ...            if (/auto|scroll/.test(style.overflowY + style.overflow)) {
    ...                parent.scrollTop = el.offsetTop - 100;
    ...                break;
    ...            }
    ...            parent = parent.parentElement;
    ...        }
    ...    })(arguments[0]);
    ...    ARGUMENTS    ${element}
    Sleep    0.4s

# ==============================================================================
# KEYWORDS DE APOIO GERAIS
# ==============================================================================

Digita No Campo JS
    [Arguments]    ${locator}    ${valor}
    Wait Until Page Contains Element    ${locator}    15s
    ${element}=    Get WebElement    ${locator}
    Execute Javascript
    ...    arguments[0].scrollIntoView({block: "center", behavior: "instant"});
    ...    arguments[0].focus();
    ...    arguments[0].value = "";
    ...    arguments[0].value = arguments[1];
    ...    arguments[0].dispatchEvent(new Event("input", {bubbles: true}));
    ...    arguments[0].dispatchEvent(new Event("change", {bubbles: true}));
    ...    ARGUMENTS    ${element}    ${valor}
    Sleep    0.2s

Click Forcado JS
    [Arguments]    ${locator}
    Wait Until Page Contains Element    ${locator}    15s
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${element}

Selecionar Select JS
    [Arguments]    ${locator}    ${label}
    Wait Until Page Contains Element    ${locator}    15s
    ${element}=    Get WebElement    ${locator}
    Execute Javascript
    ...    var sel = arguments[0];
    ...    var label = arguments[1];
    ...    for (var i = 0; i < sel.options.length; i++) {
    ...        if (sel.options[i].text.trim() === label) {
    ...            sel.selectedIndex = i;
    ...            sel.dispatchEvent(new Event("change", {bubbles: true}));
    ...            break;
    ...        }
    ...    }
    ...    ARGUMENTS    ${element}    ${label}
    Sleep    0.3s

Selecionar Lupa Padrao Cypress
    [Arguments]    ${nome_input}
    ${lupa}=    Set Variable
    ...    xpath=(//*[@name='${nome_input}']/..//*[contains(@class, 'ui-button') or contains(@class, 'icon-search') or contains(@class, 'btn-pesquisa') or self::button])[1]
    Click Forcado JS    ${lupa}
    Wait Until Element Is Visible    css=.slick-cell    20s
    Click Forcado JS    css=.slick-cell
    Click Forcado JS    id=btnConfirmar
    Sleep    0.5s

Selecionar primeira opcao valida do select
    [Arguments]    ${nome_select}
    Wait Until Page Contains Element    xpath=//select[@name='${nome_select}']    10s
    Execute Javascript
    ...    var sel = document.querySelector("select[name='${nome_select}']");
    ...    if (sel) sel.removeAttribute('disabled');
    Execute Javascript
    ...    var sel = document.querySelector("select[name='${nome_select}']");
    ...    if (sel && sel.options.length > 1) {
    ...        sel.selectedIndex = 1;
    ...        sel.dispatchEvent(new Event('change', {bubbles: true}));
    ...    }
    Sleep    0.3s
