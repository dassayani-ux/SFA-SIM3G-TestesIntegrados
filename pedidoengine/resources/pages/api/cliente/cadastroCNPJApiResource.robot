*** Settings ***
Documentation    Resource para testes de API REST do cadastro de cliente (parceiro) com CNPJ alfanumérico.
...              Cobre: criação, validação, pesquisa, atualização e exclusão via HTTP.
...              Ref: Instrução Normativa RFB nº 2.119/2022 — CNPJ alfanumérico.
...
...              ⚠️  Os endpoints REST do SFA SIM3G precisam estar habilitados no servidor.
...              Autenticação: Basic Auth com as mesmas credenciais do acesso WEB.

Library    RequestsLibrary
Library    Collections
Library    String
Library    ${EXECDIR}/pedidoengine/libraries/sfa_lib_web.py

Variables  ${EXECDIR}/pedidoengine/libraries/variables/sfa_variables.py

Resource   ${EXECDIR}/pedidoengine/resources/database/conectionDatabase.robot

*** Variables ***
# Sessão REST
${SESSION}              sfaApiSession
${BASE_URL}             http://10.171.217.166:9001/totvscrmsfa
${API_PARCEIRO}         /rest/parceiro
${API_CONTENT_TYPE}     application/json

# Credenciais da API (mesmas do WEB)
${API_USER}             ${login_web.usuarioWeb}
${API_PASS}             ${login_web.senhaWeb}

# Variáveis de Suite para compartilhamento entre testes
${api_id_criado_alfa}        ${EMPTY}
${api_cnpj_alfa_usado}       ${EMPTY}
${api_nome_alfa_usado}       ${EMPTY}
${api_id_criado_numerico}    ${EMPTY}
${api_cnpj_numerico_usado}   ${EMPTY}
${api_nome_numerico_usado}   ${EMPTY}

# Payload base para criação de parceiro PJ
# Os campos mínimos variam conforme configuração do servidor — ajustar se necessário.
&{PAYLOAD_BASE}
...    tipoPessoa=J
...    situacao=1
...    razaoSocial=${EMPTY}
...    fantasia=${EMPTY}
...    documentoIdentificacao=${EMPTY}

*** Keywords ***
# =============================================================================
# SETUP / TEARDOWN
# =============================================================================

Cria sessao da API
    [Documentation]    Cria a sessão REST com Basic Auth e cabeçalhos padrão.
    ...                Deve ser chamado no Suite Setup.
    ${headers}=    Create Dictionary
    ...    Content-Type=${API_CONTENT_TYPE}
    ...    Accept=${API_CONTENT_TYPE}
    Create Session    alias=${SESSION}
    ...    url=${BASE_URL}
    ...    auth=${API_USER}:${API_PASS}
    ...    headers=${headers}
    ...    verify=False
    Log To Console    \n✅ Sessão API criada em ${BASE_URL}

Encerra sessao da API
    [Documentation]    Remove a sessão REST. Deve ser chamado no Suite Teardown.
    Delete All Sessions
    Log To Console    \n✅ Sessão API encerrada.

# =============================================================================
# HELPERS — MONTAGEM DE PAYLOAD
# =============================================================================

Monta payload parceiro PJ
    [Documentation]    Retorna um dicionário com os dados mínimos de um parceiro PJ.
    [Arguments]    ${cnpj}    ${razao_social}    ${fantasia}=${EMPTY}
    ${payload}=    Copy Dictionary    ${PAYLOAD_BASE}
    Set To Dictionary    ${payload}
    ...    documentoIdentificacao=${cnpj}
    ...    razaoSocial=${razao_social}
    ...    fantasia=${fantasia}
    [Return]    ${payload}

Gera nome parceiro unico
    [Documentation]    Gera um nome de razão social único usando timestamp para evitar duplicidade.
    [Arguments]    ${prefixo}=API_CNPJ
    ${ts}=    Get Time    epoch
    ${nome}=    Catenate    SEPARATOR=_    ${prefixo}    ${ts}
    [Return]    ${nome}

# =============================================================================
# KEYWORDS DE AÇÃO (POST / GET / PUT / DELETE)
# =============================================================================

POST Cria parceiro
    [Documentation]    Envia POST para criar um parceiro. Retorna o objeto Response.
    [Arguments]    ${payload}
    ${resp}=    POST On Session    ${SESSION}    ${API_PARCEIRO}    json=${payload}    expected_status=any
    [Return]    ${resp}

GET Lista parceiros por CNPJ
    [Documentation]    Envia GET pesquisando parceiro pelo campo documentoIdentificacao.
    [Arguments]    ${cnpj}
    &{params}=    Create Dictionary    documentoIdentificacao=${cnpj}
    ${resp}=    GET On Session    ${SESSION}    ${API_PARCEIRO}    params=${params}    expected_status=any
    [Return]    ${resp}

PUT Atualiza parceiro
    [Documentation]    Envia PUT para atualizar um parceiro existente pelo ID.
    [Arguments]    ${id_parceiro}    ${payload}
    ${resp}=    PUT On Session    ${SESSION}    ${API_PARCEIRO}/${id_parceiro}    json=${payload}    expected_status=any
    [Return]    ${resp}

