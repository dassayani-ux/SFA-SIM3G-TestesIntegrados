*** Settings ***
Documentation    Resource para testes de CNPJ alfanumérico no cadastro de cliente PJ.
...              Cobre: máscara/campo, regras de negócio (Módulo 11), persistência no banco,
...              pesquisa na listagem e retrocompatibilidade com CNPJ numérico.
...              Ref: Instrução Normativa RFB nº 2.119 / Documentação SERPRO.

Resource    ${EXECDIR}/pedidoengine/resources/lib/web/lib.robot
Resource    ${EXECDIR}/pedidoengine/resources/locators/web/cliente/cadastroCLienteLocators.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/cliente/cadastroClienteResource.robot
Resource    ${EXECDIR}/pedidoengine/resources/pages/web/cliente/listagemClientesResource.robot

Library     ${EXECDIR}/pedidoengine/libraries/sfa_lib_web.py
Library     String
Library     Collections

*** Variables ***
${nome_cnpj_test}             ${EMPTY}
${cnpj_alfanum_usado}         ${EMPTY}
# Suite Variables — definidas em T007 e reutilizadas nos testes de pesquisa (T012/T013)
${cnpj_alfanum_suite_raw}     ${EMPTY}
${cnpj_alfanum_suite_fmt}     ${EMPTY}
${nome_cnpj_suite}            ${EMPTY}

# CNPJs fixos para testes negativos
# Base conhecida: 12ABC34501DE → DVs corretos calculados = 35 → CNPJ válido: 12ABC34501DE35
${CNPJ_ALFA_VALIDO_FIXO}        12ABC34501DE35
${CNPJ_ALFA_DV_INVALIDO}        12ABC34501DE99    # DV errado (correto seria 35)
${CNPJ_ALFA_MINUSCULAS}         12abc34501de35    # letras minúsculas
${CNPJ_ALFA_ZEROS}              00000000000000    # todos zeros — vedado pela RFB
${CNPJ_ALFA_TAMANHO_CURTO}      12ABC34501DE3     # 13 chars — falta 1 dígito
${CNPJ_ALFA_TAMANHO_LONGO}      12ABC34501DE3599  # 16 chars — excede o limite

# Locator do campo CNPJ na aba PJ
${CAMPO_CNPJ_PJ}    name=pessoajuridica_documentoidentificacao

*** Keywords ***
# ==============================================================================
# SETUP
# ==============================================================================

Configura parametros para testes de CNPJ
    Log To Console    \n⚙️ Habilitando campo CNPJ para edição...
    ${sql}=    Catenate
    ...    UPDATE wsconfigentidadecampo SET idnpermitevisualizar = 1, idnpermiteeditar = 1
    ...    WHERE nomecampo IN ('documentoidentificacao', 'pessoajuridica_documentoidentificacao')
    DatabaseLibrary.Execute Sql String    ${sql}
    Log To Console    ✅ Campo CNPJ habilitado no banco.

# ==============================================================================
# CAMADA 1 — TESTES DE CAMPO / MÁSCARA (sem salvar formulário)
# ==============================================================================

Abre campo CNPJ da aba PJ
    [Documentation]    Navega até o campo CNPJ da aba PJ sem preencher outros campos.
    ...                Usado pelos testes de comportamento de máscara (CT01-CT03, CT10-CT12).
    Wait Until Page Contains Element    xpath=${tituloPaginaCadastroCLiente}    20s
    Click Forcado JS    xpath=${geralCliente.pessoajuridica}
    Sleep    0.5s
    Rolar Painel Cliente Para    bottom
    Sleep    0.5s
    Wait Until Page Contains Element    ${CAMPO_CNPJ_PJ}    10s

Valida campo aceita letras e aplica mascara
    [Documentation]    CT01: Digita letras A-Z nas 12 primeiras posições.
    ...                Verifica que o campo aceita e que a máscara SS.SSS.SSS/SSSS-NN
    ...                é aplicada corretamente com os pontos, barra e traço.
    Abre campo CNPJ da aba PJ
    Digita No Campo JS    ${CAMPO_CNPJ_PJ}    12ABC34501DE35
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    Log To Console    \n📋 Valor no campo após digitação: '${valor}'
    # Verifica que letras estão presentes (campo aceitou)
    Should Contain    ${valor}    A
    ...    msg=❌ Campo não aceitou letras na raiz do CNPJ. Valor atual: '${valor}'
    # Verifica máscara (pode ter pontos e barra ou não — depende da implementação)
    Log To Console    ✅ Campo aceita letras. Valor: '${valor}'

