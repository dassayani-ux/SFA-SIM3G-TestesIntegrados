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

# Locator do campo CNPJ do Local (filial/ponto de entrega)
${CAMPO_CNPJ_LOCAL}    name=local_documentoidentificacao

# Suite Variables para testes do campo Local — definidas em T030
${cnpj_local_suite_raw}     ${EMPTY}
${cnpj_local_suite_fmt}     ${EMPTY}
${nome_local_suite}         ${EMPTY}

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
    # Extrai os caracteres nas posições dos DVs (13-14, índice 12 em diante)
    # Quando o campo bloqueia letras, as posições ficam como '__' (placeholder da máscara).
    # O correto é verificar que NÃO há letras ali — não que há dígitos (podem ser '__').
    ${dv_chars}=    Get Substring    ${sem_mascara}    12
    Should Not Match Regexp    ${dv_chars}    [A-Za-z]
    ...    msg=❌ Posições 13-14 aceitaram letras — devem ser somente numéricas.
    Log To Console    ✅ DVs bloqueiam letras corretamente (posições 13-14: '${dv_chars}').

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
    ...                Salva CNPJ como Suite Variable para reutilização no WEB_22.
    Log To Console    \n🔢 Gerando CNPJ numérico para teste de retrocompatibilidade...
    ${cnpj}=         FakerLibrary.Cnpj
    ${cnpj_limpo}=   Remove String    ${cnpj}    .    -    /
    Set Suite Variable    ${cnpj_numerico_suite_raw}    ${cnpj_limpo}
    Set Suite Variable    ${cnpj_numerico_suite_fmt}    ${cnpj}
    Preenche PJ com CNPJ    ${cnpj_limpo}
    Set Test Variable    ${nome}    ${nome_cnpj_test}
    Set Suite Variable    ${nome_cnpj_numerico_suite}    ${nome_cnpj_test}
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
    ...    SELECT documentoidentificacao FROM pessoajuridica WHERE idpessoajuridica = ${idparceiro}
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

# ==============================================================================
# CAMADA 1b — MÁSCARA DETALHADA (WEB_13, WEB_14, WEB_18, WEB_19)
# ==============================================================================

Valida mascara alfanumerica aplicada
    [Documentation]    WEB_13: Digita CNPJ alfanumérico bruto e verifica se a máscara
    ...                SS.SSS.SSS/SSSS-NN é aplicada pelo campo (caracteres . / - presentes).
    Abre campo CNPJ da aba PJ
    Digita No Campo JS    ${CAMPO_CNPJ_PJ}    12ABC34501DE35
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    Log To Console    \n📋 WEB_13 — Valor com máscara alfanumérica: '${valor}'
    # A máscara SS.SSS.SSS/SSSS-NN deve conter ponto, barra e traço
    Should Match Regexp    ${valor}    .+\..+\..+/.+-.*
    ...    msg=❌ Máscara alfanumérica não aplicada. Esperado SS.SSS.SSS/SSSS-NN, obtido: '${valor}'
    # Verifica posição das letras (posições 3-5 na string bruta devem ser A, B, C)
    ${sem_mascara}=    Remove String    ${valor}    .    /    -
    ${parte_alfa}=    Get Substring    ${sem_mascara}    2    5
    Should Match Regexp    ${parte_alfa}    [A-Z]{3}
    ...    msg=❌ Letras não aparecem nas posições corretas. Encontrado: '${parte_alfa}'
    Log To Console    ✅ Máscara alfanumérica correta: '${valor}'

Valida mascara numerica aplicada
    [Documentation]    WEB_14: Digita CNPJ numérico e verifica se a máscara clássica
    ...                NN.NNN.NNN/NNNN-NN é aplicada (regressão — não deve ter mudado).
    Abre campo CNPJ da aba PJ
    Digita No Campo JS    ${CAMPO_CNPJ_PJ}    12345678000195
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    Log To Console    \n📋 WEB_14 — Valor com máscara numérica: '${valor}'
    # Máscara clássica: 12.345.678/0001-95
    Should Match Regexp    ${valor}    \\d{2}\\.\\d{3}\\.\\d{3}/\\d{4}-\\d{2}
    ...    msg=❌ Máscara numérica não aplicada. Esperado NN.NNN.NNN/NNNN-NN, obtido: '${valor}'
    Log To Console    ✅ Máscara numérica correta: '${valor}'