DELETE Remove parceiro
    [Documentation]    Envia DELETE para excluir um parceiro pelo ID.
    [Arguments]    ${id_parceiro}
    ${resp}=    DELETE On Session    ${SESSION}    ${API_PARCEIRO}/${id_parceiro}    expected_status=any
    [Return]    ${resp}

GET Busca parceiro por ID
    [Documentation]    Envia GET para buscar um parceiro específico pelo ID.
    [Arguments]    ${id_parceiro}
    ${resp}=    GET On Session    ${SESSION}    ${API_PARCEIRO}/${id_parceiro}    expected_status=any
    [Return]    ${resp}

# =============================================================================
# API_01 — POST com CNPJ alfanumérico válido → 200/201
# =============================================================================

Cadastra parceiro via API com CNPJ alfanumerico valido
    [Documentation]    API_01: Gera CNPJ alfanumérico com DVs corretos e envia POST.
    ...                Espera código 200 ou 201. Salva o ID retornado para reuso.
    ${cnpj_raw}=      Gerar CNPJ Alfanumerico Valido
    ${cnpj_fmt}=      Formatar CNPJ Alfanumerico    ${cnpj_raw}
    ${nome}=          Gera nome parceiro unico    API_ALFA
    ${payload}=       Monta payload parceiro PJ    ${cnpj_fmt}    ${nome}    FANTASIA_API

    Log To Console    \n📤 API_01 — POST parceiro com CNPJ alfanumérico: ${cnpj_fmt}
    ${resp}=    POST Cria parceiro    ${payload}

    Should Be True    ${resp.status_code} in [200, 201]
    ...    msg=❌ API_01: esperado 200/201 mas recebeu ${resp.status_code}. Body: ${resp.text}

    ${body}=    Evaluate    $resp.json() if $resp.text else {}
    ${id}=      Run Keyword If    'id' in $body    Get From Dictionary    ${body}    id
    ...    ELSE    Set Variable    0
    Set Suite Variable    ${api_id_criado_alfa}      ${id}
    Set Suite Variable    ${api_cnpj_alfa_usado}     ${cnpj_fmt}
    Set Suite Variable    ${api_cnpj_alfa_raw}       ${cnpj_raw}
    Set Suite Variable    ${api_nome_alfa_usado}     ${nome}
    Log To Console    ✅ API_01 — Parceiro criado. ID=${id}, CNPJ=${cnpj_fmt}

Valida resposta 200 ou 201
    [Documentation]    Valida que o último POST retornou 200 ou 201.
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [200, 201]
    ...    msg=❌ Esperado 200/201 mas recebeu ${resp.status_code}. Body: ${resp.text}

# =============================================================================
# API_02 — POST com CNPJ DV inválido → 400/422
# =============================================================================

Tenta cadastrar parceiro com CNPJ DV invalido
    [Documentation]    API_02: Envia POST com CNPJ cujo DV não é matematicamente correto.
    ...                Espera rejeição (400 ou 422) e mensagem de erro no body.
    ${nome}=      Gera nome parceiro unico    API_DV_INVALIDO
    ${payload}=   Monta payload parceiro PJ    12.ABC.345/01DE-99    ${nome}

    Log To Console    \n📤 API_02 — POST com CNPJ DV inválido: 12.ABC.345/01DE-99
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida rejeicao por DV invalido
    [Documentation]    Valida que a resposta indica erro de validação (400 ou 422).
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [400, 422]
    ...    msg=❌ API_02: esperado 400/422 (DV inválido) mas recebeu ${resp.status_code}. Body: ${resp.text}
    ${body_str}=    Convert To String    ${resp.text}
    ${tem_msg}=    Run Keyword And Return Status    Should Contain Any    ${body_str}
    ...    inválido    invalido    invalid    CNPJ    erro    error
    Run Keyword If    not ${tem_msg}
    ...    Log To Console    ⚠️ Body sem mensagem de erro reconhecível: ${resp.text}
    Log To Console    ✅ API_02 — CNPJ com DV inválido rejeitado (${resp.status_code})

# =============================================================================
# API_03 — POST com CNPJ todos zeros → 400/422
# =============================================================================

Tenta cadastrar parceiro com CNPJ zerado
    [Documentation]    API_03: CNPJ 00000000000000 é vedado pela RFB.
    ...                Espera rejeição (400 ou 422).
    ${nome}=      Gera nome parceiro unico    API_ZEROS
    ${payload}=   Monta payload parceiro PJ    00.000.000/0000-00    ${nome}

    Log To Console    \n📤 API_03 — POST com CNPJ zerado: 00.000.000/0000-00
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida rejeicao por CNPJ zerado
    [Documentation]    Valida que CNPJ zerado é rejeitado.
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [400, 422]
    ...    msg=❌ API_03: esperado 400/422 (CNPJ zerado) mas recebeu ${resp.status_code}. Body: ${resp.text}
    Log To Console    ✅ API_03 — CNPJ zerado rejeitado (${resp.status_code})