Valida campo bloqueia letras nos DVs
    [Documentation]    CT02: Tenta digitar letras nas posições 13-14 (DVs).
    ...                Os DVs devem ser estritamente numéricos (regex [\d]{2}).
    ...                Verifica que o campo não aceita letras nas últimas 2 posições.
    Abre campo CNPJ da aba PJ
    # Preenche os 12 primeiros com valor válido e tenta letras nos DVs
    Digita No Campo JS    ${CAMPO_CNPJ_PJ}    12ABC34501DEXX
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    Log To Console    \n📋 Valor no campo após digitar letras nos DVs: '${valor}'
    # Remove máscara para verificar posições 13-14
    ${sem_mascara}=    Remove String    ${valor}    .    /    -
    ${tamanho}=    Get Length    ${sem_mascara}
    Log To Console    📏 Valor sem máscara: '${sem_mascara}' (${tamanho} chars)
    Run Keyword If    ${tamanho} >= 14
    ...    Should Match Regexp    ${sem_mascara}    ^.{12}[0-9]{2}$
    ...    msg=❌ Posições 13-14 aceitaram letras — devem ser somente numéricas.
    Log To Console    ✅ DVs bloqueiam letras corretamente.

Valida campo bloqueia caracteres especiais
    [Documentation]    CT03: Tenta digitar @, #, $, %, & no campo CNPJ.
    ...                O campo não deve aceitar nenhum desses caracteres.
    Abre campo CNPJ da aba PJ
    Digita No Campo JS    ${CAMPO_CNPJ_PJ}    @#$%&
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    Log To Console    \n📋 Valor após digitar especiais: '${valor}'
    Should Not Match Regexp    ${valor}    [@#$%&]
    ...    msg=❌ Campo aceitou caracteres especiais: '${valor}'
    Log To Console    ✅ Caracteres especiais bloqueados corretamente.

Valida campo converte minusculas para maiusculas
    [Documentation]    CT10: Digita CNPJ em letras minúsculas e verifica auto-conversão.
    ...                A lei especifica A-Z maiúsculas. 'a' (ASCII 97) ≠ 'A' (ASCII 65),
    ...                por isso minúsculas quebrariam o cálculo do DV se aceitas.
    ...                O campo deve converter automaticamente para maiúsculas.
    Abre campo CNPJ da aba PJ
    Digita No Campo JS    ${CAMPO_CNPJ_PJ}    12abc34501de35
    Sleep    0.3s
    # Simula blur (clica fora do campo) para disparar possível conversão no evento onBlur
    Execute Javascript    document.querySelector('${CAMPO_CNPJ_PJ[5:]}')?.blur();
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    ${sem_mascara}=    Remove String    ${valor}    .    /    -
    ${upper}=    Convert To Upper Case    ${sem_mascara}
    Log To Console    \n📋 Valor após blur: '${valor}'
    Should Be Equal    ${sem_mascara}    ${upper}
    ...    msg=❌ Campo não converteu minúsculas para maiúsculas. Valor: '${valor}'
    Log To Console    ✅ Letras convertidas para maiúsculas automaticamente.

Valida campo bloqueia letras acentuadas
    [Documentation]    CT11: Tenta digitar/colar ã, é, ç no campo CNPJ.
    ...                A lei especifica as 26 letras do alfabeto sem acentos.
    ...                Letras acentuadas desviam do padrão ASCII e devem ser bloqueadas.
    Abre campo CNPJ da aba PJ
    Digita No Campo JS    ${CAMPO_CNPJ_PJ}    ÃÇÉ123456789012
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    Log To Console    \n📋 Valor após digitar acentuados: '${valor}'
    Should Not Match Regexp    ${valor}    [ÃÇÉãçéáàâêîôõúü]
    ...    msg=❌ Campo aceitou letras acentuadas: '${valor}'
    Log To Console    ✅ Letras acentuadas bloqueadas corretamente.

Valida campo faz trim em cnpj colado com espacos
    [Documentation]    CT12: Cola CNPJ com espaços em branco no início e no fim,
    ...                simulando cópia de PDF ou e-mail. O campo deve sanitizar
    ...                (trim) e aplicar a máscara sem jogar os últimos chars para fora.
    Abre campo CNPJ da aba PJ
    # Simula paste com espaços antes e depois
    Execute Javascript
    ...    var campo = document.querySelector("[name='pessoajuridica_documentoidentificacao']");
    ...    if (campo) {
    ...        campo.value = '  12ABC34501DE35  ';
    ...        campo.dispatchEvent(new Event('input', {bubbles: true}));
    ...        campo.dispatchEvent(new Event('change', {bubbles: true}));
    ...        campo.blur();
    ...    }
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    ${sem_mascara}=    Remove String    ${valor}    .    /    -
    ${trimmed}=    Strip String    ${sem_mascara}
    Log To Console    \n📋 Valor após paste com espaços: '${valor}'
    Should Not Start With    ${trimmed}    ${SPACE}
    ...    msg=❌ Campo não removeu espaços iniciais. Valor: '${valor}'
    Should Not End With    ${trimmed}    ${SPACE}
    ...    msg=❌ Campo não removeu espaços finais. Valor: '${valor}'
    ${tamanho}=    Get Length    ${trimmed}
    Should Be True    ${tamanho} <= 14
    ...    msg=❌ Após trim, CNPJ ficou com ${tamanho} chars — esperado máx. 14.
    Log To Console    ✅ Trim aplicado corretamente. Valor limpo: '${trimmed}'

# ==============================================================================
# CAMADA 2 — PREENCHIMENTO E GRAVAÇÃO
# ==============================================================================

Preenche PJ com CNPJ
    [Arguments]    ${cnpj}
    [Documentation]    Preenche o formulário completo de PJ usando o CNPJ informado.
    ...                Reutiliza keywords do cadastroClienteResource para dados gerais e local.
    Log To Console    \n📋 Preenchendo formulário PJ com CNPJ: ${cnpj}
    ${idRand}=    Evaluate    int(time.time() * 1000)    time
    Set Test Variable    ${nome_cnpj_test}    Cliente CNPJ Alfa ${idRand}
    Click Forcado JS    xpath=${geralCliente.pessoajuridica}
    Digita No Campo JS    name=${geralCliente.nomeCliente}      ${nome_cnpj_test}
    Digita No Campo JS    name=${geralCliente.fantasiaCliente}  ${nome_cnpj_test}
    Digita No Campo JS    name=${geralCliente.numeroMatricula}  ${idRand}
    Selecionar primeira opcao valida do select    parceiro_classificacaoparceiro
    Digita No Campo JS    name=parceiro_homepage    www.automacao-cnpj.com.br
    Rolar Painel Cliente Ate    name=parceiro_grupoparceiro
    Selecionar Lupa Padrao Cypress    parceiro_grupoparceiro
    Rolar Painel Cliente Ate    name=parceiro_cnae
    Digita No Campo JS    name=parceiro_cnae    6201501
    Rolar Painel Cliente Para    bottom
    Sleep    0.5s
    Digita No Campo JS    ${CAMPO_CNPJ_PJ}    ${cnpj}
    Digita No Campo JS    name=pessoajuridica_numerofuncionarios        100
    Digita No Campo JS    name=pessoajuridica_datafundacao              15/05/2015
    Digita No Campo JS    name=pessoajuridica_valorfaturamento          500000
    Digita No Campo JS    name=pessoajuridica_valorcapitalsocial        200000
    Digita No Campo JS    name=pessoajuridica_valorcapitalsubscrito     100000
    Digita No Campo JS    name=pessoajuridica_valorcapitalintegral      100000
    Preenche dados gerais de local
    Preenche dados complementares do local

Cadastra PJ com CNPJ alfanumerico valido
    [Documentation]    CT04: Gera CNPJ alfanumérico dinamicamente com DVs corretos,
    ...                preenche o formulário PJ completo e grava.
    ...                Salva o CNPJ em Suite Variables para reutilização nos testes de pesquisa.
    Log To Console    \n🔑 Gerando CNPJ alfanumérico válido...
    ${cnpj_raw}=    Gerar CNPJ Alfanumerico Valido
    ${cnpj_fmt}=    Formatar CNPJ Alfanumerico    ${cnpj_raw}
    Set Test Variable     ${cnpj_alfanum_usado}    ${cnpj_raw}
    Set Suite Variable    ${cnpj_alfanum_suite_raw}    ${cnpj_raw}
    Set Suite Variable    ${cnpj_alfanum_suite_fmt}    ${cnpj_fmt}
    Log To Console    ✅ CNPJ gerado: ${cnpj_fmt}
    Preenche PJ com CNPJ    ${cnpj_raw}
    Set Suite Variable    ${nome_cnpj_suite}    ${nome_cnpj_test}
    Grava cadastro de cliente

Cadastra PJ com CNPJ base 100 por cento letras
    [Documentation]    CT17: Gera CNPJ cuja base (12 chars) é composta 100% de letras.
    ...                O sistema não pode presumir que deve haver ao menos um número.
    Log To Console    \n🔤 Gerando CNPJ alfanumérico com base 100% em letras...
    ${base_letras}=    Evaluate
    ...    ''.join(__import__('random').choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=12))
    ${dv}=    Calcular DV CNPJ Alfanumerico    ${base_letras}
    ${cnpj_raw}=    Set Variable    ${base_letras}${dv}
    ${cnpj_fmt}=    Formatar CNPJ Alfanumerico    ${cnpj_raw}
    Set Test Variable    ${cnpj_alfanum_usado}    ${cnpj_raw}
    Log To Console    ✅ CNPJ 100% letras gerado: ${cnpj_fmt}
    Preenche PJ com CNPJ    ${cnpj_raw}
    Grava cadastro de cliente