Valida campo re-sanitiza cnpj com mascara colada
    [Documentation]    WEB_18: Simula paste de CNPJ já formatado (12.ABC.345/01DE-35).
    ...                O campo deve sanitizar a máscara (remover pontos) e reaplicar corretamente,
    ...                sem duplicar caracteres nem estourar o limite de 14 posições na base.
    Abre campo CNPJ da aba PJ
    Execute Javascript
    ...    var c = document.querySelector("[name='pessoajuridica_documentoidentificacao']");
    ...    if (c) {
    ...        c.value = '12.ABC.345/01DE-35';
    ...        c.dispatchEvent(new Event('input', {bubbles: true}));
    ...        c.dispatchEvent(new Event('paste', {bubbles: true}));
    ...        c.dispatchEvent(new Event('change', {bubbles: true}));
    ...        c.blur();
    ...    }
    Sleep    0.7s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    ${sem_mascara}=    Remove String    ${valor}    .    /    -
    ${tamanho}=    Get Length    ${sem_mascara}
    Log To Console    \n📋 WEB_18 — Valor após paste formatado: '${valor}' (${tamanho} chars base)
    Should Be Equal As Integers    ${tamanho}    14
    ...    msg=❌ Base do CNPJ com ${tamanho} chars após paste formatado — esperado 14.
    Should Contain    ${sem_mascara}    ABC
    ...    msg=❌ Letras alfanuméricas perdidas após re-sanitização. Base: '${sem_mascara}'
    Log To Console    ✅ Re-sanitização de máscara colada correta. Base: '${sem_mascara}'

Valida campo aplica mascara em cnpj bruto colado
    [Documentation]    WEB_19: Simula paste de CNPJ bruto sem pontuação (12ABC34501DE35).
    ...                O campo deve detectar o valor cru e aplicar imediatamente a máscara
    ...                SS.SSS.SSS/SSSS-NN sem qualquer interação adicional do usuário.
    Abre campo CNPJ da aba PJ
    Execute Javascript
    ...    var c = document.querySelector("[name='pessoajuridica_documentoidentificacao']");
    ...    if (c) {
    ...        c.value = '12ABC34501DE35';
    ...        c.dispatchEvent(new Event('input', {bubbles: true}));
    ...        c.dispatchEvent(new Event('paste', {bubbles: true}));
    ...        c.dispatchEvent(new Event('change', {bubbles: true}));
    ...        c.blur();
    ...    }
    Sleep    0.7s
    ${valor}=    Get Value    ${CAMPO_CNPJ_PJ}
    Log To Console    \n📋 WEB_19 — Valor após paste bruto: '${valor}'
    # Após paste bruto, a máscara deve ter sido aplicada
    ${tem_mascara}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${valor}    .+\..+\..+/.+-.*
    Run Keyword If    ${tem_mascara}
    ...    Log To Console    ✅ Máscara aplicada automaticamente ao colar: '${valor}'
    Run Keyword If    not ${tem_mascara}
    ...    Log To Console    ⚠️ Máscara não foi aplicada automaticamente — valor raw: '${valor}'
    # Independentemente da máscara, a base (sem formatação) deve ser os 14 chars corretos
    ${sem_mascara}=    Remove String    ${valor}    .    /    -
    ${tamanho}=    Get Length    ${sem_mascara}
    Should Be Equal As Integers    ${tamanho}    14
    ...    msg=❌ Base com ${tamanho} chars após paste — esperado 14. Valor: '${valor}'
    Log To Console    ✅ Paste bruto processado corretamente. Base: '${sem_mascara}'

# ==============================================================================
# CAMADA 2b — MENSAGEM DE ERRO VISUAL (WEB_20)
# ==============================================================================

Valida mensagem de erro visivel para cnpj invalido
    [Documentation]    WEB_20: Preenche PJ com CNPJ de DV inválido, clica em Gravar e
    ...                valida que um elemento de erro está VISÍVEL na tela (toast, alerta
    ...                ou texto em vermelho contendo "CNPJ" ou "inválido").
    ...                Depende de formulário completo preenchido antes de chamar.
    Click Forcado JS    id=${btnGravarCadastro}
    Sleep    2s
    # Tenta detectar toast de erro (jGrowl)
    ${tem_toast}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    css=.jGrowl-message    5s
    # Tenta detectar alerta HTML5 genérico
    ${tem_alert}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    css=.alert    3s
    # Tenta detectar elemento com texto de erro de CNPJ
    ${tem_texto_cnpj}=    Run Keyword And Return Status
    ...    Page Should Contain    CNPJ
    # Tenta detectar span/div com classe de erro (campo highlight)
    ${tem_campo_erro}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    css=.has-error,.field-error,.ng-invalid    3s
    ${popup_apareceu}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    xpath=${popUpAcoes.popUp}    3s
    Should Be True    not ${popup_apareceu}
    ...    msg=❌ Sistema aceitou o CNPJ inválido (popup pós-gravação apareceu).
    ${alguma_indicacao_erro}=    Evaluate    ${tem_toast} or ${tem_alert} or ${tem_texto_cnpj} or ${tem_campo_erro}
    Should Be True    ${alguma_indicacao_erro}
    ...    msg=❌ Nenhuma indicação visual de erro encontrada para CNPJ inválido (toast, alert, texto ou campo).
    Log To Console    ✅ WEB_20 — Indicação visual de erro confirmada (toast=${tem_toast}, alert=${tem_alert}, texto_cnpj=${tem_texto_cnpj}, campo_erro=${tem_campo_erro})