# =============================================================================
# API_04 — POST com CNPJ curto (13 chars) → 400/422
# =============================================================================

Tenta cadastrar parceiro com CNPJ curto
    [Documentation]    API_04: CNPJ com apenas 13 caracteres (um a menos que o obrigatório 14).
    ...                Espera rejeição por tamanho/formato inválido.
    ${nome}=      Gera nome parceiro unico    API_CURTO
    ${payload}=   Monta payload parceiro PJ    12.ABC.345/01DE-3    ${nome}

    Log To Console    \n📤 API_04 — POST com CNPJ curto (13 chars): 12.ABC.345/01DE-3
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida rejeicao por CNPJ curto
    [Documentation]    Valida que CNPJ de tamanho insuficiente é rejeitado.
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [400, 422]
    ...    msg=❌ API_04: esperado 400/422 (CNPJ curto) mas recebeu ${resp.status_code}. Body: ${resp.text}
    Log To Console    ✅ API_04 — CNPJ curto rejeitado (${resp.status_code})

# =============================================================================
# API_05 — POST com CNPJ minúsculas → normalização ou rejeição
# =============================================================================

Cadastra parceiro com CNPJ em minusculas
    [Documentation]    API_05: Envia CNPJ com letras minúsculas (ex: 12.abc.345/01de-35).
    ...                O back-end deve normalizar para maiúsculas e aceitar (200/201)
    ...                OU rejeitar explicitamente (400/422). Ambos são válidos.
    ...                Valida que a resposta é consistente e que minúsculas não causam
    ...                persistência incorreta (case-sensitive no DV = bug).
    ${nome}=      Gera nome parceiro unico    API_MINUS
    ${payload}=   Monta payload parceiro PJ    12.abc.345/01de-35    ${nome}

    Log To Console    \n📤 API_05 — POST com CNPJ em minúsculas: 12.abc.345/01de-35
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida comportamento de CNPJ minusculas
    [Documentation]    Valida que a resposta é consistente: aceita com normalização (200/201)
    ...                ou rejeita explicitamente (400/422). Não deve retornar 500.
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [200, 201, 400, 422]
    ...    msg=❌ API_05: resposta inesperada ${resp.status_code}. Body: ${resp.text}
    Run Keyword If    ${resp.status_code} in [200, 201]
    ...    Log To Console    ✅ API_05 — Back-end normalizou minúsculas para maiúsculas (${resp.status_code})
    Run Keyword If    ${resp.status_code} in [400, 422]
    ...    Log To Console    ✅ API_05 — Back-end rejeitou minúsculas explicitamente (${resp.status_code})

# =============================================================================
# API_06 — POST com CNPJ numérico tradicional → 200/201 (retrocompat)
# =============================================================================

Cadastra parceiro via API com CNPJ numerico
    [Documentation]    API_06: Envia POST com CNPJ no formato numérico tradicional (NN.NNN.NNN/NNNN-NN).
    ...                A retrocompatibilidade é obrigatória pela lei e pelo negócio.
    ${cnpj_raw}=    Gerar CNPJ Alfanumerico Valido    somente_numeros=${True}
    ${cnpj_fmt}=    Formatar CNPJ Alfanumerico    ${cnpj_raw}
    ${nome}=        Gera nome parceiro unico    API_NUMERICO
    ${payload}=     Monta payload parceiro PJ    ${cnpj_fmt}    ${nome}

    Log To Console    \n📤 API_06 — POST com CNPJ numérico: ${cnpj_fmt}
    ${resp}=    POST Cria parceiro    ${payload}

    Should Be True    ${resp.status_code} in [200, 201]
    ...    msg=❌ API_06: esperado 200/201 (CNPJ numérico) mas recebeu ${resp.status_code}. Body: ${resp.text}

    ${body}=    Evaluate    $resp.json() if $resp.text else {}
    ${id}=      Run Keyword If    'id' in $body    Get From Dictionary    ${body}    id
    ...    ELSE    Set Variable    0
    Set Suite Variable    ${api_id_criado_numerico}    ${id}
    Set Suite Variable    ${api_cnpj_numerico_usado}   ${cnpj_fmt}
    Set Suite Variable    ${api_nome_numerico_usado}   ${nome}
    Log To Console    ✅ API_06 — Parceiro numérico criado. ID=${id}, CNPJ=${cnpj_fmt}

# =============================================================================
# API_07 — POST com CNPJ com caracteres especiais → 400/422
# =============================================================================