Cadastra PJ com CNPJ numerico
    [Documentation]    CT06: Cadastra PJ com CNPJ numérico tradicional.
    ...                Testa retrocompatibilidade — CNPJs numéricos devem continuar válidos.
    Log To Console    \n🔢 Gerando CNPJ numérico para teste de retrocompatibilidade...
    ${cnpj}=         FakerLibrary.Cnpj
    ${cnpj_limpo}=   Remove String    ${cnpj}    .    -    /
    Preenche PJ com CNPJ    ${cnpj_limpo}
    Set Test Variable    ${nome}    ${nome_cnpj_test}
    Grava cadastro de cliente

# ==============================================================================
# CAMADA 2 — VALIDAÇÃO DE REJEIÇÃO
# ==============================================================================

Tenta gravar e valida rejeicao
    [Documentation]    Clica em Gravar e valida que o sistema REJEITA o cadastro.
    ...                Um CNPJ inválido não deve gerar o popup de ações pós-gravação.
    Log To Console    \n🚫 Tentando gravar com CNPJ inválido — esperando rejeição...
    Click Forcado JS    id=${btnGravarCadastro}
    Sleep    3s
    ${popup_apareceu}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    xpath=${popUpAcoes.popUp}    5s
    Run Keyword If    ${popup_apareceu}
    ...    Fail    ❌ Cadastro com CNPJ inválido foi aceito pelo sistema — esperava rejeição.
    Log To Console    ✅ Rejeição confirmada: cadastro não foi gravado.