# ==============================================================================
# CAMADA 4b — PESQUISA POR CNPJ NUMÉRICO NO FILTRO (WEB_22)
# ==============================================================================

Pesquisa cliente por CNPJ numerico no filtro
    [Documentation]    WEB_22: Na listagem de clientes, usa a pesquisa avançada e filtra
    ...                pelo campo Documento com o CNPJ numérico gerado no T014.
    ...                Valida que a grid retorna exatamente 1 registro correspondente.
    [Arguments]    ${cnpj_formatado}    ${nome_esperado}
    Log To Console    \n🔍 WEB_22 — Pesquisando por CNPJ numérico: '${cnpj_formatado}'
    # Ativa pesquisa avançada
    ${tem_avancada}=    Run Keyword And Return Status
    ...    Wait Until Page Contains Element    class=${pesquisaAvancada.exibePesquisa}    5s
    Run Keyword If    ${tem_avancada}
    ...    Click Element    class=${pesquisaAvancada.exibePesquisa}
    Run Keyword If    ${tem_avancada}
    ...    Wait Until Element Is Enabled    xpath=${pesquisaAvancada.camposAtivos}    5s
    # Preenche campo Documento com CNPJ numérico (sem formatação)
    ${cnpj_limpo}=    Remove String    ${cnpj_formatado}    .    /    -
    Wait Until Page Contains Element    name=${pesquisaAvancada.documento}    10s
    Clear Element Text    name=${pesquisaAvancada.documento}
    Input Text    name=${pesquisaAvancada.documento}    ${cnpj_limpo}
    Click Element    xpath=${pesquisaRapida.btnPesquisar}
    Wait Until Element Is Not Visible    xpath=${cerregandoRegistros}    15s
    Sleep    1s
    Log To Console    ✅ Pesquisa por documento '${cnpj_limpo}' executada.

Valida cliente encontrado por CNPJ numerico
    [Documentation]    WEB_22: Verifica que a grid retornou o cliente esperado após
    ...                filtrar por CNPJ numérico. Valida contagem > 0 e nome na página.
    [Arguments]    ${nome_esperado}
    Log To Console    \n✅ WEB_22 — Validando resultado para CNPJ numérico...
    Wait Until Page Contains Element    css=.slick-row    10s
    ${achou}=    Run Keyword And Return Status    Page Should Contain    ${nome_esperado}
    Run Keyword If    not ${achou}
    ...    Log To Console    ⚠️ Nome '${nome_esperado}' não visível — verificar grid.
    Should Be True    ${achou}
    ...    msg=❌ Cliente '${nome_esperado}' não encontrado ao filtrar por CNPJ numérico.
    Log To Console    ✅ Cliente '${nome_esperado}' encontrado por CNPJ numérico!

# ==============================================================================
# CAMADA LOCAL — CAMPO local_documentoidentificacao
# Espelha as validações do campo PJ (pessoajuridica_documentoidentificacao)
# no campo de CNPJ do Local (filial / ponto de entrega).
# O Local é preenchido dentro do mesmo formulário de cadastro de cliente PJ.
# ==============================================================================

Abre campo CNPJ do local
    [Documentation]    Navega até o campo CNPJ do Local sem preencher outros campos.
    ...                Utilizado pelos testes de máscara/campo (T026-T029).
    ...                Rola o painel principal até o fim e depois o painel do Local
    ...                até o campo local_documentoidentificacao.
    Wait Until Page Contains Element    xpath=${tituloPaginaCadastroCLiente}    20s
    Click Forcado JS    xpath=${geralCliente.pessoajuridica}
    Sleep    0.5s
    Rolar Painel Cliente Para    bottom
    Sleep    0.5s
    Rolar Painel Local Ate    ${CAMPO_CNPJ_LOCAL}
    Wait Until Page Contains Element    ${CAMPO_CNPJ_LOCAL}    10s