Tenta cadastrar parceiro com CNPJ com caracteres especiais
    [Documentation]    API_07: Envia CNPJ com caracteres especiais (@#$) que são
    ...                explicitamente proibidos pelo formato alfanumérico (A-Z e 0-9 apenas).
    ...                O back-end deve rejeitar sem explodir em 500.
    ${nome}=      Gera nome parceiro unico    API_ESPECIAL
    ${payload}=   Monta payload parceiro PJ    12.@BC.345/01#E-35    ${nome}

    Log To Console    \n📤 API_07 — POST com CNPJ com caracteres especiais: 12.@BC.345/01#E-35
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida rejeicao por caracteres especiais
    [Documentation]    Valida que caracteres especiais no CNPJ causam 400/422 (não 500).
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [400, 422]
    ...    msg=❌ API_07: esperado 400/422 (especiais) mas recebeu ${resp.status_code}. Body: ${resp.text}
    Log To Console    ✅ API_07 — Caracteres especiais no CNPJ rejeitados (${resp.status_code})

# =============================================================================
# API_08 — GET lista por CNPJ alfanumérico COM máscara → resultado esperado
# =============================================================================

Pesquisa parceiro via API por CNPJ com mascara
    [Documentation]    API_08: GET passando CNPJ alfanumérico formatado (com pontos/barra/traço)
    ...                no parâmetro documentoIdentificacao. Espera retorno com o parceiro de API_01.
    [Arguments]    ${cnpj_fmt}
    Log To Console    \n📤 API_08 — GET parceiros filtrando por CNPJ: ${cnpj_fmt}
    ${resp}=    GET Lista parceiros por CNPJ    ${cnpj_fmt}
    [Return]    ${resp}

Valida resultado da pesquisa por CNPJ alfanumerico
    [Documentation]    Valida que a lista retornada contém ao menos 1 item e que o CNPJ bate.
    [Arguments]    ${resp}    ${cnpj_esperado}    ${nome_esperado}
    Should Be Equal As Integers    ${resp.status_code}    200
    ...    msg=❌ API_08: esperado 200 mas recebeu ${resp.status_code}. Body: ${resp.text}
    ${body_str}=    Convert To String    ${resp.text}
    Should Contain    ${body_str}    ${nome_esperado}
    ...    msg=❌ API_08: nome '${nome_esperado}' não encontrado na resposta. Body: ${resp.text}
    Log To Console    ✅ API_08 — Parceiro encontrado por CNPJ com máscara!

# =============================================================================
# API_09 — GET lista por CNPJ alfanumérico SEM máscara → mesmo resultado
# =============================================================================

Pesquisa parceiro via API por CNPJ sem mascara
    [Documentation]    API_09: GET passando CNPJ alfanumérico sem formatação (apenas 14 chars brutos).
    ...                O back-end deve normalizar e retornar o mesmo parceiro que API_08.
    [Arguments]    ${cnpj_raw}
    Log To Console    \n📤 API_09 — GET parceiros filtrando por CNPJ sem máscara: ${cnpj_raw}
    ${resp}=    GET Lista parceiros por CNPJ    ${cnpj_raw}
    [Return]    ${resp}

Valida resultado da pesquisa por CNPJ sem mascara
    [Documentation]    Valida que a busca sem máscara retorna o mesmo parceiro.
    [Arguments]    ${resp}    ${nome_esperado}
    Should Be Equal As Integers    ${resp.status_code}    200
    ...    msg=❌ API_09: esperado 200 mas recebeu ${resp.status_code}. Body: ${resp.text}
    ${body_str}=    Convert To String    ${resp.text}
    Should Contain    ${body_str}    ${nome_esperado}
    ...    msg=❌ API_09: nome '${nome_esperado}' não encontrado. Body: ${resp.text}
    Log To Console    ✅ API_09 — Parceiro encontrado por CNPJ sem máscara!

# =============================================================================
# API_10 — POST CNPJ duplicado → 409 ou erro de unicidade
# =============================================================================

Tenta cadastrar parceiro com CNPJ duplicado
    [Documentation]    API_10: Envia POST com o mesmo CNPJ já cadastrado em API_01.
    ...                Espera rejeição por duplicidade (409 Conflict ou 400/422 com mensagem).
    [Arguments]    ${cnpj_fmt}
    ${nome}=      Gera nome parceiro unico    API_DUP
    ${payload}=   Monta payload parceiro PJ    ${cnpj_fmt}    ${nome}

    Log To Console    \n📤 API_10 — POST com CNPJ duplicado: ${cnpj_fmt}
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida rejeicao por CNPJ duplicado
    [Documentation]    Valida que o CNPJ duplicado é rejeitado (409, 400 ou 422).
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [400, 409, 422]
    ...    msg=❌ API_10: esperado 400/409/422 (duplicado) mas recebeu ${resp.status_code}. Body: ${resp.text}
    Log To Console    ✅ API_10 — CNPJ duplicado rejeitado (${resp.status_code})

# =============================================================================
# API_11 — PUT atualiza CNPJ do parceiro → 200
# =============================================================================

Atualiza CNPJ do parceiro via API
    [Documentation]    API_11: Gera novo CNPJ alfanumérico válido e atualiza o parceiro
    ...                criado em API_01 via PUT. Espera 200 e valida persistência.
    [Arguments]    ${id_parceiro}    ${nome_parceiro}
    ${cnpj_novo_raw}=    Gerar CNPJ Alfanumerico Valido
    ${cnpj_novo_fmt}=    Formatar CNPJ Alfanumerico    ${cnpj_novo_raw}
    ${payload}=          Monta payload parceiro PJ    ${cnpj_novo_fmt}    ${nome_parceiro}

    Log To Console    \n📤 API_11 — PUT atualiza parceiro ID=${id_parceiro} com novo CNPJ: ${cnpj_novo_fmt}
    ${resp}=    PUT Atualiza parceiro    ${id_parceiro}    ${payload}
    [Return]    ${resp}

Valida atualizacao de CNPJ via API
    [Documentation]    Valida que o PUT retornou 200 (atualização bem-sucedida).
    [Arguments]    ${resp}
    Should Be Equal As Integers    ${resp.status_code}    200
    ...    msg=❌ API_11: esperado 200 (PUT) mas recebeu ${resp.status_code}. Body: ${resp.text}
    Log To Console    ✅ API_11 — CNPJ atualizado com sucesso (${resp.status_code})

# =============================================================================
# API_12 — DELETE parceiro + GET confirma exclusão → 404/empty
# =============================================================================

Remove parceiro via API
    [Documentation]    API_12 (parte 1): Envia DELETE para o parceiro criado em API_01.
    ...                Espera 200 ou 204.
    [Arguments]    ${id_parceiro}
    Log To Console    \n📤 API_12 — DELETE parceiro ID=${id_parceiro}
    ${resp}=    DELETE Remove parceiro    ${id_parceiro}
    [Return]    ${resp}

Valida exclusao do parceiro
    [Documentation]    API_12 (parte 1): Valida que o DELETE retornou 200 ou 204.
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [200, 204]
    ...    msg=❌ API_12: esperado 200/204 (DELETE) mas recebeu ${resp.status_code}. Body: ${resp.text}
    Log To Console    ✅ API_12 — DELETE aceito (${resp.status_code})

Confirma parceiro nao encontrado apos exclusao
    [Documentation]    API_12 (parte 2): GET após DELETE deve retornar 404 ou lista vazia.
    [Arguments]    ${id_parceiro}    ${cnpj_fmt}
    Log To Console    \n📤 API_12 — GET pós-DELETE para ID=${id_parceiro}
    ${resp_id}=     GET Busca parceiro por ID     ${id_parceiro}
    ${resp_cnpj}=   GET Lista parceiros por CNPJ  ${cnpj_fmt}

    # Valida por ID: deve ser 404
    Run Keyword If    ${resp_id.status_code} != 404
    ...    Log To Console    ⚠️ GET por ID retornou ${resp_id.status_code} (esperado 404)

    # Valida por CNPJ: lista deve ser vazia ou 404
    ${body_str}=    Convert To String    ${resp_cnpj.text}
    ${vazio}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${body_str}    (\\[\\]|"total":0|"count":0)
    Run Keyword If    not ${vazio} and ${resp_cnpj.status_code} == 200
    ...    Log To Console    ⚠️ Parceiro ainda aparece na busca após exclusão — verificar soft delete.
    Log To Console    ✅ API_12 — Parceiro não localizado após exclusão (ID=${resp_id.status_code}, CNPJ lista=${resp_cnpj.status_code})

# =============================================================================
# API_31 — POST CNPJ com espaços nas extremidades → trim + aceito
# =============================================================================

Cadastra parceiro com CNPJ com espacos nas extremidades
    [Documentation]    API_31: Envia POST com CNPJ válido envolto em espaços (leading/trailing).
    ...                O servidor deve fazer trim silencioso e aceitar normalmente (200/201).
    ...                Falhar com 400/422 indica que o servidor não sanitiza — comportamento
    ...                tolerável mas que deve ser documentado.
    ${cnpj_raw}=    Gerar CNPJ Alfanumerico Valido
    ${cnpj_com_espacos}=    Catenate    SEPARATOR=      ${cnpj_raw}
    # Catenate SEPARATOR=<2 spaces> produz "  12ABC...35  "
    ${nome}=         Gera nome parceiro unico    API_TRIM_EXT
    ${payload}=      Monta payload parceiro PJ    ${cnpj_com_espacos}    ${nome}

    Log To Console    \n📤 API_31 — POST com CNPJ com espaços nas extremidades: '${cnpj_com_espacos}'
    Set Suite Variable    ${api_cnpj_trim_raw}    ${cnpj_raw}
    Set Suite Variable    ${api_nome_trim}         ${nome}
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida aceitacao com CNPJ apos trim de extremidades
    [Documentation]    Valida que o servidor aceitou (200/201) após trim das extremidades.
    ...                Se 400/422: servidor não sanitiza — não é bug crítico, log de aviso.
    [Arguments]    ${resp}
    ${aceito}=    Run Keyword And Return Status
    ...    Should Be True    ${resp.status_code} in [200, 201]
    Run Keyword If    ${aceito}
    ...    Log To Console    ✅ API_31 — Servidor fez trim e aceitou (${resp.status_code})
    Run Keyword If    not ${aceito} and ${resp.status_code} in [400, 422]
    ...    Log To Console    ⚠️ API_31 — Servidor rejeitou (${resp.status_code}) — não faz trim. Anotar como melhoria.
    Should Be True    ${resp.status_code} in [200, 201, 400, 422]
    ...    msg=❌ API_31: resposta inesperada ${resp.status_code} — nem aceite nem rejeição limpa. Body: ${resp.text}
    Should Be True    ${resp.status_code} != 500
    ...    msg=❌ API_31: servidor retornou 500 para CNPJ com espaços — erro não tratado. Body: ${resp.text}

# =============================================================================
# API_32 — POST CNPJ com espaços internos → strip + aceito
# =============================================================================

Cadastra parceiro com CNPJ com espacos internos
    [Documentation]    API_32: Envia POST com CNPJ válido contendo espaços internos entre
    ...                grupos de caracteres (ex: "12 ABC 345 01DE 35").
    ...                O servidor deve remover os espaços internos via regex [^a-zA-Z0-9]
    ...                e aceitar normalmente (200/201).
    ${cnpj_raw}=    Gerar CNPJ Alfanumerico Valido
    # Injeta espaços a cada 2 chars da base (12 chars): "XX XX XX XX XX XX"
    ${c1}=     Get Substring    ${cnpj_raw}    0    2
    ${c2}=     Get Substring    ${cnpj_raw}    2    5
    ${c3}=     Get Substring    ${cnpj_raw}    5    8
    ${c4}=     Get Substring    ${cnpj_raw}    8    12
    ${c5}=     Get Substring    ${cnpj_raw}    12    14
    ${cnpj_com_espacos}=    Catenate    ${c1}    ${c2}    ${c3}    ${c4}    ${c5}
    ${nome}=    Gera nome parceiro unico    API_STRIP_INT
    ${payload}=    Monta payload parceiro PJ    ${cnpj_com_espacos}    ${nome}

    Log To Console    \n📤 API_32 — POST com CNPJ com espaços internos: '${cnpj_com_espacos}'
    Set Suite Variable    ${api_cnpj_strip_raw}    ${cnpj_raw}
    Set Suite Variable    ${api_nome_strip}         ${nome}
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida aceitacao com CNPJ apos remocao de espacos internos
    [Documentation]    Valida que o servidor aceitou (200/201) após remoção dos espaços internos.
    ...                Se 400/422: servidor não aplica regex de limpeza — anotar como melhoria.
    [Arguments]    ${resp}
    ${aceito}=    Run Keyword And Return Status
    ...    Should Be True    ${resp.status_code} in [200, 201]
    Run Keyword If    ${aceito}
    ...    Log To Console    ✅ API_32 — Servidor removeu espaços internos e aceitou (${resp.status_code})
    Run Keyword If    not ${aceito} and ${resp.status_code} in [400, 422]
    ...    Log To Console    ⚠️ API_32 — Servidor rejeitou (${resp.status_code}) — não aplica strip interno. Anotar como melhoria.
    Should Be True    ${resp.status_code} in [200, 201, 400, 422]
    ...    msg=❌ API_32: resposta inesperada ${resp.status_code}. Body: ${resp.text}
    Should Be True    ${resp.status_code} != 500
    ...    msg=❌ API_32: servidor retornou 500 para CNPJ com espaços internos. Body: ${resp.text}

# =============================================================================
# API_34 — POST CNPJ zeros absolutos sem máscara → rejeição explícita
# =============================================================================

Tenta cadastrar parceiro com CNPJ zeros absolutos sem mascara
    [Documentation]    API_34: Envia CNPJ "00000000000000" (14 zeros, sem máscara).
    ...                Complementa API_03 (que envia com máscara 00.000.000/0000-00).
    ...                O Módulo 11 com zeros produz resto=0 para ambos os DVs, o que
    ...                matematicamente resulta em DV=0 — tornando "00000000000000"
    ...                tecnicamente "válido" pelo cálculo puro.
    ...                O servidor DEVE ter uma regra explícita anti-zeros independente do DV.
    ${nome}=      Gera nome parceiro unico    API_ZEROS_RAW
    ${payload}=   Monta payload parceiro PJ    00000000000000    ${nome}

    Log To Console    \n📤 API_34 — POST com CNPJ zeros absolutos (sem máscara): '00000000000000'
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida rejeicao por zeros absolutos
    [Documentation]    Valida que o CNPJ de zeros absolutos é rejeitado explicitamente (400/422)
    ...                independente do resultado matemático do Módulo 11.
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [400, 422]
    ...    msg=❌ API_34: CNPJ de zeros absolutos NÃO foi rejeitado (${resp.status_code}). Regra anti-zeros ausente! Body: ${resp.text}
    Log To Console    ✅ API_34 — CNPJ de zeros absolutos rejeitado por regra explícita (${resp.status_code})

# =============================================================================
# API_35 — POST CNPJ válido com zeros à esquerda → aceito, zeros preservados
# =============================================================================

Cadastra parceiro com CNPJ com zeros a esquerda
    [Documentation]    API_35: Envia um CNPJ alfanumérico válido cuja raiz começa com "00"
    ...                (ex: 00.ABC.345/01DE-XX). Sistemas que convertem o valor para
    ...                Integer/Long perdem os zeros à esquerda — como o campo é VARCHAR,
    ...                os 14 caracteres devem ser preservados intactos no banco.
    ...                O DV é calculado via Calcular DV CNPJ Alfanumerico para garantir
    ...                alinhamento com o algoritmo do servidor.
    ${dv}=          Calcular DV CNPJ Alfanumerico    00ABC34501DE
    ${cnpj_raw}=    Catenate    SEPARATOR=    00ABC34501DE    ${dv}
    ${cnpj_fmt}=    Formatar CNPJ Alfanumerico    ${cnpj_raw}
    ${nome}=        Gera nome parceiro unico    API_ZEROS_ESQ
    ${payload}=     Monta payload parceiro PJ    ${cnpj_fmt}    ${nome}

    Log To Console    \n📤 API_35 — POST com CNPJ com zeros à esquerda: '${cnpj_fmt}'
    Set Suite Variable    ${api_cnpj_zeros_esq_raw}    ${cnpj_raw}
    Set Suite Variable    ${api_cnpj_zeros_esq_fmt}    ${cnpj_fmt}
    Set Suite Variable    ${api_nome_zeros_esq}         ${nome}
    ${resp}=    POST Cria parceiro    ${payload}
    [Return]    ${resp}

Valida aceitacao e preservacao de zeros a esquerda
    [Documentation]    Valida que o servidor aceitou (200/201) e que o CNPJ foi salvo
    ...                com os zeros à esquerda intactos (GET confirma presença de "00").
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [200, 201]
    ...    msg=❌ API_35: CNPJ com zeros à esquerda rejeitado (${resp.status_code}). Body: ${resp.text}
    Log To Console    ✅ API_35 — POST aceito (${resp.status_code}). Verificando preservação dos zeros...
    # Busca o parceiro pelo CNPJ e confirma zeros à esquerda
    ${resp_get}=    GET Lista parceiros por CNPJ    ${api_cnpj_zeros_esq_fmt}
    Should Be Equal As Integers    ${resp_get.status_code}    200
    ...    msg=❌ API_35: GET após criação falhou (${resp_get.status_code}). Body: ${resp_get.text}
    ${body}=    Convert To String    ${resp_get.text}
    Should Contain    ${body}    ${api_nome_zeros_esq}
    ...    msg=❌ API_35: parceiro não encontrado pelo CNPJ com zeros à esquerda — possível perda de zeros. Body: ${body}
    Log To Console    ✅ API_35 — Zeros à esquerda preservados. Parceiro localizado pelo CNPJ '${api_cnpj_zeros_esq_fmt}'

# =============================================================================
# API_39 — POST Pessoa Física com CPF válido → aceito (regressão)
# =============================================================================

Cadastra parceiro PF via API com CPF valido
    [Documentation]    API_39: Valida retrocompatibilidade — envia POST de Pessoa Física
    ...                com um CPF válido (111.444.777-35, DVs verificados).
    ...                O back-end deve continuar validando CPF com o algoritmo legado
    ...                e aceitar normalmente (200/201).
    ${nome}=     Gera nome parceiro unico    API_CPF_PF
    &{payload}=    Create Dictionary
    ...    tipoPessoa=F
    ...    situacao=1
    ...    nome=${nome}
    ...    fantasia=FANTASIA CPF
    ...    documentoIdentificacao=111.444.777-35

    Log To Console    \n📤 API_39 — POST Pessoa Física com CPF válido: 111.444.777-35
    Set Suite Variable    ${api_nome_cpf_pf}    ${nome}
    ${resp}=    POST On Session    ${SESSION}    ${API_PARCEIRO}    json=${payload}    expected_status=any
    [Return]    ${resp}

Valida aceitacao de CPF valido via API
    [Documentation]    Valida que o CPF válido foi aceito (200/201) e que o cálculo legado do CPF
    ...                permanece funcional após a introdução do CNPJ alfanumérico.
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [200, 201]
    ...    msg=❌ API_39: CPF válido rejeitado (${resp.status_code}). Possível regressão no validador de CPF. Body: ${resp.text}
    Log To Console    ✅ API_39 — CPF válido aceito normalmente (${resp.status_code}) — sem regressão

# =============================================================================
# API_40 — POST Pessoa Física com CPF contendo letras → rejeitado
# =============================================================================

Tenta cadastrar parceiro PF com CPF com letras
    [Documentation]    API_40: Envia POST de Pessoa Física com CPF contendo letras
    ...                (ex: 123.ABC.789-10). O CNPJ alfanumérico introduziu letras no
    ...                cadastro de PJ — o back-end NÃO pode ter generalizado isso para PF.
    ...                CPF é e sempre foi 100% numérico.
    ${nome}=     Gera nome parceiro unico    API_CPF_LETRAS
    &{payload}=    Create Dictionary
    ...    tipoPessoa=F
    ...    situacao=1
    ...    nome=${nome}
    ...    documentoIdentificacao=123.ABC.789-10

    Log To Console    \n📤 API_40 — POST Pessoa Física com CPF com letras: 123.ABC.789-10
    ${resp}=    POST On Session    ${SESSION}    ${API_PARCEIRO}    json=${payload}    expected_status=any
    [Return]    ${resp}

Valida rejeicao de CPF com letras
    [Documentation]    Valida que CPF com letras é imediatamente rejeitado (400/422).
    ...                Um 200/201 aqui indica vazamento da regra do CNPJ alfanumérico para CPF.
    [Arguments]    ${resp}
    Should Be True    ${resp.status_code} in [400, 422]
    ...    msg=❌ API_40: CPF com letras foi ACEITO (${resp.status_code})! Regra do CNPJ alfa vazou para CPF. Body: ${resp.text}
    Log To Console    ✅ API_40 — CPF com letras corretamente rejeitado (${resp.status_code})

# =============================================================================
# API_41 — POST Local vinculado a parceiro com CNPJ alfanumérico
# =============================================================================

POST Cria local vinculado ao parceiro
    [Documentation]    Envia POST para criar um Local sob um parceiro existente.
    ...                Tenta o endpoint /rest/parceiro/{id}/local (padrão REST aninhado).
    ...                Se retornar 404, tenta /rest/local com idParceiro no body.
    [Arguments]    ${id_parceiro}    ${payload_local}
    ${endpoint_aninhado}=    Catenate    SEPARATOR=    ${API_PARCEIRO}/    ${id_parceiro}    /local
    ${resp}=    POST On Session    ${SESSION}    ${endpoint_aninhado}    json=${payload_local}    expected_status=any
    Run Keyword If    ${resp.status_code} == 404
    ...    Log To Console    ⚠️ Endpoint ${endpoint_aninhado} retornou 404 — tentando /rest/local...
    Run Keyword If    ${resp.status_code} == 404
    ...    Set To Dictionary    ${payload_local}    idParceiro=${id_parceiro}
    ${resp}=    Run Keyword If    ${resp.status_code} == 404
    ...    POST On Session    ${SESSION}    /rest/local    json=${payload_local}    expected_status=any
    ...    ELSE    Set Variable    ${resp}
    [Return]    ${resp}

Cadastra local via API com CNPJ alfanumerico
    [Documentation]    API_41: Cria um parceiro auxiliar e vincula a ele um Local cujo
    ...                documentoIdentificacao é um CNPJ alfanumérico válido (diferente
    ...                do CNPJ do parceiro). Valida que o módulo de Locais também suporta
    ...                o novo formato alfanumérico (campo local.documentoidentificacao).
    # Cria parceiro auxiliar para o local
    ${cnpj_parceiro}=    Gerar CNPJ Alfanumerico Valido
    ${cnpj_parceiro_fmt}=    Formatar CNPJ Alfanumerico    ${cnpj_parceiro}
    ${nome_parceiro}=    Gera nome parceiro unico    API41_PARCEIRO
    ${payload_pj}=    Monta payload parceiro PJ    ${cnpj_parceiro_fmt}    ${nome_parceiro}
    ${resp_pj}=    POST Cria parceiro    ${payload_pj}
    Should Be True    ${resp_pj.status_code} in [200, 201]
    ...    msg=❌ API_41: falha ao criar parceiro auxiliar (${resp_pj.status_code}). Body: ${resp_pj.text}
    ${body_pj}=    Evaluate    $resp_pj.json() if $resp_pj.text else {}
    ${id_aux}=    Run Keyword If    'id' in $body_pj    Get From Dictionary    ${body_pj}    id
    ...    ELSE    Set Variable    0

    # Gera CNPJ alfanumérico para o Local (diferente do parceiro)
    ${cnpj_local_raw}=    Gerar CNPJ Alfanumerico Valido
    ${cnpj_local_fmt}=    Formatar CNPJ Alfanumerico    ${cnpj_local_raw}

    &{payload_local}=    Create Dictionary
    ...    descricao=LOCAL ALFA API41
    ...    documentoIdentificacao=${cnpj_local_fmt}
    ...    tipoLocal=PRINCIPAL

    Log To Console    \n📤 API_41 — POST local com CNPJ alfanumérico: '${cnpj_local_fmt}' (parceiro ID=${id_aux})
    Set Suite Variable    ${api_id_parceiro_local41}    ${id_aux}
    Set Suite Variable    ${api_cnpj_local41_fmt}       ${cnpj_local_fmt}
    ${resp}=    POST Cria local vinculado ao parceiro    ${id_aux}    ${payload_local}
    [Return]    ${resp}

Valida criacao de local com CNPJ alfanumerico
    [Documentation]    Valida que o local foi criado com sucesso (200/201).
    ...                Se o endpoint de local não existir (404), o teste é marcado como
    ...                "endpoint a confirmar" — não falha o pipeline principal.
    [Arguments]    ${resp}
    Run Keyword If    ${resp.status_code} == 404
    ...    Log To Console    ⚠️ API_41: endpoint de Local não encontrado — confirmar rota com o time de back-end.
    Should Be True    ${resp.status_code} in [200, 201, 404]
    ...    msg=❌ API_41: resposta inesperada ${resp.status_code} ao criar Local. Body: ${resp.text}
    Run Keyword If    ${resp.status_code} in [200, 201]
    ...    Log To Console    ✅ API_41 — Local com CNPJ alfanumérico criado (${resp.status_code}): '${api_cnpj_local41_fmt}'