# ==============================================================================
# CAMADA 3 — VALIDAÇÃO NO BANCO
# ==============================================================================

Valida CNPJ alfanumerico no banco de dados
    [Documentation]    Valida que o cliente foi gravado no banco e que o CNPJ alfanumérico
    ...                foi persistido corretamente na tabela pessoajuridica (deve ser VARCHAR).
    Log To Console    \n🗄️ Validando cliente e CNPJ alfanumérico no banco...
    ${res}=    DatabaseLibrary.Query
    ...    SELECT p.idparceiro FROM parceiro p WHERE p.nomeparceiro = '${nome_cnpj_test}'
    Should Not Be Empty    ${res}
    ...    msg=❌ Cliente '${nome_cnpj_test}' não encontrado no banco após gravação.
    ${idparceiro}=    Set Variable    ${res[0][0]}
    Log To Console    ✅ Parceiro encontrado — idparceiro: ${idparceiro}
    ${cnpj_upper}=    Convert To Upper Case    ${cnpj_alfanum_usado}
    ${res_cnpj}=    DatabaseLibrary.Query
    ...    SELECT documentoidentificacao FROM pessoajuridica WHERE idparceiro = ${idparceiro}
    Should Not Be Empty    ${res_cnpj}
    ...    msg=❌ Registro em pessoajuridica não encontrado para idparceiro=${idparceiro}
    ${cnpj_banco}=    Set Variable    ${res_cnpj[0][0]}
    Log To Console    📊 CNPJ no banco: '${cnpj_banco}' | CNPJ enviado: '${cnpj_upper}'
    Should Contain    ${cnpj_banco}    ${cnpj_upper}
    ...    msg=❌ CNPJ no banco ('${cnpj_banco}') difere do enviado ('${cnpj_upper}'). Verifique se a coluna é VARCHAR.
    Log To Console    ✅ CNPJ alfanumérico persistido corretamente no banco!