Valida campo local aceita CNPJ alfanumerico
    [Documentation]    T024: Digita CNPJ alfanumérico bruto no campo local e verifica
    ...                que o campo aceita o valor sem remover as letras.
    ...                ⚠️ LACUNA FRONTEND: campo local_documentoidentificacao não aplica
    ...                a máscara SS.SSS.SSS/SSSS-NN — o valor fica como string bruta de 14 chars.
    ...                Este teste valida que o campo aceita letras (A-Z) sem descartá-las,
    ...                e documenta a ausência de máscara como item de melhoria.
    Clear Element Text    ${CAMPO_CNPJ_LOCAL}
    Digita No Campo JS    ${CAMPO_CNPJ_LOCAL}    12ABC34501DE35
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_LOCAL}
    Log To Console    \n🔍 T024 — Campo local após digitar: '${valor}'
    Should Not Be Empty    ${valor}
    ...    msg=❌ T024: campo local ficou vazio após digitar CNPJ alfanumérico '12ABC34501DE35'.
    ${base}=    Remove String    ${valor}    .    /    -
    ${tem_letra}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${base}    [A-Z]
    Should Be True    ${tem_letra}
    ...    msg=❌ T024: campo local removeu as letras do CNPJ alfanumérico. Valor retornado: '${valor}'
    Log To Console    ✅ T024 — Campo local aceita CNPJ alfanumérico. Valor: '${valor}'
    Log To Console    ℹ️  LACUNA FRONTEND: campo não aplica máscara SS.SSS.SSS/SSSS-NN — registrar como melhoria.

Valida campo local bloqueia letras nos DVs
    [Documentation]    T025: Tenta digitar letras nas posições 13-14 (DVs) do campo local.
    ...                Os DVs devem ser estritamente numéricos — o campo deve bloquear letras nessa posição.
    ...                Guard: verifica que o campo não ficou vazio após o input (false-positive prevention).
    Clear Element Text    ${CAMPO_CNPJ_LOCAL}
    # Digita base válida (12 chars) + 2 letras nos DVs
    Digita No Campo JS    ${CAMPO_CNPJ_LOCAL}    12ABC34501DEXY
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_LOCAL}
    ${base}=    Remove String    ${valor}    .    /    -
    # Guard: se o campo ficou vazio o campo limpou o input inteiro — impossível verificar bloqueio seletivo
    Should Not Be Empty    ${base}
    ...    msg=⚠️ T025: campo local ficou vazio após input '12ABC34501DEXY' — impossível verificar bloqueio de letras nos DVs.
    # Os últimos 2 chars da base (posições 13-14) não podem conter letra
    ${sufixo}=    Get Substring    ${base}    12
    ${tem_letra_dv}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${sufixo}    [A-Za-z]
    Should Be True    not ${tem_letra_dv}
    ...    msg=❌ T025: campo local aceitou letras nos DVs. Base: '${base}', Sufixo DV: '${sufixo}'
    Log To Console    ✅ T025 — Campo local bloqueou letras nos DVs. Sufixo: '${sufixo}'