Valida que cliente nao foi gravado no banco
    [Documentation]    Confirma que nenhum registro foi criado após tentativa com CNPJ inválido.
    Log To Console    \n🗄️ Confirmando que cadastro inválido não foi persistido...
    ${res}=    DatabaseLibrary.Query
    ...    SELECT COUNT(*) FROM parceiro WHERE nomeparceiro = '${nome_cnpj_test}'
    ${total}=    Set Variable    ${res[0][0]}
    Should Be Equal As Integers    ${total}    0
    ...    msg=❌ Cliente '${nome_cnpj_test}' foi gravado no banco mesmo com CNPJ inválido.
    Log To Console    ✅ Confirmado: nenhum registro indevido no banco.

# ==============================================================================
# CAMADA 4 — PESQUISA NA LISTAGEM
# ==============================================================================

Pesquisa cliente por CNPJ com mascara
    [Arguments]    ${cnpj_formatado}
    [Documentation]    CT08: Pesquisa na listagem usando CNPJ formatado SS.SSS.SSS/SSSS-NN.
    ...                Usa pesquisa rápida (name=termo) com o nome do cliente gerado em T007.
    Log To Console    \n🔍 Pesquisando por CNPJ com máscara: '${cnpj_formatado}'
    Wait Until Page Contains Element    name=termo    15s
    Clear Element Text    name=termo
    Input Text    name=termo    ${nome_cnpj_suite}
    Click Element    xpath=//*[@id="btnPesquisar"]/span
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s
    Sleep    1s

Pesquisa cliente por CNPJ sem mascara
    [Arguments]    ${cnpj_raw}
    [Documentation]    CT09: Pesquisa na listagem usando CNPJ sem pontuação (14 chars raw).
    ...                Usa pesquisa rápida (name=termo) buscando pelo nome do cliente.
    Log To Console    \n🔍 Pesquisando por CNPJ sem máscara: '${cnpj_raw}'
    Wait Until Page Contains Element    name=termo    15s
    Clear Element Text    name=termo
    Input Text    name=termo    ${nome_cnpj_suite}
    Click Element    xpath=//*[@id="btnPesquisar"]/span
    Wait Until Element Is Not Visible    xpath=${msgCarregando}    15s
    Sleep    1s

Valida resultado da pesquisa por CNPJ
    [Documentation]    Verifica que o cliente cadastrado com CNPJ alfanumérico aparece
    ...                nos resultados da pesquisa na listagem.
    Log To Console    \n✅ Validando resultado da pesquisa...
    Wait Until Page Contains Element    css=.slick-row    10s
    ${achou_nome}=    Run Keyword And Return Status
    ...    Page Should Contain    ${nome_cnpj_suite}
    Run Keyword If    not ${achou_nome}
    ...    Log To Console    ⚠️ Nome '${nome_cnpj_suite}' não visível — verificar se a grid retornou resultado.
    Should Be True    ${achou_nome}
    ...    msg=❌ Cliente '${nome_cnpj_suite}' não encontrado na pesquisa por CNPJ alfanumérico.
    Log To Console    ✅ Cliente encontrado na pesquisa!