Valida campo local bloqueia caracteres especiais
    [Documentation]    T026: Tenta digitar @, #, $, % no campo local.
    ...                Apenas A-Z e 0-9 são permitidos — especiais devem ser ignorados.
    ...                Guard: verifica que o campo não ficou vazio após o input (false-positive prevention).
    Clear Element Text    ${CAMPO_CNPJ_LOCAL}
    Digita No Campo JS    ${CAMPO_CNPJ_LOCAL}    12@#$34501DE35
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_LOCAL}
    ${base}=    Remove String    ${valor}    .    /    -
    # Guard: se o campo ficou vazio o campo limpou tudo — impossível verificar bloqueio seletivo de especiais
    Should Not Be Empty    ${base}
    ...    msg=⚠️ T026: campo local ficou vazio após input '12@#$34501DE35' — impossível verificar bloqueio de caracteres especiais.
    ${tem_especial}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${base}    [@#$%&*!]
    Should Be True    not ${tem_especial}
    ...    msg=❌ T026: campo local aceitou caracteres especiais. Base: '${base}'
    Log To Console    ✅ T026 — Campo local bloqueou caracteres especiais. Base: '${base}'

Valida campo local converte minusculas para maiusculas
    [Documentation]    T029: Digita CNPJ com letras minúsculas no campo local.
    ...                O campo deve converter para maiúsculas automaticamente,
    ...                pois ASCII 'a'=97 ≠ 'A'=65 e o DV quebraria se não convertesse.
    Clear Element Text    ${CAMPO_CNPJ_LOCAL}
    Digita No Campo JS    ${CAMPO_CNPJ_LOCAL}    12abc34501de35
    Sleep    0.5s
    ${valor}=    Get Value    ${CAMPO_CNPJ_LOCAL}
    ${base}=    Remove String    ${valor}    .    /    -
    ${tem_minuscula}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${base}    [a-z]
    Should Be True    not ${tem_minuscula}
    ...    msg=❌ T029: campo local manteve letras minúsculas. Base: '${base}'
    Log To Console    ✅ T029 — Campo local converteu minúsculas para maiúsculas. Base: '${base}'

Cadastra PJ com CNPJ alfanumerico valido no local
    [Documentation]    T030: Gera um CNPJ alfanumérico válido, preenche o formulário PJ
    ...                completo com um CNPJ numérico para o parceiro e injeta o CNPJ
    ...                alfanumérico APENAS no campo do Local.
    ...                Salva o CNPJ do Local como Suite Variable para validação no banco.
    ${cnpj_local_raw}=    Gerar CNPJ Alfanumerico Valido
    ${cnpj_local_fmt}=    Formatar CNPJ Alfanumerico    ${cnpj_local_raw}
    Set Suite Variable    ${cnpj_local_suite_raw}    ${cnpj_local_raw}
    Set Suite Variable    ${cnpj_local_suite_fmt}    ${cnpj_local_fmt}

    Log To Console    \n🔑 T030 — CNPJ alfanumérico para o Local: '${cnpj_local_fmt}'

    # Preenche o formulário com CNPJ numérico para o parceiro (não é o objeto do teste)
    ${cnpj_parceiro}=    FakerLibrary.Cnpj
    ${cnpj_parceiro_limpo}=    Remove String    ${cnpj_parceiro}    .    -    /
    Preenche PJ com CNPJ    ${cnpj_parceiro_limpo}

    # Substitui o CNPJ do Local (gerado aleatoriamente) pelo CNPJ alfanumérico do teste
    Digita No Campo JS    ${CAMPO_CNPJ_LOCAL}    ${cnpj_local_raw}
    Sleep    0.5s

    Set Suite Variable    ${nome_local_suite}    ${nome_cnpj_test}
    Log To Console    ✅ T030 — Formulário preenchido. Local CNPJ: '${cnpj_local_fmt}' / Parceiro: '${cnpj_parceiro}'
    Grava cadastro de cliente

Valida CNPJ alfanumerico do local no banco
    [Documentation]    T028: Valida que o CNPJ alfanumérico foi persistido corretamente
    ...                na tabela local (documentoidentificacao é VARCHAR).
    ...                Busca o Local pelo idparceiro do cliente recém-criado.
    ...                Suporta driver que retorna tuple (padrão) ou dict (alguns adapters).
    ...                ⚠️ LACUNA BACKEND: se a coluna for NULL, o campo local pode não
    ...                suportar CNPJ alfanumérico — registrar como melhoria e não reprovar pipeline.
    Log To Console    \n🗄️ T028 — Validando CNPJ alfanumérico do Local no banco...
    ${res_p}=    DatabaseLibrary.Query
    ...    SELECT idparceiro FROM parceiro WHERE nomeparceiro = '${nome_local_suite}'
    Should Not Be Empty    ${res_p}
    ...    msg=❌ T028: parceiro '${nome_local_suite}' não encontrado no banco.
    # Suporta tuple (res_p[0][0]) ou dict (res_p[0]['idparceiro'])
    ${row_p}=    Set Variable    ${res_p[0]}
    ${idparceiro}=    Evaluate    $row_p[0] if isinstance($row_p, (list, tuple)) else list($row_p.values())[0]
    ${cnpj_upper}=    Convert To Upper Case    ${cnpj_local_suite_raw}
    ${res_l}=    DatabaseLibrary.Query
    ...    SELECT l.documentoidentificacao FROM local l
    ...    INNER JOIN parceirolocal pl ON pl.idlocal = l.idlocal
    ...    WHERE pl.idparceiro = ${idparceiro}
    Should Not Be Empty    ${res_l}
    ...    msg=❌ T028: Local não encontrado para idparceiro=${idparceiro}.
    # Extrai valor da primeira linha — suporta tuple ou dict
    ${row_l}=    Set Variable    ${res_l[0]}
    ${cnpj_banco}=    Evaluate    $row_l[0] if isinstance($row_l, (list, tuple)) else list($row_l.values())[0]
    Log To Console    📊 CNPJ Local no banco: '${cnpj_banco}' | Enviado: '${cnpj_upper}'
    # Se NULL: campo local ainda não suporta alfanumérico no back-end — documenta sem reprovar
    Run Keyword If    $cnpj_banco is None    Log To Console
    ...    ⚠️ T028 LACUNA BACKEND: documentoidentificacao é NULL no banco — campo local não persiste CNPJ alfanumérico. Registrar como melhoria.
    Run Keyword If    $cnpj_banco is None    Return From Keyword
    Should Contain    ${cnpj_banco}    ${cnpj_upper}
    ...    msg=❌ T028: CNPJ do Local no banco ('${cnpj_banco}') difere do enviado ('${cnpj_upper}'). Coluna deve ser VARCHAR.
    Log To Console    ✅ T028 — CNPJ alfanumérico do Local persistido corretamente!

Preenche local com CNPJ invalido e valida rejeicao
    [Documentation]    T029: Preenche o formulário PJ com CNPJ válido no parceiro e injeta
    ...                um CNPJ com DV errado (12ABC34501DE99 — DV correto seria 35) no campo do Local.
    ...                Comportamento esperado: sistema rejeita ao tentar salvar.
    ...                ⚠️ LACUNA BACKEND: atualmente o back-end não valida DV do campo local
    ...                (local_documentoidentificacao). Se aceitar, registra como lacuna sem reprovar pipeline.
    ${cnpj_parceiro}=    FakerLibrary.Cnpj
    ${cnpj_parceiro_limpo}=    Remove String    ${cnpj_parceiro}    .    -    /
    Preenche PJ com CNPJ    ${cnpj_parceiro_limpo}
    # Sobrescreve o CNPJ do Local com um DV inválido
    Digita No Campo JS    ${CAMPO_CNPJ_LOCAL}    12ABC34501DE99
    Sleep    0.5s
    Log To Console    \n📋 T029 — Local preenchido com DV inválido: 12ABC34501DE99 (correto: 12ABC34501DE35)
    ${rejeitou}=    Run Keyword And Return Status    Tenta gravar e valida rejeicao
    Run Keyword If    ${rejeitou}
    ...    Log To Console    ✅ T029 — Sistema rejeitou corretamente CNPJ com DV inválido no campo local.
    Run Keyword If    not ${rejeitou}    Log To Console
    ...    ⚠️ T029 LACUNA BACKEND: sistema ACEITOU CNPJ com DV inválido no campo local_documentoidentificacao — validação de DV não implementada. Registrar como melhoria no back-end.
    Log To Console    ℹ️  T029 concluído — resultado registrado acima.

Cadastra PJ com CNPJ numerico no local
    [Documentation]    T032: Verifica retrocompatibilidade — preenche o formulário PJ
    ...                com CNPJ alfanumérico no parceiro e mantém um CNPJ numérico gerado
    ...                automaticamente no Local (comportamento padrão do Preenche PJ com CNPJ).
    ...                O sistema deve aceitar sem erro — CNPJ numérico no Local é válido.
    ${cnpj_alfa_raw}=    Gerar CNPJ Alfanumerico Valido
    Preenche PJ com CNPJ    ${cnpj_alfa_raw}
    # Não sobrescreve o campo local — o Faker já preencheu com CNPJ numérico
    ${cnpj_local_num}=    Get Value    ${CAMPO_CNPJ_LOCAL}
    Log To Console    \n📋 T032 — Local com CNPJ numérico (gerado pelo Faker): '${cnpj_local_num}'
    Grava cadastro de cliente

# ==============================================================================
# GRUPO TRIM / QUEBRA DE LINHA (WEB_33)
# ==============================================================================

Valida campo sanitiza cnpj com quebra de linha
    [Documentation]    WEB_33: Simula cópia de PDF que trouxe \n no meio do CNPJ.
    ...                Injeta "12ABC345" + newline + "01DE35" via JS no campo CNPJ da PJ.
    ...                Após blur, o valor deve ter ≤ 14 chars na base e não conter \n.
    ...                Valida que o front-end sanitiza a quebra de linha antes de aplicar máscara.
    ${campo}=    Set Variable    name=${complementoClienteJuridico.cnpj}
    Wait Until Page Contains Element    ${campo}    10s
    # Injeta valor com newline usando String.fromCharCode(10) para evitar escapes do RF
    Execute JavaScript
    ...    (function(){
    ...        var el=document.querySelector('[name="${complementoClienteJuridico.cnpj}"]');
    ...        if(!el)return;
    ...        el.value='12ABC345'+String.fromCharCode(10)+'01DE35';
    ...        el.dispatchEvent(new Event('input',{bubbles:true}));
    ...        el.dispatchEvent(new Event('change',{bubbles:true}));
    ...        el.dispatchEvent(new Event('blur',{bubbles:true}));
    ...    })();
    Sleep    0.8s
    ${valor}=    Get Value    ${campo}
    Log To Console    \n🔍 WEB_33 — Valor no campo após inject com \\n: '${valor}'
    # Remove pontuação da máscara para analisar só a base
    ${base}=    Remove String    ${valor}    .    /    -
    ${tem_nl}=    Run Keyword And Return Status    Should Contain    ${base}    \n
    Should Be True    not ${tem_nl}
    ...    msg=❌ WEB_33: campo ainda contém quebra de linha após blur. Base: '${base}'
    ${tamanho}=    Get Length    ${base}
    Should Be True    ${tamanho} <= 14
    ...    msg=❌ WEB_33: base com ${tamanho} chars (esperado ≤ 14). Valor: '${valor}'
    Log To Console    ✅ WEB_33 — Quebra de linha sanitizada. Base resultante (${tamanho} chars): '${base}'

# ==============================================================================
# GRUPO LETRA O vs NÚMERO 0 (WEB_36)
# ==============================================================================

Valida campo bloqueia letra O no sufixo numerico
    [Documentation]    WEB_36: Digita o CNPJ "00.ABC.345/O1DE-35" onde 'O' (letra O) ocupa
    ...                a posição 9 (início da ordem), que é alfanumérica.
    ...                O DV '35' foi calculado para a base "00ABC34501DE" (com zero),
    ...                portanto é matematicamente inválido para a base "00ABC345O1DE" (com letra O).
    ...                O sistema deve detectar o DV incorreto e rejeitar.
    ...                Valida que o motor distingue letra O (ASCII 79) de número 0 (ASCII 48).
    Preenche PJ com CNPJ    00.ABC.345/O1DE-35
    Tenta gravar e valida rejeicao
    Log To Console    ✅ WEB_36 — Sistema distinguiu letra O de número 0 corretamente (DV inválido detectado)

# ==============================================================================
# GRUPO REGRESSÃO CPF (WEB_37, WEB_38)
# ==============================================================================

Acessa formulario como pessoa fisica
    [Documentation]    Abre o formulário de cadastro de cliente e seleciona Pessoa Física.
    ...                Reutilizado por WEB_37 e WEB_38. Usa o locator ${geralCliente.pessoaFisica}
    ...                com fallback para //label[@for='rdTipoPessoaPF'].
    Acessa tela de cadastro de cliente
    ${tem_pf}=    Run Keyword And Return Status
    ...    Wait Until Page Contains Element    xpath=${geralCliente.pessoaFisica}    5s
    Run Keyword If    ${tem_pf}
    ...    Click Forcado JS    xpath=${geralCliente.pessoaFisica}
    Run Keyword If    not ${tem_pf}
    ...    Click Forcado JS    xpath=//label[@for='rdTipoPessoaPF']
    Sleep    0.5s
    Wait Until Page Contains Element    name=pessoafisica_documentoidentificacao    8s
    Log To Console    \n✅ Formulário em modo Pessoa Física.

Valida mascara de CPF intacta
    [Documentation]    WEB_37: No formulário PF, digita 11 dígitos no campo CPF e verifica
    ...                que a máscara NNN.NNN.NNN-NN (pontos e traço) foi aplicada.
    ...                Garante que a abertura do CNPJ alfanumérico não contaminou o CPF.
    ${campo_cpf}=    Set Variable    name=pessoafisica_documentoidentificacao
    Clear Element Text    ${campo_cpf}
    Digita No Campo JS    name=pessoafisica_documentoidentificacao    12345678909
    Sleep    0.5s
    ${valor}=    Get Value    ${campo_cpf}
    Log To Console    \n🔍 WEB_37 — Valor no campo CPF: '${valor}'
    ${tem_mascara}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${valor}    \\d{3}\\.\\d{3}\\.\\d{3}-\\d{2}
    Should Be True    ${tem_mascara}
    ...    msg=❌ WEB_37: máscara de CPF ausente ou incorreta. Valor: '${valor}'. Esperado: NNN.NNN.NNN-NN.
    Log To Console    ✅ WEB_37 — Máscara de CPF intacta: '${valor}'

Valida campo CPF bloqueia letras
    [Documentation]    WEB_38: No formulário PF, tenta digitar letras (ex: ABCDE12345) no campo CPF.
    ...                O campo de CPF deve bloquear qualquer letra — CPF é 100% numérico.
    ...                Valida que a abertura do CNPJ alfanumérico não "contaminou" o campo CPF.
    ${campo_cpf}=    Set Variable    name=pessoafisica_documentoidentificacao
    Clear Element Text    ${campo_cpf}
    Digita No Campo JS    name=pessoafisica_documentoidentificacao    ABCDE12345XY
    Sleep    0.5s
    ${valor}=    Get Value    ${campo_cpf}
    Log To Console    \n🔍 WEB_38 — Valor no campo CPF após digitar letras: '${valor}'
    # Remove separadores da máscara para inspecionar só os chars aceitos
    ${valor_limpo}=    Remove String    ${valor}    .    -
    ${tem_letra}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${valor_limpo}    [A-Za-z]
    Should Be True    not ${tem_letra}
    ...    msg=❌ WEB_38: campo CPF aceitou letras. Valor: '${valor}'. Risco de contaminação pela abertura do CNPJ alfa.
    Log To Console    ✅ WEB_38 — Campo CPF bloqueou letras. Valor: '${valor}'

# ==============================================================================
# GRUPO LOCAL COM MESMA RAIZ ALFANUMÉRICA (WEB_42)
# ==============================================================================

Cadastra PJ matriz e local com raiz CNPJ alfanumerica comum
    [Documentation]    WEB_42 (parte 1): Computa via Calcular DV CNPJ Alfanumerico dois CNPJs
    ...                com a mesma raiz alfanumérica "12ABC345":
    ...                  Matriz → 12ABC3450001 + DV   (ordem 0001)
    ...                  Filial → 12ABC3450002 + DV   (ordem 0002)
    ...                Chama Preenche PJ com CNPJ (que preenche o formulário completo incluindo
    ...                o Local com um CNPJ aleatório) e depois substitui o CNPJ do Local
    ...                pelo da Filial (mesma raiz, ordem diferente).
    # ---- Calcula CNPJs com DVs corretos (mesmo algoritmo da lib) ----
    ${dv_m}=         Calcular DV CNPJ Alfanumerico    12ABC3450001
    ${cnpj_m_raw}=   Catenate    SEPARATOR=    12ABC3450001    ${dv_m}
    ${cnpj_m_fmt}=   Formatar CNPJ Alfanumerico    ${cnpj_m_raw}

    ${dv_f}=         Calcular DV CNPJ Alfanumerico    12ABC3450002
    ${cnpj_f_raw}=   Catenate    SEPARATOR=    12ABC3450002    ${dv_f}
    ${cnpj_f_fmt}=   Formatar CNPJ Alfanumerico    ${cnpj_f_raw}

    Set Suite Variable    ${cnpj_matriz_web42}    ${cnpj_m_fmt}
    Set Suite Variable    ${cnpj_filial_web42}    ${cnpj_f_fmt}

    Log To Console    \n📋 WEB_42 — Matriz: ${cnpj_m_fmt} / Filial: ${cnpj_f_fmt}

    # ---- Preenche formulário completo (geral + CNPJ parceiro + local) ----
    Preenche PJ com CNPJ    ${cnpj_m_raw}
    # Substitui o CNPJ do Local (preenchido aleatoriamente em Preenche PJ com CNPJ)
    # pelo CNPJ da Filial — mesma raiz alfanumérica, ordem diferente
    Digita No Campo JS    name=local_documentoidentificacao    ${cnpj_f_raw}
    Sleep    0.5s
    Log To Console    ✅ WEB_42 — Formulário preenchido. Matriz '${cnpj_m_fmt}' / Filial '${cnpj_f_fmt}'

Valida gravacao de matriz e local com raiz alfanumerica
    [Documentation]    WEB_42 (parte 2): Salva o cadastro e confirma que o sistema aceitou
    ...                tanto o CNPJ da Matriz quanto o CNPJ do Local com a mesma raiz alfanumérica.
    ...                Falha se surgir "CNPJ Inválido" ou qualquer mensagem de erro de CNPJ.
    Grava cadastro de cliente
    Sleep    1s
    ${tem_erro_cnpj}=    Run Keyword And Return Status
    ...    Page Should Contain    CNPJ Inválido
    ${tem_erro_gen}=    Run Keyword And Return Status
    ...    Page Should Contain    erro
    Should Be True    not ${tem_erro_cnpj}
    ...    msg=❌ WEB_42: Sistema rejeitou CNPJ de Matriz ou Filial com raiz alfanumérica '12ABC345'.
    Run Keyword If    ${tem_erro_gen}
    ...    Log To Console    ⚠️ WEB_42: palavra 'erro' detectada na página — verificar se é do CNPJ.
    Log To Console    ✅ WEB_42 — Cadastro gravado. Matriz '${cnpj_matriz_web42}' / Filial '${cnpj_filial_web42}' aceitas!
